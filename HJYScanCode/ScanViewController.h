//
//  ScanViewController.h
//  HJYScanCode
//
//  Created by 黄家永 on 16/6/23.
//  Copyright © 2016年 黄家永. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanViewControllerDelegate <NSObject>

- (void)license:(NSString *)license;

@end


@interface ScanViewController : UIViewController

@property (nonatomic, weak) id<ScanViewControllerDelegate> delegate;

@end