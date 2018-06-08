//
//  ImagefullviewViewController.h
//  BarakatFresh
//
//  Created by vineeth on 6/6/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagefullviewViewController : UIViewController<UIScrollViewDelegate>
@property(strong,nonatomic) UIImage *passimage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;

@end
