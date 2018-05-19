//
//  HistoryViewController.m
//  BarakatFresh
//
//  Created by vineeth on 5/13/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "HistoryViewController.h"
#import "Config.h"
@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    [self FullHistoryServicemethod];
    self.mytableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Do any additional setup after loading the view.
}
-(void)FullHistoryServicemethod
{
    NSString *customerId = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"customerId"];
    
    NSString *accesstoken = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"accesstoken"];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    NSString *urlstring = [NSString stringWithFormat:@"%sHome/GetPurchaseHistory?userId=%@",baseURL,customerId];
    
    
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *headerstring = [NSString stringWithFormat:@"Bearer %@",accesstoken];
    [urlrequest setValue:headerstring forHTTPHeaderField:@"Authorization"];
    
    [urlrequest setHTTPMethod:@"GET"];
    //[urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSError *error1;
          // NSError *jsonError = nil;
          
          
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          NSLog(@"exact order arrayy=%@",res);
          
          dispatch_async(dispatch_get_main_queue(), ^{
              self.contentArray = [[NSMutableArray alloc]init];
              
            if(res.count >0)
              {
                  [self.contentArray addObjectsFromArray:[res valueForKey:@"data"]];
                
                  
                  [self.mytableview reloadData];
                  
              }
              
          });
          
          
          
      }] resume];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.contentArray.count;
}
/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 NSString *sectionName = [self.contentArray objectAtIndex:section];
 
 return sectionName;
 }*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"historycell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UILabel *ProspectName = (UILabel*)[cell viewWithTag:1];
    ProspectName.text=[NSString stringWithFormat:@"%@",[[self.contentArray objectAtIndex:indexPath.row]  valueForKey:@"ItemTitle"]];
    UILabel *orderno = (UILabel*)[cell viewWithTag:2];
    orderno.text=[NSString stringWithFormat:@"ORDER NO: %@",[[self.contentArray objectAtIndex:indexPath.row]  valueForKey:@"OrderNo"]];
    
    UIImageView *image = (UIImageView*)[cell viewWithTag:3];
    image.hidden=true;
    image.layer.cornerRadius=8.0;
    image.layer.masksToBounds=YES;
   
    UILabel *OrderDate = (UILabel*)[cell viewWithTag:4];
    OrderDate.text=[NSString stringWithFormat:@"Order Date: %@",[[self.contentArray objectAtIndex:indexPath.row]  valueForKey:@"OrderDate"]];
    

    
    return cell;
    
}


- (IBAction)back_ButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
