//
//  CustomCell.m
//  BarakatFresh
//
//  Created by vineeth on 4/17/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize dataAraay;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
        subMenuTableView.estimatedRowHeight = 100;
        
        
        subMenuTableView.rowHeight = UITableViewAutomaticDimension;
        [subMenuTableView setNeedsLayout];
        [subMenuTableView layoutIfNeeded];
        subMenuTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) ;
        [self addSubview:subMenuTableView]; // add it cell
        NSLog(@"headerarraytest=%@",self.headerAraay);
    }
    return self;
}
int j=0;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   
    NSLog(@"headerarray=%@",[self.headerAraay valueForKey:@"CategoryName"]);
    ++j;
        return [[self.headerAraay objectAtIndex:section] valueForKey:@"CategoryName"];;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    return 44.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UITableView *subMenuTableView =(UITableView *) [self viewWithTag:100];
    subMenuTableView.frame = CGRectMake(0.2, 0.3, self.bounds.size.width-5,    self.bounds.size.height-5);//set the frames for tableview
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{  //NSMutableArray *arrayOfItems = [self.sectionNames objectAtIndex:indexPath.section];
    // NSMutableArray *innerarray = [[arrayOfItems objectAtIndex:indexPath.row] valueForKey:@"subCategories"];
    return UITableViewAutomaticDimension;
}

//manage datasource and  delegate for submenu tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // NSMutableArray *ctegory=[self.headerAraay valueForKey:@"CategoryName"];
    return _headerAraay.count;
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
