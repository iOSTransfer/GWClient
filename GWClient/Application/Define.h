//
//  Define.h
//  GWClient
//
//  Created by guiping on 2017/3/20.
//  Copyright © 2017年 guiping. All rights reserved.
//

#ifndef Define_h
#define Define_h


typedef NS_ENUM(NSUInteger, ApiType) {
    ApiTypeLogin = 11,                  // 登录
    ApiTypeGetverifiyCode = 12,         // 获取验证码
    ApiTypeRegister = 13,               // 注册
    ApiTypeUpFile = 14,                 // 上传文件
    ApiTypeGetFile = 15,                // 获取文件
    ApiTypeModifyUserInfo = 16,         // 修改用户信息
    ApiTypeGetUserFileList = 17,        // 获取用户文件列表
    ApiTypeDeleteFiles = 18,            // 删除文件
    ApiTypeGetNewsList = 19             // 获取新闻列表
};


#define USERINFOCELL                @"UserInfoTableViewCell"
#define DEFAULT_HEAD_IMAGENAME      @"head"
#define NAVIGATION_LEFTBAR          @"navigationbar_list_normal"

#define HOST_IP                     @"10.134.42.1"
#define HOST_PORT                   20173

#define BTN_NEW_TAG                 800

#define TRANSFERLISTCELL            @"transferListTableViewCell"
#define SETTING_CELL                @"settingcell"
#define NO_NETWORK                57

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s: %d \t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#endif /* Define_h */
