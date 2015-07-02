//
//  ViewController.m
//  AFDownload
//
//  Created by gavin on 15/6/24.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "TableViewCell.h"
#import "AFDownloadRequestOperation.h"
#import "AFDownloadManager.h"
#import "AFDownloadItem.h"
#import "TMDiskCache.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
    BOOL _nibsRegistered;
    
    NSArray *_cellName;
    NSArray *_urlArr;
    
    
    AFURLSessionManager * _manager;
    
    AFHTTPRequestOperation *_operation;      //创建请求管理（用于上传和下载）
    
    
    AFDownloadRequestOperation *_operationSingleDownload;
    
    NSMutableDictionary *_operationList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

- (IBAction)beginAction:(id)sender;
- (IBAction)pauseAction:(id)sender;
- (IBAction)resumeAction:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _operationList = [[NSMutableDictionary alloc] init];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    // 错误下载地址
//    http://218.60.33.162/dlied6.qq.com/invc/xfspeed/qqpcmgr/download/QQPCDownload1324.exe?mkey=5590d637bd71845a&f=d488&p=.exe
    
//    http://dldir1.qq.com/music/clntupate/QQMusic_Setup_1174.exe
    
    _cellName = @[@"Res1",@"Res2",@"Res3",@"Res4",@"Res5",@"Res6"];
    _urlArr = @[@"http://192.168.215.192:9002/crmserver/upload/model/A5.zip",
                @"http://dl_dir2.qq.com/invc/xfspeed/qdesk/versetup/QDeskSetup_25_1277.exe",
                @"http://218.60.33.162/dlied6.qq.com/invc/xfspeed/qqpcmgr/download/QQPCDownload1324.exe?mkey=5590d637bd71845a&f=d488&p=.exe",
                @"http://dldir2.qq.com/invc/xfspeed/softmgr/SoftMgr_Setup_S40001.exe",
                @"http://61.240.128.159/download.sj.qq.com/update/QQPhoneManager_Suit5.3.1_710302.4665.exe?mkey=5590d60fbd71845a&f=d388&p=.exe",
                @"http://dldir1.qq.com/qqfile/qq/tm/2013Preview2/10913/TM2013Preview2.exe"];
    
    
    
    //=============
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 开始
- (IBAction)beginAction:(id)sender {
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/QQ_V4.0.2.dmg", NSHomeDirectory()];
    
    [[AFDownloadManager sharedDownloadManager] downloadSingleTask:_operationSingleDownload
                                                          withUrl:@"http://dl_dir2.qq.com/invc/xfspeed/qdesk/versetup/QDeskSetup_25_1277.exe"
                                                     withFilePath:filePath
                                                   withUIProgress:self.progress];
}
// 暂停
- (IBAction)pauseAction:(id)sender {
}

// 继续
- (IBAction)resumeAction:(id)sender {
}




#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"TableViewCell";
     if (!_nibsRegistered) {
     UINib * nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
     [tableView registerNib:nib forCellReuseIdentifier:identifier];
     _nibsRegistered = YES;
     }
     
     TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.cellName.text = [_cellName objectAtIndex:indexPath.row];
    //0:未下载  1:下载中 2:暂停 3:完成
    NSArray *arr = @[@"下载",@"下载中",@"暂停",@"完成"];
    
    
    if ([[TMDiskCache sharedCache] objectForKey:[_urlArr objectAtIndex:indexPath.row]]) {
        
        AFDownloadItem *item = (AFDownloadItem *)[[TMDiskCache sharedCache] objectForKey:[_urlArr objectAtIndex:indexPath.row]];
        cell.cellPrg.progress = [item.progrees floatValue];
        cell.cellState.text = [arr objectAtIndex:[item.state integerValue]];
        cell.downloadState = [item.state integerValue];
        
    }else{
        
        cell.cellState.text = [arr objectAtIndex:cell.downloadState];
        
    }
    
    
    __weak __typeof(self)weakSelf = self;
    
    cell.cellDownloadCallBack = ^(TableViewCell *cell){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSIndexPath *index = [_tableview indexPathForCell:cell];
        
        
        switch (cell.downloadState) {
            case 0: // prepareing
            {
                AFDownloadRequestOperation *operation;
                
                [[AFDownloadManager sharedDownloadManager] downloadQueueTask:[_cellName objectAtIndex:index.row]
                                                             withDownloadURL:[_urlArr objectAtIndex:index.row]
                                                        withDownloadSavePath:nil
                                                          withUIProgressView:cell.cellPrg
                                                  withAFHTTPRequestOperation:operation
                                                        withCurrDownloadCell:nil
                                                             downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject , NSInteger state) {
                                                                 
                                                                 NSLog(@"download success ~ ");
                                                                 
                                                                 AFDownloadItem *item = [[AFDownloadItem alloc] init];
                                                                 item.url = [_urlArr objectAtIndex:index.row];
                                                                 item.progrees = @"1";
                                                                 item.state = [NSString stringWithFormat:@"%zd",state];
                                                                 [[TMDiskCache sharedCache] setObject:item forKey:[_urlArr objectAtIndex:index.row]];
                                                                 
                                                                 cell.downloadState = state;
                                                                 [strongSelf.tableview reloadData];
                                                                 
                                                             } downloadError:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                 NSLog(@"error tableview reload ~");
                                                                 cell.downloadState = 0;
                                                                 [strongSelf.tableview reloadData];
                                                             }];
                cell.downloadState = 1;
            }
                break;
                
            case 1:// downloading
            {
                if ([[AFDownloadManager sharedDownloadManager].downloadDic objectForKey:[_urlArr objectAtIndex:index.row]]) {
                    
                    AFHTTPRequestOperation *operation = [[AFDownloadManager sharedDownloadManager].downloadDic objectForKey:[_urlArr objectAtIndex:index.row]];
                    [[AFDownloadManager sharedDownloadManager] pauseDownload:operation];
                    cell.downloadState = 2;
                    
                    AFDownloadItem *item = [[AFDownloadItem alloc] init];
                    item.url = [_urlArr objectAtIndex:index.row];
                    item.progrees = [NSString stringWithFormat:@"%f",cell.cellPrg.progress];
                    item.state = [NSString stringWithFormat:@"%d",2];
                    [[TMDiskCache sharedCache] setObject:item forKey:[_urlArr objectAtIndex:index.row]];
                }
                [strongSelf.tableview reloadData];
            }
                break;
                
            case 2: // pauseing
            {
                if ([[AFDownloadManager sharedDownloadManager].downloadDic objectForKey:[_urlArr objectAtIndex:index.row]]) {
                    
                    AFHTTPRequestOperation *operation = [[AFDownloadManager sharedDownloadManager].downloadDic objectForKey:[_urlArr objectAtIndex:index.row]];
                    [[AFDownloadManager sharedDownloadManager] resumeDownload:operation];
                }else{
                    AFDownloadRequestOperation *operation;
                    
                    [[AFDownloadManager sharedDownloadManager] downloadQueueTask:[_cellName objectAtIndex:index.row]
                                                                 withDownloadURL:[_urlArr objectAtIndex:index.row]
                                                            withDownloadSavePath:nil
                                                              withUIProgressView:cell.cellPrg
                                                      withAFHTTPRequestOperation:operation
                                                            withCurrDownloadCell:nil
                                                                 downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject , NSInteger state) {
                                                                     
                                                                     NSLog(@"download success ~ ");
                                                                     
                                                                     AFDownloadItem *item = [[AFDownloadItem alloc] init];
                                                                     item.url = [_urlArr objectAtIndex:index.row];
                                                                     item.progrees = @"1";
                                                                     item.state = [NSString stringWithFormat:@"%zd",state];
                                                                     [[TMDiskCache sharedCache] setObject:item forKey:[_urlArr objectAtIndex:index.row]];
                                                                     
                                                                     cell.downloadState = state;
                                                                     [strongSelf.tableview reloadData];
                                                                     
                                                                 } downloadError:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                     NSLog(@"error tableview reload ~");
                                                                     cell.downloadState = 0;
                                                                     [strongSelf.tableview reloadData];
                                                                 }];

                }
                [[TMDiskCache sharedCache] removeObjectForKey:[_urlArr objectAtIndex:index.row]];
                cell.downloadState = 1;
                [strongSelf.tableview reloadData];
            }
                break;
            
            case 3:
            {
                NSLog(@"下载已经完成");
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"资源已经下载完成" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [al show];
            }
                break;
                
            default:
                break;
        }
    };

    return cell;
}





@end
