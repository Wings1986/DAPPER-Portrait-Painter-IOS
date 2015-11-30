//
//  OptionViewController.m
//  DAPPER Portrait Painter
//
//  Created by iGold on 2/27/15.
//  Copyright (c) 2015 FORMULUS LLC. All rights reserved.
//

#import "OptionViewController.h"
#import "MyCollectionViewCell.h"
#import "MySupplementaryView.h"
#import "DrawingViewController.h"

#import "HomeViewController.h"
#import "AppDelegate.h"


#import "URBAlertView.h"

#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>//mail controller


@interface OptionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UITextField *tfName;
    
    IBOutlet UICollectionView *mCollectionView;
    
    NSArray * arryImages;
    
}

@property (nonatomic, strong)     UIDocumentInteractionController * docFile;

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    UIImageView* s = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
//    s.image = _captureImage;
//    [self.view addSubview:s];
    
    arryImages = @[
                   @{@"title" : @"free",
                     @"value" : @[
                             @{@"img":@"proframe01", @"tag":@"0"},
                             @{@"img":@"proframe05", @"tag":@"0"},
                             @{@"img":@"proframe12", @"tag":@"0"},
                             
                             @{@"img":@"clothing05", @"tag":@"1"},
                             @{@"img":@"clothing10", @"tag":@"1"},
                             @{@"img":@"clothing12", @"tag":@"1"},
                             @{@"img":@"clothing14", @"tag":@"1"},
                             
                             @{@"img":@"hat02", @"tag":@"2"},
                             @{@"img":@"hat05", @"tag":@"2"},
                             @{@"img":@"hat06", @"tag":@"2"},
                             @{@"img":@"hat07", @"tag":@"2"},
                             @{@"img":@"hat24", @"tag":@"2"},
                             @{@"img":@"hat30", @"tag":@"2"},
                            
                             @{@"img":@"bowtie04", @"tag":@"5"},
                             @{@"img":@"bowtie05", @"tag":@"5"},
                             @{@"img":@"glasses03", @"tag":@"5"},
                             @{@"img":@"ruff01", @"tag":@"5"},
                             ]},
                   @{@"title" : @"$.20",
                     @"value" : @[
                             @{@"img":@"proframe06", @"tag":@"0"},
                             @{@"img":@"proframe07", @"tag":@"0"},
                             @{@"img":@"proframe08", @"tag":@"0"},
                             @{@"img":@"proframe09", @"tag":@"0"},
                             @{@"img":@"proframe11", @"tag":@"0"},
                             @{@"img":@"proframe13", @"tag":@"0"},
                             
                             @{@"img":@"clothing06", @"tag":@"1"},
                             @{@"img":@"clothing07", @"tag":@"1"},
                             @{@"img":@"clothing13", @"tag":@"1"},
                             @{@"img":@"clothing15", @"tag":@"1"},
                             
                             @{@"img":@"hat01", @"tag":@"2"},
                             @{@"img":@"hat08", @"tag":@"2"},
                             @{@"img":@"hat20", @"tag":@"2"},
                             @{@"img":@"hat21", @"tag":@"2"},
                             @{@"img":@"hat22", @"tag":@"2"},
                             @{@"img":@"hat23", @"tag":@"2"},
                             @{@"img":@"hat27", @"tag":@"2"},
                             @{@"img":@"hat28", @"tag":@"2"},
                             @{@"img":@"hat29", @"tag":@"2"},
                             @{@"img":@"hat31", @"tag":@"2"},
                             
                             @{@"img":@"mustache01", @"tag":@"3"},
                             @{@"img":@"mustache02", @"tag":@"3"},

                             @{@"img":@"wig01", @"tag":@"4"},
                             
                             @{@"img":@"bowtie01", @"tag":@"5"},
                             @{@"img":@"bowtie02", @"tag":@"5"},
                             @{@"img":@"glasses01", @"tag":@"5"},
                             @{@"img":@"glasses02", @"tag":@"5"},
                             @{@"img":@"monocle", @"tag":@"5"},
                             @{@"img":@"pipe03", @"tag":@"5"},
                             @{@"img":@"pipe04", @"tag":@"5"},
                             @{@"img":@"ruff06", @"tag":@"5"},
                             @{@"img":@"ruff07", @"tag":@"5"},
                             
                             ]},
                   @{@"title" : @"$.50",
                     @"value" : @[
                             @{@"img":@"proframe02", @"tag":@"0"},
                             @{@"img":@"proframe03", @"tag":@"0"},
                             @{@"img":@"proframe04", @"tag":@"0"},
                             @{@"img":@"proframe10", @"tag":@"0"},
                             
                             @{@"img":@"clothing01", @"tag":@"1"},
                             @{@"img":@"clothing02", @"tag":@"1"},
                             @{@"img":@"clothing03", @"tag":@"1"},
                             @{@"img":@"clothing04", @"tag":@"1"},
                             @{@"img":@"clothing08", @"tag":@"1"},
                             @{@"img":@"clothing09", @"tag":@"1"},
                             @{@"img":@"clothing11", @"tag":@"1"},
                             
                             @{@"img":@"hat10", @"tag":@"2"},
                             @{@"img":@"hat13", @"tag":@"2"},
                             @{@"img":@"hat14", @"tag":@"2"},
                             @{@"img":@"hat15", @"tag":@"2"},
                             @{@"img":@"hat16", @"tag":@"2"},
                             @{@"img":@"hat17", @"tag":@"2"},
                             @{@"img":@"hat18", @"tag":@"2"},
                             @{@"img":@"hat26", @"tag":@"2"},
                             
                             @{@"img":@"wig03", @"tag":@"4"},
                             @{@"img":@"wig04", @"tag":@"4"},
                             
                             @{@"img":@"halo01", @"tag":@"5"},
                             @{@"img":@"halo02", @"tag":@"5"},
                             ]},
                   
                   ];
    
    tfName.text = _name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"selectassert"]) {
        
        if (sender != nil) {
            DrawingViewController * vc = segue.destinationViewController;
            vc.dicAssert = (NSDictionary*) sender;
        }
        
    }
}


- (void) gotoNew {
//    DrawingViewController * vc = (DrawingViewController*)self.presentingViewController;

    [self dismissViewControllerAnimated:YES completion:^{
        HomeViewController * vc = (HomeViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        ((AppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController = vc;

//        [vc onNewPortrait];
    }];

}
#pragma mark - Button event
- (IBAction)onClickNew:(id)sender {
    
    
    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"SAVE Current Portrait?"
                                                          message:@""
                                                cancelButtonTitle:@"YES"
                                                otherButtonTitles:@"NO", nil];
    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        
        [alertView hideWithCompletionBlock:^{
            // stub
            if (buttonIndex == 0) { // YES
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    if (tfName.text.length > 0) {
                        _captureImage = [_drawingViewController getCaptureImage:tfName.text];
                    }
                    
                    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MMM dd yyyy HH:mm:ss"];
                    NSString * fileName = [dateFormat stringFromDate:[NSDate date]];
                    
                    if ([self saveImage:fileName image:_captureImage]) {
                        [self gotoNew];
                    }

                });
            }
            else {
                [self gotoNew];
            }
        }];
    }];
    [alertView showWithAnimation:URBAlertAnimationFlipHorizontal];

}
- (IBAction)onClickShare:(id)sender {
    
    if (tfName.text.length > 0) {
        _captureImage = [_drawingViewController getCaptureImage:tfName.text];
    }
    
    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"Share Current Portrait?"  message:@""];
    [alertView addButtonWithTitle:@"Public Gallery"];
    [alertView addButtonWithTitle:@"Facebook"];
    [alertView addButtonWithTitle:@"Instagram"];
    [alertView addButtonWithTitle:@"Email"];
    [alertView addButtonWithTitle:@"Cancel"];
    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {

        [alertView hideWithCompletionBlock:^{
            // stub
            if (buttonIndex == 0) { // OK
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    UIImageWriteToSavedPhotosAlbum(_captureImage, nil, nil, nil);
                    
                });
            }
            else if (buttonIndex == 1) { // facebook
                if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                    
                    [controller setInitialText:@""];
                    [controller addImage:_captureImage];
                    
                    [self presentViewController:controller animated:YES completion:Nil];
                }
                else {
                    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"NOTE!"
                                                                          message:@"You did not log in facebook yet"
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil, nil];
                    
                    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
                        [alertView hideWithCompletionBlock:^{
                            // stub
                            if (buttonIndex == 0) { // OK
                                dispatch_async(dispatch_get_main_queue(),^{
                                    
                                });
                            }
                        }];
                    }];
                    [alertView showWithAnimation:URBAlertAnimationFlipHorizontal];
                }
                
            }
            else if (buttonIndex == 2) { // instagram
                NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
                if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
                {
                    
                    NSString * savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.igo"];
                    [UIImagePNGRepresentation(_captureImage) writeToFile:savePath atomically:YES];
                    
                    CGRect rect = CGRectMake(0, 0, 0, 0);
                    NSString * jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.igo"];
                    NSURL * igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath ]];
                    
                    //        self.docFile.UTI = @"com.instagram.photo";
                    self.docFile.UTI = @"com.instagram.exclusivegram";
                    
                    NSString *text = @"";
                    
                    self.docFile = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
                    self.docFile = [UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
                    self.docFile.annotation = [NSDictionary dictionaryWithObject:text forKey:@"InstagramCaption"];
                    // OPEN THE HOOK
                    [self.docFile presentOpenInMenuFromRect:rect inView:self.view animated:YES];
                }
                else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"Instagram not installed on this device!\nTo share image please install Instagram."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
            else if (buttonIndex == 3) { // email
                NSString *subject = @"DAPPER Portrait Painter";
                
                NSArray* emails = nil;
                
                if(![MFMailComposeViewController canSendMail]){
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Please configure your mail settings to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    return;
                }
                
                MFMailComposeViewController* mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:subject];
                [mc setToRecipients:emails];
                
                [mc addAttachmentData:UIImagePNGRepresentation(_captureImage) mimeType:@"image/png" fileName:@"portrait.png"];

                [self presentViewController:mc animated:YES completion:nil];
            }
            
        }];
    }];
    [alertView showWithAnimation:URBAlertAnimationFlipHorizontal];
}

- (IBAction)onClickSave:(id)sender {
    
    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"SAVE Current Portrait?"
                                                          message:@""
                                                cancelButtonTitle:@"YES"
                                                otherButtonTitles:@"NO", nil];
    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        NSLog(@"button tapped: index=%li", (long)buttonIndex);
        [alertView hideWithCompletionBlock:^{
            // stub
            if (buttonIndex == 0) { // OK
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    if (tfName.text.length > 0) {
                        _captureImage = [_drawingViewController getCaptureImage:tfName.text];
                    }
                    
                    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM-dd-yyyy-HH-mm-ss"];
                    NSString * fileName = [dateFormat stringFromDate:[NSDate date]];
                    
                    if ([self saveImage:fileName image:_captureImage]) {
                        [self dismissViewControllerAnimated:YES completion:^{
                        }];
                    }
                    else {
                        URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"Saving is Failed"
                                                                              message:@""
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil, nil];

                        [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
                            [alertView hideWithCompletionBlock:^{
                                // stub
                                if (buttonIndex == 0) { // OK
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        
                                    });
                                }
                            }];
                        }];
                        [alertView showWithAnimation:URBAlertAnimationFlipHorizontal];
                    }
                    
                });
            }
        }];
    }];
    [alertView showWithAnimation:URBAlertAnimationFlipHorizontal];
    
}
- (IBAction)onClickDelete:(id)sender {
    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"DELETE Portrait?"
                                                          message:@""
                                                cancelButtonTitle:@"YES"
                                                otherButtonTitles:@"NO", nil];
    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {

        [alertView hideWithCompletionBlock:^{
            // stub
            if (buttonIndex == 0) { // YES
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [self gotoNew];
                    
                });
            }
        }];
    }];
    [alertView showWithAnimation:URBAlertAnimationFlipHorizontal];
}
- (IBAction)onClickClose:(id)sender {
    DrawingViewController * vc = (DrawingViewController*)self.presentingViewController;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [vc setAssert:nil title:tfName.text];
    }];
}

#pragma mark - collectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arryImages[section][@"value"] count];
}

// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return arryImages.count;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return CGSizeMake(100, 100);
//    
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 25.0f);
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MySupplementaryView *header = nil;
    
    if ([kind isEqual:UICollectionElementKindSectionHeader])
    {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"MySupplementaryView"
                                                           forIndexPath:indexPath];
        header.mLabel.text = arryImages[indexPath.section][@"title"];
    }
    return header;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell"
                                    forIndexPath:indexPath];
    
    NSString *thumbName = [NSString stringWithFormat:@"%@_thumb.png", arryImages[indexPath.section][@"value"][indexPath.item][@"img"]];
    myCell.mImageView.image = [UIImage imageNamed:thumbName];
    
    return myCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self performSegueWithIdentifier:@"selectassert" sender:arryImages[indexPath.section][@"value"][indexPath.item]];

    DrawingViewController * vc = (DrawingViewController*)self.presentingViewController;

    [self dismissViewControllerAnimated:YES completion:^{
        [vc setAssert:arryImages[indexPath.section][@"value"][indexPath.item] title:tfName.text];
    }];

}

#pragma mark - TEXTField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([tfName isFirstResponder]) {
        [tfName resignFirstResponder];
    }
    return YES;
}

#pragma mark file manager
- (BOOL) saveImage:(NSString*) fileName image:(UIImage*) image
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"/datas"];
    if(![fileManage fileExistsAtPath:dir]) {
        if(![fileManage createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil]){
            NSLog(@"Error: Create folder failed");
            return NO;
        }
    }
    
    NSString* filePath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    if(![fileManage fileExistsAtPath:filePath]){
        if (![fileManage createFileAtPath:filePath contents:nil attributes:nil] == YES){
            NSLog(@"file can not create ");
            return NO;
        }
    }
    
    NSLog(@"save Point file = %@", filePath);
    
    if (![UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
        NSLog(@"write file failed");
        return NO;
    }
    
    return YES;
}

#pragma mark - instagram

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
