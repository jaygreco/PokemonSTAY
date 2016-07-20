#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>
#import "MapKit/MapKit.h"
#import "POControlView.h"

@interface CLLocation(Swizzle)

@end

@implementation CLLocation(Swizzle)

static float x = -1;
static float y = -1;

static float controlOffsetX = 0;
static float controlOffsetY = 0;

static POControlView *controlV;

static MKMapView *myMapView;
static UIButton *leavebutton;

bool tag = false;

CLLocationCoordinate2D pos;

+ (void) load {
    Method m1 = class_getInstanceMethod(self, @selector(coordinate));
    Method m2 = class_getInstanceMethod(self, @selector(coordinate_));
    
    method_exchangeImplementations(m1, m2);
    
    Method m3 = class_getInstanceMethod(self, @selector(onClientEventLocation));
    Method m4 = class_getInstanceMethod(self, @selector(onClientEventLocation_));
    
    method_exchangeImplementations(m3, m4);
    
    Method m5 = class_getInstanceMethod(self, @selector(setDelegate));
    Method m6 = class_getInstanceMethod(self, @selector(setDelegate_));
    
    method_exchangeImplementations(m5, m6);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_x"]) {
        x = [[[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_x"] floatValue];
    };
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_y"]) {
        y = [[[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_y"] floatValue];
    };
    
    // init
    [self controlView];
}

-(void)setDelegate_:(id<CLLocationManagerDelegate>)delegate {
    [self setDelegate_:delegate];
}

- (CLLocationCoordinate2D) coordinate_ {
    
    pos = [self coordinate_];
    //Default location Times Square NYC
    if (x == -1 && y == -1) {
        x = pos.latitude - (40.758875);
        y = pos.longitude - (-73.985129);
        [[NSUserDefaults standardUserDefaults] setValue:@(x) forKey:@"_fake_x"];
        [[NSUserDefaults standardUserDefaults] setValue:@(y) forKey:@"_fake_y"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return CLLocationCoordinate2DMake(pos.latitude+x + (controlOffsetX), pos.longitude+y + (controlOffsetY));
}

- (void)onClientEventLocation_:(id)foo {
    int i = 0;
    i++;
}

+(POControlView *)controlView{
    if (!controlV) {
        controlV = [[POControlView alloc] init];
        controlV.controlCallback =  ^(POControlViewDirection direction){
            switch (direction) {
                case POControlViewDirectionUp:
                    x+=self.controlOffset;
                    break;
                case POControlViewDirectionDown:
                    x-=self.controlOffset;
                    break;
                case POControlViewDirectionLeft:
                    y-=self.controlOffset;
                    break;
                case POControlViewDirectionRight:
                    y+=self.controlOffset;
                    break;
                default:
                    break;
            }
        };
        
        // add to key window
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[[UIApplication sharedApplication] keyWindow] addSubview:controlV];
            controlV.layer.cornerRadius = 5;
            controlV.layer.masksToBounds = YES;
            
            //add an info button
            UIButton *helpButton =  [UIButton buttonWithType:UIButtonTypeInfoDark ] ;
            CGRect buttonRect = helpButton.frame;

            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenHeight = screenRect.size.height;
            
            buttonRect.origin.x = 30;
            buttonRect.origin.y = screenHeight - 110;
            [helpButton setFrame:buttonRect];
            
            [helpButton addTarget:self action:@selector(doMap) forControlEvents:UIControlEventTouchUpInside];
            [[[UIApplication sharedApplication] keyWindow] addSubview:helpButton];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [helpButton addGestureRecognizer:longPress];
            [longPress release];
            
        });
    }
    return controlV;
}

+(void)longPress:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press");
        
        if(tag == false) {
            controlV.hidden = true;
            tag = true;
        }
        else {
            controlV.hidden = false;
            tag = false;
        }
    }
}

+(float)controlOffset{
    return [self randFloatBetween:0.000250 to:0.000300];
}

+(float) randFloatBetween:(float)low to:(float)high
{
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

+(void)doMap{
    myMapView = [[MKMapView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    myMapView.alpha = 0.85;
    
    leavebutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 50)];
    [leavebutton setTitle:@"Done" forState:UIControlStateNormal];
    [leavebutton addTarget:self action:@selector(leaveMap) forControlEvents:UIControlEventTouchUpInside];
    [leavebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    
    myMapView.showsUserLocation = YES;
    myMapView.userTrackingMode = MKUserTrackingModeFollow;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:myMapView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:leavebutton];
    
    //set the long press gesture recognizer
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [myMapView addGestureRecognizer:longPressGesture];
}

+(void)leaveMap{
    [myMapView removeFromSuperview];
    [leavebutton removeFromSuperview];
}

+(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [myMapView removeGestureRecognizer:sender];
        //dismiss view as well
        [myMapView removeFromSuperview];
        [leavebutton removeFromSuperview];
    }
    else
    {
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:myMapView];
        CLLocationCoordinate2D locCoord = [myMapView convertPoint:point toCoordinateFromView:myMapView];
        
        NSNumber *latitude = [NSNumber numberWithFloat:locCoord.latitude];
        NSNumber *longitude = [NSNumber numberWithFloat:locCoord.longitude];
        NSLog(@"lat: %@ long: %@", latitude, longitude);
        
        x = latitude.floatValue - pos.latitude;
        y = longitude.floatValue - pos.longitude;
        
        [[NSUserDefaults standardUserDefaults] setValue:@(x) forKey:@"_fake_x"];
        [[NSUserDefaults standardUserDefaults] setValue:@(y) forKey:@"_fake_y"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end