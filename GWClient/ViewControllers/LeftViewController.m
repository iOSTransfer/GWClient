//
//  LeftViewController.m
//  GWClient
//
//  Created by guiping on 2017/3/17.
//  Copyright © 2017年 guiping. All rights reserved.
//

#import "LeftViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LeftVCTableViewCell.h"
#import "SettingViewController.h"
#import "UserInfoViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *ImvUserhead;
    UILabel *lbNickName;
    UITableView *myTableView;
    NSArray *dataArray;
    NSArray *imageNamesArray;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"左侧栏背景"];
    [self.view addSubview:imageView];
    
    [self creatViews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self infomation];
}

- (void) infomation{
    UserInfoModel *model = [Utils aDecoder];
    if (![UIImage imageNamed:model.headImgUrl]) {
        ImvUserhead.image = [UIImage imageNamed:DEFAULT_HEAD_IMAGENAME];
    }
    else{
        ImvUserhead.image = [UIImage imageNamed:model.headImgUrl];
    }
    lbNickName.text = model.nickName;
    
    NSArray *systemInfo = @[@"个人信息", @"设置"];
    NSArray *WiFi = @[@"注销登录"];
    dataArray = @[systemInfo, WiFi];
    NSArray *img = @[@"关于", @"设置"];
    NSArray *img1 = @[@"关于"];
    imageNamesArray = @[img, img1];
    [myTableView reloadData];
}


#pragma mark --------------- UITableViewDelegate ----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001f;
    }
    return 60;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LEFTCELL forIndexPath:indexPath];
    if (indexPath.section == 1) {
        cell.isSetting = YES;
    }
    else{
        cell.isSetting = NO;
    }
    cell.imageName = imageNamesArray[indexPath.section][indexPath.row];
    cell.title = dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 修改用户信息
            UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                UITabBarController *cen = (UITabBarController *)self.mm_drawerController.centerViewController;
                UINavigationController *nav = [cen.viewControllers firstObject];
                [nav pushViewController:userInfoVC animated:YES];
            }];
        }
        else if (indexPath.row == 1) {
            // 设置
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                UITabBarController *cen = (UITabBarController *)self.mm_drawerController.centerViewController;
                UINavigationController *nav = [cen.viewControllers firstObject];
                [nav pushViewController:settingVC animated:YES];
            }];
            
        }
    }
    else if (indexPath.section == 1) {
        // 注销登录
        NSLog(@"注销登录");
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setBool:NO forKey:IS_HAS_LOGIN];
        [userDef synchronize];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.view.window.rootViewController = nav;
    }
}


- (void) creatViews{
    ImvUserhead = [[UIImageView alloc] initWithFrame:CGRectMake((LEFTVC_WIDTH - 80) /2, 100, 80, 80)];
    [self.view addSubview:ImvUserhead];
    ImvUserhead.layer.cornerRadius = 40;
    ImvUserhead.layer.borderWidth = 2;
    ImvUserhead.layer.borderColor = [UIColor whiteColor].CGColor;
    ImvUserhead.layer.masksToBounds = YES;
    
    lbNickName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ImvUserhead.frame) + 10, LEFTVC_WIDTH, 30)];
    lbNickName.textColor = [UIColor whiteColor];
    lbNickName.font = [UIFont systemFontOfSize:15];
    lbNickName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbNickName];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbNickName.frame) + 10, LEFTVC_WIDTH, KSCREEN_HEIGHT - 10 - CGRectGetMaxY(lbNickName.frame)) style:UITableViewStyleGrouped];
    [self.view addSubview:myTableView];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight = 40;
    [myTableView registerClass:[LeftVCTableViewCell class] forCellReuseIdentifier:LEFTCELL];
    
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

@end