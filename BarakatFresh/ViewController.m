//
//  ViewController.m
//  BarakatFresh
//
//  Created by vineeth on 4/7/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "ViewController.h"
#import "Config.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MFSideMenuContainerViewController *container = [storyboard  instantiateViewControllerWithIdentifier:@"MFSideMenuContainerViewController"];
    
    HomeViewController *homeController = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
     navigationController.navigationBarHidden=YES;
    UIViewController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    //UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightSideMenuViewController"];
    
    [container setLeftMenuViewController:leftSideMenuViewController];
    //[container setRightMenuViewController:rightSideMenuViewController];
    [container setCenterViewController:navigationController];
     [[UIApplication sharedApplication].keyWindow setRootViewController:container];
}
 @end
