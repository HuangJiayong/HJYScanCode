//
//  ViewController.m
//  HJYScanCode
//
//  Created by 黄家永 on 16/6/23.
//  Copyright © 2016年 黄家永. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"

@interface ViewController ()<ScanViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *license;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)scanCodeStart:(id)sender {
    ScanViewController *scanViewContr = [[ScanViewController alloc] init];
    scanViewContr.view.backgroundColor = [UIColor whiteColor];
    scanViewContr.delegate = self;
    [self.navigationController pushViewController:scanViewContr animated:YES];
}

- (void)license:(NSString *)license {
    self.license.text = license;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
