//
//  DefaultViewController.m
//  BarakatFresh
//
//  Created by vineeth on 5/25/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "DefaultViewController.h"
#import "Config.h"
@interface DefaultViewController ()

@end

@implementation DefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)aboutus_butonClick:(id)sender {
    AboutViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutView"];
    [self.navigationController pushViewController:ViewController animated:YES];
}
- (IBAction)privacy_buttonClick:(id)sender {
    privacyViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyView"];
    [self.navigationController pushViewController:ViewController animated:YES];
}
- (IBAction)terms_buttonClick:(id)sender {
    TermsViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsView"];
    [self.navigationController pushViewController:ViewController animated:YES];

}
- (IBAction)contactus_buttonClick:(id)sender {
    ContactusViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactusView"];
    [self.navigationController pushViewController:ViewController animated:YES];
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
