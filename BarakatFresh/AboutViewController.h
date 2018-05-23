//
//  AboutViewController.h
//  BarakatFresh
//
//  Created by vineeth on 5/24/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end
