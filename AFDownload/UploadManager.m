//
//  UploadManager.m
//  AF-Download-Upload
//
//  Created by gavin on 15/6/8.
//  Copyright (c) 2015年 gavin. All rights reserved.
//

#import "UploadManager.h"
#import "AFHTTPRequestOperationManager.h"

@implementation UploadManager


+ (void)imageUploadOne:(NSString *)urlString withParameters:(NSDictionary *)dic withImage:(UIImage *)img{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:UIImagePNGRepresentation(img)
                                    name:@"Filedata"
                                fileName:@"test.jpg"
                                mimeType:@"image/jpg"];
        
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:nil isDirectory:NO] name:@"file" fileName:@"testMusic.mp3" mimeType:@"audio/mpeg3" error:nil];
        
        
    }success:^(AFHTTPRequestOperation *operation,id responseObject) {
        // 成功回掉处理
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        // 失败回掉处理
        
    }];
}





+ (void) imageUploadMultiple:(NSString *)urlString withParameters:(NSDictionary *)parameters withImageArr:(NSArray *)arrayImage
{
    
    NSMutableURLRequest *request =
    
    [[AFHTTPRequestSerializer serializer]   multipartFormRequestWithMethod:@"POST"
                                                                 URLString:urlString
                                                                parameters:parameters
                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        for (int i = 0; i<arrayImage.count; i++) {
            
            UIImage *uploadImage = arrayImage[i];
            
            [formData appendPartWithFileData:UIImagePNGRepresentation(uploadImage)
                                        name:[NSString stringWithFormat:@"urlString%d",i+1]
                                    fileName:@"test.jpg"
                                    mimeType:@"image/jpg"
             ];
        }
        
    } error:nil];
    
    
    AFHTTPRequestOperation *opration = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    opration.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 成功回掉处理
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 失败回掉处理
        
    }];
}



+ (void)mp3Upload:(NSString *)urlString withParameters:(NSDictionary *)dic withFileURL:(NSURL *)fileUrl{
    //文件file上传，上传mp3音乐文件
    
//    NSString *theUpFilePath = [NSString stringWithFormat:@"%@testMusic.mp3" , NSTemporaryDirectory()];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:theUpFilePath isDirectory:NO] name:@"file" fileName:@"testMusic.mp3" mimeType:@"audio/mpeg3" error:nil];
        
        [formData appendPartWithFileURL:fileUrl name:@"file" fileName:@"testMusic.mp3" mimeType:@"audio/mpeg3" error:nil];
        
        
    }success:^(AFHTTPRequestOperation *operation,id responseObject) {
        // 成功回掉处理
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        // 失败回掉处理
        
    }];
}

@end
