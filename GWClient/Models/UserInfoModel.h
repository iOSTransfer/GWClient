//
//  UserInfoModel.h
//  GWClient
//
//  Created by guiping on 2017/3/20.
//  Copyright © 2017年 guiping. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GenderType) {
    GenderTypeMan = 1,
    GenderTypeWoman = 2,
    GenderTypeUnknown = 3
};

@class FileModel;
@interface UserInfoModel : NSObject<NSCoding>



/**用户Id*/
@property (nonatomic, assign) NSUInteger userId;

/**令牌*/
@property (nonatomic, copy) NSString *token;

/**用户名*/
@property (nonatomic, copy) NSString *nickName;

/**用户头像Url*/
@property (nonatomic, copy) NSString *headImgUrl;
//@property (nonatomic, strong) UIImage *headImgUrl;

/**年龄(默认0)*/
@property (nonatomic, assign) NSUInteger age;

/**性别(1男、2女、3未知)*/
@property (nonatomic, assign) NSUInteger gender;

/**地区*/
@property (nonatomic, copy) NSString *location;

/**个性签名(默认:您还没设置个性签名)*/
@property (nonatomic, copy) NSString *signature;


/**查询下载记录*/
- (BOOL) checkDownload:(FileModel *) fileModel;

/**下载文件*/
- (BOOL) downloadFile:(FileModel *) fileModel;

/**获取下载列表*/
- (NSArray *) downLoadList;

/**删除下载记录*/
- (BOOL)deleteDownList:(FileModel *)fileModel;

/**上传文件*/
- (BOOL) uploadFile:(FileModel *) fileModel;

/**获取上传列表*/
- (NSArray *) upLoadList;

/**删除上传记录*/
- (BOOL)deleteUpList:(FileModel *)fileModel;

/**删除所有上传、下载记录*/
- (void) deleteAllRecord;


@end
