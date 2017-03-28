//
//  DocViewController.m
//  GWClient
//
//  Created by guiping on 2017/3/17.
//  Copyright © 2017年 guiping. All rights reserved.
//

#import "DocViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "FileDetailViewController.h"
#import "TZImageManager.h"
#import "FileModel.h"
#import "FileCollectionViewCell.h"

@interface DocViewController ()<UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegate>{
    UITableView *myTableView;
    NSMutableArray *dataArray;
    NSMutableArray *imageNames;
    NSMutableArray *_selectedAssets;
    UICollectionView *myCollectionView;
    NSMutableArray *collectiondataArray;
    BOOL isEditing;
}

@end

@implementation DocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的网盘";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    
    self.navigationController.navigationBar.barTintColor = THEME_COLOR;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NAVIGATION_LEFTBAR] style:UIBarButtonItemStylePlain target:self action:@selector(enterMine)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    dataArray = [NSMutableArray array];
    
    // 测试
    [self createTableView];
    
    [self fileList];

}

- (void) createCollectionView{
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FileCollectionViewCell" forIndexPath:indexPath];
    
    cell.fileName = dataArray[indexPath.row];
    if (isEditing) {
        cell.deleteButton.hidden = NO;
    }
    else{
        cell.deleteButton.hidden = YES;
    }
    cell.transform = CGAffineTransformIdentity;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isEditing) {
        //        FoodModel *model = dataArray[indexPath.row];
        //        DetailViewController *detailVC = [[DetailViewController alloc] init];
        //        detailVC.hidesBottomBarWhenPushed = YES;
        //        detailVC.model = model;
        //        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void) fileList{
    UserInfoModel *model = [Utils aDecoder];
    NSDictionary *params = @{@"userId":@(model.userId),
                             @"token":model.token
                             };
    [Utils GET:ApiTypeGetUserFileList params:params succeed:^(id response) {
        NSData *tempData = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
        NSString *tempStr = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
        NSLog(@"获取文件列表--返回的Json串:\n%@", tempStr);
        if ([response isKindOfClass:[NSDictionary class]]) {
            if ([response[@"success"] boolValue]) {
                NSDictionary *dic = response[@"result"];
                NSArray *array = dic[@"fileList"];
                for (NSDictionary *ddic in array) {
                    FileModel *model = [FileModel yy_modelWithDictionary:ddic];
                    
                    [dataArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [myTableView reloadData];
                });
            }
        }
        
    } fail:^(NSError * error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void) btnOpenFile:(UIButton *) sedner{
    FileDetailViewController *VC = [[FileDetailViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void) uploadImages:(UIButton *) sedner{
    [self pushImagePickerController:YES];
}

- (void) uploadVodeos:(UIButton *) sedner{
    [self pushImagePickerController:NO];
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerController:(BOOL) isPicture {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
   imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    imagePickerVc.navigationBar.barTintColor = THEME_COLOR;
    
    if (isPicture) {
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingOriginalPhoto = YES;
    }
    else{
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = NO;
    }
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    dataArray = [photos mutableCopy];
    [self printAssetsName:assets];

   // 1.打印图片名字
    [self printAssetsName:assets];
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    dataArray = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video
    // 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
        NSData *data = [NSData dataWithContentsOfFile:outputPath];
        NSLog(@"data: %@", data);
        UserInfoModel *model = [Utils aDecoder];
        NSDictionary *params = @{@"userId":@(model.userId),
                                  @"token":model.token,
                                  @"type":@(2),
                                 @"fileDic":@{@"2017-03-27-16:30:42.mp4":data}
                                  };
        [Utils GET:ApiTypeUpFile params:params succeed:^(id response) {
            //NSData *tempData = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
            //NSString *tempStr = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
            //NSLog(@"上传视频--返回的Json串:\n%@", tempStr);
            //if ([response[@"success"] boolValue]) {
    
            //}
        } fail:^(NSError * error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }];
    [myTableView reloadData];
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    //dataArray = [NSMutableArray arrayWithArray:@[animatedImage]];
    //_selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    //[myTableView reloadData];
}


// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    NSMutableArray *imgNames = [NSMutableArray array];
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        }
        else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        [imgNames addObject:fileName];
        NSLog(@"图片名字:%@",fileName);
    }
    imageNames = imgNames;
    [myTableView reloadData];
    
    // 上传图片
    UserInfoModel *model = [Utils aDecoder];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:dataArray forKeys:imgNames];
    NSDictionary *params = @{@"userId":@(model.userId),
                              @"token":model.token,
                              @"type":@(1),
                              @"fileDic":dic
                              };
    [Utils GET:ApiTypeUpFile params:params succeed:^(id response) {
        NSData *tempData = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
        NSString *tempStr = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
        NSLog(@"上传图片--返回的Json串:\n%@", tempStr);
        if ([response[@"success"] boolValue]) {

        }
    } fail:^(NSError * error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


- (void)enterMine{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //self.hidesBottomBarWhenPushed = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) createTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 65, KSCREEN_WIDTH - 20, KSCREEN_HEIGHT * 2 / 3)];
//    [self.view addSubview:myTableView];
//    myTableView.backgroundColor = [UIColor clearColor];
//    myTableView.delegate = self;
//    myTableView.dataSource = self;
//    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    myTableView.rowHeight =  50;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 65, KSCREEN_WIDTH - 20, KSCREEN_HEIGHT * 2 / 3) collectionViewLayout:layout];
    myCollectionView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:myCollectionView];
    // 单元格的大小
    layout.itemSize = CGSizeMake(KSCREEN_WIDTH / 4, KSCREEN_WIDTH * 2 / 7);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, KSCREEN_WIDTH / 18, 10, KSCREEN_WIDTH / 18);
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [myCollectionView registerClass:[FileCollectionViewCell class] forCellWithReuseIdentifier:@"FileCollectionViewCell"];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRegister setTitle:@"上传图片" forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRegister.backgroundColor = THEME_COLOR;
    btnRegister.frame = CGRectMake(15, CGRectGetMaxY(myCollectionView.frame) + 20, KSCREEN_WIDTH / 3 - 30, 30);
    [self.view addSubview:btnRegister];
    btnRegister.layer.cornerRadius = 5;
    btnRegister.layer.masksToBounds = YES;
    [btnRegister addTarget:self action:@selector(uploadImages:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnVideo setTitle:@"上传视频" forState:UIControlStateNormal];
    [btnVideo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnVideo.backgroundColor = THEME_COLOR;
    btnVideo.frame = CGRectMake(KSCREEN_WIDTH / 3 + 15, CGRectGetMaxY(myCollectionView.frame) + 20, KSCREEN_WIDTH / 3 - 30, 30);
    [self.view addSubview:btnVideo];
    btnVideo.layer.cornerRadius = 5;
    btnVideo.layer.masksToBounds = YES;
    [btnVideo addTarget:self action:@selector(uploadVodeos:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnOpenFile = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOpenFile setTitle:@"下载文件" forState:UIControlStateNormal];
    [btnOpenFile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOpenFile.backgroundColor = THEME_COLOR;
    btnOpenFile.frame = CGRectMake(KSCREEN_WIDTH * 2 / 3 + 15, CGRectGetMaxY(myCollectionView.frame) + 20, KSCREEN_WIDTH / 3 - 30, 30);
    [self.view addSubview:btnOpenFile];
    btnOpenFile.layer.cornerRadius = 5;
    btnOpenFile.layer.masksToBounds = YES;
    [btnOpenFile addTarget:self action:@selector(btnOpenFile:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --------------- UITableViewDelegate ----------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    FileModel *model = dataArray[indexPath.row];
    //cell.imageView.image = dataArray[indexPath.row];
    cell.textLabel.text = model.fileName;
    cell.detailTextLabel.text = [Utils getTimeToShowWithTimestamp:model.fileTime];
    return cell;
    
}
@end
