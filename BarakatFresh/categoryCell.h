//
//  categoryCell.h
//  BarakatFresh
//
//  Created by vineeth on 4/17/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface categoryCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *dataAraay;
@end

