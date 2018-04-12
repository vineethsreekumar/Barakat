//
//  HomeViewController.h
//  BarakatFresh
//
//  Created by vineeth on 4/10/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"

@interface HomeViewController : UIViewController<KASlideShowDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray * datasource;
}
@property (strong, nonatomic) IBOutlet UIView *main_slideview;
- (IBAction)menu_buttonClick:(id)sender;
- (IBAction)MyAccount_ButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *categoryScrollview;
@property (strong, nonatomic) NSMutableArray *categoryContentarray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;

@end
