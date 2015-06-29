//
//  UploadManager.h
//  AF-Download-Upload
//
//  Created by gavin on 15/6/8.
//  Copyright (c) 2015年 gavin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UploadManager : NSObject


+ (void)imageUploadOne:(NSString *)urlString withParameters:(NSDictionary *)dic withImage:(UIImage *)img;


+ (void) imageUploadMultiple:(NSString *)urlString withParameters:(NSDictionary *)parameters withImageArr:(NSArray *)arrayImage;


+ (void)mp3Upload:(NSString *)urlString withParameters:(NSDictionary *)dic withFileURL:(NSURL *)fileUrl;


@end
