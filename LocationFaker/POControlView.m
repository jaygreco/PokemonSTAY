#import "POControlView.h"

@implementation POControlView

- (instancetype)init{
    if (self=[super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.frame = CGRectMake(screenWidth-120, screenHeight-175, 100, 100);
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    
    UIButton *up = [[UIButton alloc] initWithFrame:CGRectMake(25, -10, 50, 50)];
    [up setTitle:@"↑" forState:UIControlStateNormal];
    up.titleLabel.font = [UIFont systemFontOfSize:20.0];
    up.tag = 101;
    [up addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:up];
    

    UIButton *down = [[UIButton alloc] initWithFrame:CGRectMake(25, 60, 50, 50)];
    [down setTitle:@"↓" forState:UIControlStateNormal];
    down.titleLabel.font = [UIFont systemFontOfSize:20.0];
    down.tag = 102;
    [down addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:down];
    
    
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(-10, 25, 50, 50)];
    [left setTitle:@"←" forState:UIControlStateNormal];
    left.titleLabel.font = [UIFont systemFontOfSize:20.0];
    left.tag = 103;
    [left addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:left];
    
    
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(60, 25, 50, 50)];
    [right setTitle:@"→" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:20.0];
    right.tag = 104;
    [right addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:right];
    
}

- (void)buttonAction:(UIButton *)sender{
    [sender.layer addAnimation:[self scaleAnimation] forKey:@"scale"];
    
    if (self.controlCallback) {
        POControlViewDirection direction;
        switch (sender.tag) {
            case 101:
                direction = POControlViewDirectionUp;
                break;
            case 102:
                direction = POControlViewDirectionDown;
                break;
            case 103:
                direction = POControlViewDirectionLeft;
                break;
            case 104:
                direction = POControlViewDirectionRight;
                break;
                
            default:
                break;
        }
        
        self.controlCallback(direction);
    }
}

- (CAAnimation *)scaleAnimation{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @1.5;
    return scale;
}

@end
