//
//  CartViewController.h
//  BarakatFresh
//
//  Created by vineeth on 4/30/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *search_textfield;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) NSMutableArray *categoryContentarray;
@property (strong, nonatomic) NSMutableArray *passcurrentarray;


@end
