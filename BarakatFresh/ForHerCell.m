//
//  ForHerCell.m
//  Dairam
//
//  Created by Satish kumar on 19/01/15.
//  Copyright (c) 2015 Mawaqaa. All rights reserved.
//

#import "ForHerCell.h"


#import "LoginViewController.h"

@implementation ForHerCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * nibViews =   [[NSBundle mainBundle] loadNibNamed: @"ForHerCell" owner: self options: nil];
        self = (ForHerCell*)[nibViews objectAtIndex: 0];
        self.cart_lbl.text=@"Add to Cart";
        [self.cart_lbl setFont:[UIFont fontWithName:@"Roboto-Regular" size:11.f]];
        self.detail_lbl.text=@"Details";
        [self.detail_lbl setFont:[UIFont fontWithName:@"Roboto-Regular" size:11.f]];

    }
    return self;
}
- (IBAction)image_view_buttonclick:(id)sender {
    UIButton *button=(UIButton *)sender;
    NSLog(@"taggs=%ld,%ld",(long)button.tag,(long)self.inside_view.tag);
    
    for(UIView *v in [self.superview subviews]) {
        if ([v isKindOfClass:[self.inside_view class]]) {
            NSLog(@"viieww=%@",v);
            [[v viewWithTag:50] setHidden:YES];
        }
    }

    [self.inside_view setHidden:NO];
    [self.bottom_view setHidden:NO];
    
}
-(void)unhideview
{
    [self.inside_view setHidden:NO];
    [self.bottom_view setHidden:NO];
}

- (IBAction)details_buttonclick:(id)sender {
    
    
}

- (IBAction)addtocart_click:(id)sender {
   
}

- (IBAction)close_buttonclick:(id)sender {
    [self.inside_view setHidden:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
