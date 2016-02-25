//
//  ViewController.m
//  photoesSelected
//
//  Created by llbt on 16/2/22.
//  Copyright © 2016年 llbt. All rights reserved.
//

#import "ViewController.h"
#import "UIActionSheet+Common.h"
#import "QBImagePickerController.h"
#import "Helper.h"
#import "TweetSendImagesCell.h"


@interface ViewController ()<QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    TweetImage *twImg;
}
@property (nonatomic,strong) UITableView *myTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_curTweet) {
        _curTweet = [[Tweet alloc]init];
    }
    
    //    添加myTableView
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[TweetSendImagesCell class] forCellReuseIdentifier:kCellIdentifier_TweetSendImages];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
}
- (IBAction)clickedAction:(id)sender {
    
    @weakify(self);
    [[UIActionSheet bk_actionSheetCustomWithTitle:nil
                                    buttonTitles:@[@"拍照",@"从相册中选择"]
                                destructiveTitle:nil
                                     cancelTitle:@"取消"
                              andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
                                
                                  @strongify(self);
                                  [self photeActionSheet:sheet dismissWithButtonIndex:index];
                              }] showInView:self.view];
    
}

- (void)photeActionSheet:(UIActionSheet *)sheet dismissWithButtonIndex:(NSInteger)index {
    
    if (index == 0) {
        
        // 拍照
        if (![Helper checkCameraAuthorizationStatus]) {
            return;
        }else if (_curTweet.tweetImages.count >= 6) {
            kTipAlert(@"最多只可选择6张照片，已经选满了。先去掉一张照片再拍照呗～");
            return;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;//设置可编辑
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
        
    }else if (index == 1) {
        
        if (![Helper checkPhotoLibraryAuthorizationStatus]) {
            return;
        }
        
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        [imagePickerController.selectedAssetURLs removeAllObjects];
        [imagePickerController.selectedAssetURLs addObjectsFromArray:self.curTweet.selectedAssetURLs];
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = 9;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeImageToSavedPhotosAlbum:[pickerImage CGImage] orientation:(ALAssetOrientation)pickerImage.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        [self.curTweet addASelectedAssetURL:assetURL];

        [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    NSMutableArray *selectedAssetURLs = [NSMutableArray new];
    [imagePickerController.selectedAssetURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedAssetURLs addObject:obj];
    }];
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.curTweet.selectedAssetURLs = selectedAssetURLs;
        
        NSMutableArray *array = [self.curTweet addSelectAssetUrl:selectedAssetURLs];
        
        for (int i = 0 ; i<selectedAssetURLs.count; i++) {
            twImg = array[i];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        });
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Table M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;

        TweetSendImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TweetSendImages forIndexPath:indexPath];
        cell.curTweet = _curTweet;
        cell.addPicturesBlock = ^(){
            [self clickedAction:nil];
        };
        cell.deleteTweetImageBlock = ^(TweetImage *toDelete){
            [weakSelf.curTweet deleteATweetImage:toDelete];
            [weakSelf.myTableView reloadData];
        };
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TweetSendImagesCell cellHeightWithObj:_curTweet];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
