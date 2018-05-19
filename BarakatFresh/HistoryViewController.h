//
//  HistoryViewController.h
//  BarakatFresh
//
//  Created by vineeth on 5/13/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (weak, nonatomic) IBOutlet UIImageView *profileimage;
@property (strong, nonatomic) NSMutableArray *contentArray;



@end
