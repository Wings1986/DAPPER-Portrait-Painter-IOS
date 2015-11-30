//
//  GalleryGridVC.m
//  BulletinPlus
//
//  Created by Mark on 12/29/14.
//  Copyright (c) 2014 Pixel Ark. All rights reserved.
//

#import "GalleryGridVC.h"

#import "MyPhotoCollectionViewCell.h"

#import "DrawingViewController.h"


#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"


@interface GalleryGridVC ()<UICollectionViewDataSource, UICollectionViewDelegate, FSImageViewerViewControllerDelegate>
{
    
    NSMutableArray *photoArray;
    FSBasicImageSource *galleryPhotoSource;
}

@property (strong, nonatomic) IBOutlet UICollectionView *mCollectionView;

@property (strong, nonatomic) NSDictionary *galleryDetails;


@end

@implementation GalleryGridVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dirPath = [documentsDirectory stringByAppendingPathComponent:@"/datas"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:dirPath error:nil];
    
    NSLog(@"filenames = %@", fileList);
    
    photoArray = [[NSMutableArray alloc] init];
    for (NSString* fileName in fileList) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        
        if(![manager fileExistsAtPath:filePath]){
            NSLog(@"plist file no exist");
            continue;
        }
        
        NSData * imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage* image = [UIImage imageWithData:imageData];
        
        FSBasicImage * fsPhoto = [[FSBasicImage alloc] initWithImage:image];
        
        [photoArray addObject:fsPhoto];
    }
    
    galleryPhotoSource= [[FSBasicImageSource alloc] initWithImages:photoArray];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadPhotos];
    
}
#pragma mark - Parse Photos
- (void)reloadPhotos {
    
    [_mCollectionView reloadData];
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


#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photoArray.count;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGFloat cellSpacing = 5.0f;
//    int cellNum = 3;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        cellNum = 3;
//    }
//    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        cellNum = 5;
//    }
//
//    CGFloat width = (_mCollectionView.frame.size.width - (cellNum + 1)*cellSpacing)/cellNum;
//    
//    return CGSizeMake(width, width);
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPhotoCollectionViewCell" forIndexPath:indexPath];

    FSBasicImage * fsImage = photoArray[indexPath.item];
    cell.ivPhoto.image = fsImage.image;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    FSBasicImage* fsImage = photoArray[indexPath.item];
//    [self performSegueWithIdentifier:@"gotoDrawing" sender:fsImage.image];
    
    
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:galleryPhotoSource imageIndex:indexPath.row];
    
    imageViewController.delegate = self;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)imageViewerViewController:(FSImageViewerViewController *)imageViewerViewController didMoveToImageAtIndex:(NSInteger)index {
    NSLog(@"FSImageViewerViewController: %@ didMoveToImageAtIndex: %li",imageViewerViewController, (long)index);
}
- (void)imageViewerViewController:(FSImageViewerViewController *)imageViewerViewController didDismissViewControllerAnimated:(BOOL)animated
{
//    [self performSegueWithIdentifier:@"gotoDrawing" sender:nil];
}
@end
