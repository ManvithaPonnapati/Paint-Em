#import "AnimationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimationController {
    CAEmitterLayer *emitterLayer;
    CGColor *ColorCell;
}

// 1
+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    ColorCell=[[UIColor colorWithRed:4.0f green:0.6f blue:255.0f alpha:0.8f] CGColor];
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        emitterLayer = (CAEmitterLayer *)self.layer;
        
        // 2
        CGRect bounds = [[UIScreen mainScreen] bounds];
        emitterLayer.emitterPosition = CGPointMake(bounds.size.width / 2, bounds.size.height / 2); //center of rectangle
        
        emitterLayer.emitterSize = bounds.size;
        emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        // 3
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.name = @"cell";
        cell.contents = (id)[[UIImage imageNamed:@"bokeh.png"] CGImage];
        
        // 4
        cell.color =ColorCell;
        cell.redRange = 0.46f;
        cell.greenRange = 0.49f;
        cell.blueRange = 0.67f;
        cell.alphaRange = 0.55f;
        
        // 5
        cell.redSpeed = 0.11f;
        cell.greenSpeed = 0.07f;
        cell.blueSpeed = -0.25f;
        cell.alphaSpeed = 0.15f;
        
        // 6
        cell.scale = 1.25f;
        cell.scaleRange = 1.25f;
        cell.scaleSpeed=1.25f;
        // 7
        cell.lifetime = 0.5f;
        cell.lifetimeRange = .25f;
        cell.birthRate = 130;
        
        // 8
        cell.velocity = 100.0f;
        cell.velocityRange = 300.0f;
        cell.emissionRange = M_PI*10;
      
        // 9
        emitterLayer.emitterCells = @[cell];
        
    }
    return self;
}- (void)update
{
   
}

@end