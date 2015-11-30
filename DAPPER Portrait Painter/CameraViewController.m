//
//  CameraViewController.m
//  LLSimpleCameraExample
//

#import "CameraViewController.h"
#import "ViewUtils.h"
#import "DrawingViewController.h"
#import "UIImage+Resize.h"

@interface CameraViewController ()
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIImageView * maskImageView;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto];
    
    // attach to the view and assign a delegate
    [self.camera attachToViewController:self withDelegate:self];
    
    // set the camera view frame to size and origin required for your app
    self.camera.view.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;
    
    
    // ----- camera buttons -------- //
    
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle camera positions
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(0, 0, 29.0f + 20.0f, 22.0f + 20.0f);
    [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    // button to toggle camera positions
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 50.0f, 50.0f);
    [self.backButton setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
//    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    float ratio = screenRect.size.width / 320.0f;
    self.maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 430.0f * ratio)];
    [self.maskImageView setImage:[UIImage imageNamed:@"mask.png"]];
    [self.view addSubview:self.maskImageView];
    
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"gotoDrawing"]) {
        DrawingViewController * vc = segue.destinationViewController;
        vc.originImg = (UIImage*) sender;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

/* camera buttons */
- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}
- (void)backButtonPressed:(UIButton *) button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)snapButtonPressed:(UIButton *)button {
    
    // capture the image, delegate will be executed
    [self.camera capture];
}

/* camera delegates */
- (void)cameraViewController:(LLSimpleCamera *)cameraVC didCaptureImage:(UIImage *)selectedImage {
    
    // we should stop the camera, since we don't need it anymore. We will open a new vc.
    [self.camera stop];

    
#define MAX_WIDTH 320
#define MAX_HEIGHT 480
    
    float width = selectedImage.size.width;
    float height = selectedImage.size.height;

    NSLog(@"origin width = %f, height = %f", width, height);
    
//    selectedImage = [UIImage resizedImage:selectedImage inSize:CGSizeMake(MAX_WIDTH, height * MAX_WIDTH/width)];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    selectedImage = [UIImage resizedImage:selectedImage inSize:screenBound.size];
//    selectedImage = [UIImage resizedImage:selectedImage inSize:CGSizeMake(screenBound.size.width, height * screenBound.size.width/width)];
    
    
    NSLog(@"new width = %f, height = %f", selectedImage.size.width, selectedImage.size.height);
    
    UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
    
//    if (width > MAX_WIDTH) {
//        
//    }
//    
//    width = selectedImage.size.width;
//    height = selectedImage.size.height;
//    
//    if (height > MAX_HEIGHT) {
//        selectedImage = [selectedImage resizedImageToSize:CGSizeMake(width * MAX_HEIGHT/height, MAX_HEIGHT)];
//    }
    
    [self performSegueWithIdentifier:@"gotoDrawing" sender:selectedImage];
}

- (void)cameraViewController:(LLSimpleCamera *)cameraVC didChangeDevice:(AVCaptureDevice *)device {
    
    // device changed, check if flash is available
}

/* other lifecycle methods */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.contentBounds;
    
    self.snapButton.center = self.view.contentCenter;
    self.snapButton.bottom = self.view.height - 15;
    
    self.switchButton.top = 5.0f;
    self.switchButton.right = self.view.width - 5.0f;
    
    self.backButton.top = 5.0f;
    self.backButton.left = 5.0f;
    
    self.maskImageView.center = self.view.center;

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

