//
//  AppDelegate.h
//  BarakatFresh
//
//  Created by vineeth on 4/7/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)showMessage:(NSString*)message withTitle:(NSString *)title;
@end

