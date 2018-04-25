//
//  SearchViewController.h
//  BarakatFresh
//
//  Created by vineeth on 4/19/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *search_textfield;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) NSMutableArray *categoryContentarray;
@end
