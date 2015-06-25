//
//  TableViewCell.m
//  AFDownload
//
//  Created by gavin on 15/6/25.
//  Copyright (c) 2015年 gavin.gu@live.com. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cellButtonAction:(id)sender {
    if (self.cellDownloadCallBack) {
        self.cellDownloadCallBack(self);
    }
}
@end
