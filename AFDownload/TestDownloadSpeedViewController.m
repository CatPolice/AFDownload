//
//  TestDownloadSpeedViewController.m
//  AFDownload
//
//  Created by gavin on 15/7/15.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import "TestDownloadSpeedViewController.h"
#import "AFDownloadManager.h"
#import "NSTimer+Blocks.h"


@interface TestDownloadSpeedViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
- (IBAction)beginDownload:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fileSize;
@property (weak, nonatomic) IBOutlet UILabel *downloadTime;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeed;


@property (nonatomic , strong) AFDownloadRequestOperation *operationSingleDownload;


@property (nonatomic , strong) NSTimer *timer;

@property (nonatomic) NSInteger recordTimer;

@end

@implementation TestDownloadSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)beginDownload:(id)sender {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
        self.recordTimer = self.recordTimer + 1;
    } repeats:YES];
    
    
//    @"http://192.168.215.192:9002/crmserver/upload/model/A5.zip",
//    @"http://dl_dir2.qq.com/invc/xfspeed/qdesk/versetup/QDeskSetup_25_1277.exe",
    NSString *url = @"http://dl_dir2.qq.com/invc/xfspeed/qdesk/versetup/QDeskSetup_25_1277.exe";
    
    NSString *filePath = [self dirDoc:@"test.zip"];
    
    __weak __typeof(self)weakSelf = self;
    
    
    [[AFDownloadManager sharedDownloadManager] downloadSingleTask:_operationSingleDownload
                                                          withUrl:url
                                                     withFilePath:filePath
                                                   withUIProgress:self.progress
                                                  downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
                                                      
                                                      __strong __typeof(weakSelf)strongSelf = weakSelf;
                                                      
                                                      
                                                      [strongSelf.timer invalidate];
                                                      
                                                      strongSelf.downloadTime.text = [NSString stringWithFormat:@"%zd%@",strongSelf.recordTimer,@" s"];
                                                      
                                                      
                                                      strongSelf.fileSize.text =[NSString stringWithFormat:@"%lld", [strongSelf fileSizeAtPath:filePath]];
                                                      
                                                      
                                                      double avg = [strongSelf fileSizeAtPath:filePath] / 1000.0 / 1000.0 / strongSelf.recordTimer;
                                                      
                                                      strongSelf.avgSpeed.text = [NSString stringWithFormat:@"%f%@",avg,@" s/m"];
                                                      
                                                      
                                                      
                                                      
                                                      [strongSelf deleteFile:@"test.zip"];
                                            
                                                      
                                                      
                                                  } downloadError:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      
                                                      
                                                      
                                                      
    }];
    
}



- (NSString *)dirDoc:(NSString *)name{
    NSString *str = [NSString stringWithFormat:@"%@%@",@"%@/Documents/",name];
    
    NSString *filePath = [NSString stringWithFormat:str, NSHomeDirectory()];
    
    return filePath;
}



- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



-(void)deleteFile:(NSString *)fileName{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}



@end
