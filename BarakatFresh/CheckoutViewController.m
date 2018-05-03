//
//  CheckoutViewController.m
//  BarakatFresh
//
//  Created by vineeth on 5/3/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "CheckoutViewController.h"
#import "Config.h"
@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{  //NSMutableArray *arrayOfItems = [self.sectionNames objectAtIndex:indexPath.section];
    // NSMutableArray *innerarray = [[arrayOfItems objectAtIndex:indexPath.row] valueForKey:@"subCategories"];
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CheckoutCell" owner:self options:nil];
    
  //  HeaderView *headerView = [nibArray objectAtIndex:0];
    
    return [nibArray objectAtIndex:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    /*
    NSMutableArray *section = [self.sectionItems objectAtIndex:indexPath.section];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font =[UIFont fontWithName:@"Helvetica Neue" size:15];
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",[[section objectAtIndex:indexPath.row] valueForKey:@"CategoryName"]];
    NSLog(@"headerarray=%@", section );*/
    
  
    return cell;
}

- (IBAction)submit_ButtonClick:(id)sender {
    
}
- (IBAction)Accept_ButtonClick:(id)sender {
    UIButton *accept =(UIButton*)sender;
    if(accept.selected == YES)
    {
        accept.selected =NO;
    }
    else
    {
        accept.selected =YES;
    }
}


- (IBAction)back_ButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Applycoupon_buttonClick:(id)sender {
    [self couponValidationmethod];
}
-(void)couponValidationmethod
{
    NSString *couponcode = [self.coupontextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
   
    NSError *writeError = nil;
    // NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    // NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"User/LoginUser"];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s?couponCode=%@&couponCode=%@",baseURL,"Order/CheckValidCouponDiscount",couponcode,@""];
    // NSString * encodedString = [urlstring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    //[request setURL:[NSURL URLWithString:urlStr]];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"GET"];
    //[urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSError *error1;
          if(data==nil)
          {
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          if([[res valueForKey:@"data"] length]>0)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                
                 
              });
              //  NSString *outputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          }
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                 
                  
                  [uAppDelegate showMessage:@"Coupon Error" withTitle:@"Message"];
              });
              
              
          }
          NSLog(@"webresponse=%@",res);
       
      }] resume];
    
}

- (IBAction)ApplyVoucher_buttonClick:(id)sender {
}
@end
