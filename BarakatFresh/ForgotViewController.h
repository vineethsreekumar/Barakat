//
//  ForgotViewController.h
//  BarakatFresh
//
//  Created by vineeth on 5/15/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotViewController : UIViewController
{
    UIActivityIndicatorView *indicator;
}
@property (strong, nonatomic) IBOutlet UITextField *email_txtfield;
- (IBAction)submit_buttonClick:(id)sender;

@end
