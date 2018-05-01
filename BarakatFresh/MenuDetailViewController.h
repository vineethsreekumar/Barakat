//
//  MenuDetailViewController.h
//  BarakatFresh
//
//  Created by vineeth on 4/25/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuDetailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *search_textfield;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) NSMutableArray *categoryContentarray;
@property (strong, nonatomic) NSMutableArray *passcurrentarray;
@property (strong, nonatomic) NSMutableArray *tempcartarray;
@end