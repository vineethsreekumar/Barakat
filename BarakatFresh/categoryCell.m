//
//  categoryCell.m
//  BarakatFresh
//
//  Created by vineeth on 4/17/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "categoryCell.h"

@implementation categoryCell
@synthesize dataAraay;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 300, 50);
        UITableView *subMenuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain]; //create tableview a
        
        subMenuTableView.tag = 100;
        subMenuTableView.delegate = self;
        subMenuTableView.dataSource = self;
        [self addSubview:subMenuTableView]; // add it cell
        
    }
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    UITableView *subMenuTableView =(UITableView *) [self viewWithTag:100];
    subMenuTableView.frame = CGRectMake(0.2, 0.3, self.bounds.size.width-5,    self.bounds.size.height-5);//set the frames for tableview
    
}

//manage datasource and  delegate for submenu tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAraay.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = [[self.dataAraay objectAtIndex:indexPath.row] valueForKey:@"SubCategoryName"];
    
    return cell;
    
}


@end
