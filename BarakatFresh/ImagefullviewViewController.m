//
//  ImagefullviewViewController.m
//  BarakatFresh
//
//  Created by vineeth on 6/6/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "ImagefullviewViewController.h"

@interface ImagefullviewViewController ()

@end

@implementation ImagefullviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollview.minimumZoomScale=0.5;
    
    self.scrollview.maximumZoomScale=6.0;
    
    self.scrollview.contentSize=CGSizeMake(1280, 960);
    
    self.scrollview.delegate=self;
    self.imageview.image=self.passimage;
    // Do any additional setup after loading the view.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu_buttonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
