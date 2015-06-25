//
//  TableViewCell.h
//  AFDownload
//
//  Created by gavin on 15/6/25.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"

@interface TableViewCell : UITableViewCell

@property(nonatomic,copy) void(^cellDownloadCallBack)(TableViewCell *cell);

@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UILabel *cellState;
@property (weak, nonatomic) IBOutlet UIProgressView *cellPrg;

- (IBAction)cellButtonAction:(id)sender;




@property (nonatomic) NSInteger downloadState;  //0:未下载  1:下载中 2:暂停 3:完成

@property (nonatomic , strong) AFHTTPRequestOperation *cellOperation;

@end
