//
//  WebViewController.h
//  BarakatFresh
//
//  Created by vineeth on 5/10/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString *transactionid;
@property (strong, nonatomic) NSString *orderid;

@end
