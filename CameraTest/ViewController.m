//
//  ViewController.m
//  CameraTest
//
//  Created by Boisy Pitre on 1/28/16.
//  Copyright © 2016 Affectiva. All rights reserved.
//

#import "ViewController.h"
#import "AnimationController.h"
#define YOUR_AFFDEX_LICENSE_STRING_GOES_HERE @"{\"token\": \"cf4d264dec5e288f61fbc53e92dbe269ee342aa149a4ec77544e0b956ef74e89\", \"licensor\": \"Affectiva Inc.\", \"expires\": \"2016-04-17\", \"developerId\": \"rp493@cornell.edu\", \"software\": \"Affdex SDK\"}"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (strong, nonatomic)  AnimationController*visualizer;
@end

@implementation ViewController
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;

#pragma mark -
#pragma mark Convenience Methods

// This is a convenience method that is called by the detector:hasResults:forImage:atTime: delegate method below.
// You will want to do something with the face (or faces) found.
- (void)processedImageReady:(AFDXDetector *)detector image:(UIImage *)image faces:(NSDictionary *)faces atTime:(NSTimeInterval)time;
{
    
    // iterate on the values of the faces dictionary
    for (AFDXFace *face in [faces allValues])
    {
        NSDictionary *faceData = face.userInfo;
        NSArray *viewControllers = [faceData objectForKey:@"viewControllers"];
        NSString *smileValue=[NSString stringWithFormat:@"%f", face.expressions.smile];
        NSString *smirkValue=[NSString stringWithFormat:@"%f", face.expressions.smirk];
        NSString *puckerValue=[NSString stringWithFormat:@"%f", face.expressions.lipPucker];
        NSString *mouthPucker=[NSString stringWithFormat:@"%f", face.expressions.mouthOpen];
        NSLog(smirkValue);
      
        CAEmitterLayer*Layerx=[_visualizer layer];
        [Layerx setEmitterPosition:CGPointMake(300,300)];
        NSArray *allcells=[Layerx emitterCells];
        CAEmitterCell *cell1=allcells[0];
        cell1.color=[[UIColor colorWithRed:face.expressions.smile green:face.expressions.smile blue:face.expressions.smile alpha:0.8f] CGColor];
        
        label1.text=smileValue;
        label2.text=smirkValue;
        label3.text=puckerValue;
        label4.text=mouthPucker;
        

        
    }
}

// This is a convenience method that is called by the detector:hasResults:forImage:atTime: delegate method below.
// It handles all UNPROCESSED images from the detector. Here I am displaying those images on the camera view.
- (void)unprocessedImageReady:(AFDXDetector *)detector image:(UIImage *)image atTime:(NSTimeInterval)time;
{
    __block ViewController *weakSelf = self;
    
    // UI work must be done on the main thread, so dispatch it there.
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.cameraView setImage:image];
    });
}

- (void)destroyDetector;
{
    [self.detector stop];
}

- (void)createDetector;
{
    // ensure the detector has stopped
    [self destroyDetector];
    
    // create a new detector, set the processing frame rate in frames per second, and set the license string
    self.detector = [[AFDXDetector alloc] initWithDelegate:self usingCamera:AFDX_CAMERA_FRONT maximumFaces:1];
    self.detector.maxProcessRate = 5;
    self.detector.licenseString = YOUR_AFFDEX_LICENSE_STRING_GOES_HERE;
    
    // turn on all classifiers (emotions, expressions, and emojis)
    [self.detector setDetectAllEmotions:YES];
    [self.detector setDetectAllExpressions:YES];
    [self.detector setDetectEmojis:YES];
    
    // turn on gender and glasses
    self.detector.gender = TRUE;
    self.detector.glasses = TRUE;
    
    // start the detector and check for failure
    NSError *error = [self.detector start];
    
    if (nil != error)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Detector Error"
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:
         ^{}
         ];
        
        return;
    }
}


#pragma mark -
#pragma mark AFDXDetectorDelegate Methods

// This is the delegate method of the AFDXDetectorDelegate protocol. This method gets called for:
// - Every frame coming in from the camera. In this case, faces is nil
// - Every PROCESSED frame that the detector
- (void)detector:(AFDXDetector *)detector hasResults:(NSMutableDictionary *)faces forImage:(UIImage *)image atTime:(NSTimeInterval)time;
{
    if (nil == faces)
    {
        [self unprocessedImageReady:detector image:image atTime:time];
    }
    else
    {
        [self processedImageReady:detector image:image faces:faces atTime:time];
    }
}


#pragma mark -
#pragma mark View Methods

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self createDetector];
    self.visualizer = [[AnimationController alloc] initWithFrame:self.view.frame];
    [_visualizer setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundView addSubview:_visualizer];
    
        // create the dector just before the view appears
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    [self destroyDetector]; // destroy the detector before the view disappears
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

@end
