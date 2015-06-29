//
//  AFDownloadItem.h
//  AFDownload
//
//  Created by gavin on 15/6/29.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFDownloadRequestOperation.h"

@interface AFDownloadItem : NSObject<NSCoding>



@property (nonatomic , strong)  NSString *name;
@property (nonatomic , strong)  NSString *url;
@property (nonatomic , strong)  NSString *progrees;
@property (nonatomic , strong)  NSString *state;
@property (nonatomic , strong)  AFDownloadRequestOperation *operation;





@end
