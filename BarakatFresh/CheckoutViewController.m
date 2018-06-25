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
@synthesize datePicker,timePicker;
int coupondiscount=0;
int voucherdiscount=0;
float sumtotal=0.0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameview.layer.cornerRadius = 5;
    self.nameview.layer.masksToBounds = YES;
    self.emailview.layer.cornerRadius = 5;
    self.emailview.layer.masksToBounds = YES;
    self.mobileview.layer.cornerRadius = 5;
    self.mobileview.layer.masksToBounds = YES;
    self.deliveryareaview.layer.cornerRadius = 5;
    self.deliveryareaview.layer.masksToBounds = YES;
    self.landmarkview.layer.cornerRadius = 5;
    self.landmarkview.layer.masksToBounds = YES;
    self.dateview.layer.cornerRadius = 5;
    self.dateview.layer.masksToBounds = YES;
    self.timeview.layer.cornerRadius = 5;
    self.timeview.layer.masksToBounds = YES;
    
    self.delivery_Area.delegate=self;
    self.email_textfield.delegate=self;
    self.mobile_textfield.delegate=self;
    self.creditdebitbutton.selected=true;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.contentArray = [[NSMutableArray alloc]init];
    [self.contentArray addObjectsFromArray:self.passcontentarray];
    [self.tableView reloadData];
    [self setAllViews];
    [self loadareaData];
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPressed)];
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    self.coupontextfield.inputAccessoryView = pickerToolbar;
     self.vouchertextfield.inputAccessoryView = pickerToolbar;
     self.delivery_Area.inputAccessoryView = pickerToolbar;
    self.delivery_address.inputAccessoryView = pickerToolbar;
     self.nearestlandmark.inputAccessoryView = pickerToolbar;
     self.name.inputAccessoryView = pickerToolbar;
     self.email_textfield.inputAccessoryView = pickerToolbar;
     self.password_textfield.inputAccessoryView = pickerToolbar;
     self.mobile_textfield.inputAccessoryView = pickerToolbar;
    self.confirm_password.inputAccessoryView = pickerToolbar;
    self.tableView.tableFooterView = [UIView new];
    for (int i=0; i<self.contentArray.count; i++) {
        sumtotal = sumtotal+[[[self.contentArray valueForKey:@"ItemQty"]objectAtIndex:i] floatValue]*[[[self.contentArray valueForKey:@"ItemPrice"]objectAtIndex:i] floatValue];
        self.subtotal_lbl.text =[NSString stringWithFormat:@"AED %.2f",sumtotal];

    }
    NSString *customerId = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"customerId"];
    if(customerId.length>0)
    {
        self.nameview.hidden=TRUE;
         self.emailview.hidden=TRUE;
         self.mobileview.hidden=TRUE;
    }
    self.discount_lbl.text=[NSString stringWithFormat:@"AED %d",voucherdiscount];
    self.total_lbl.text=[NSString stringWithFormat:@"AED %.2f",sumtotal-voucherdiscount];
    float vatval = (((sumtotal-coupondiscount)/105)*5);
    NSString *vatstring = [NSString stringWithFormat:@"Above invoice inclusive VAT @ 5%% %.2f",vatval];
    self.vat_lbl.text=vatstring;
    self.password_textfield.delegate=self;
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
   
    // Do any additional setup after loading the view.
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField==self.delivery_Area)
    {
        NSString *newString = [self.delivery_Area.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(newString.length==0)
        {
            return;
        }
        NSURL *theURL = [NSURL URLWithString: [NSString stringWithFormat:@"%sOrder/GetSlotByArea?AreaId=%ld",baseURL,(long)self.delivery_Area.tag]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL      cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
        
        //Specify method of request(Get or Post)
        [theRequest setHTTPMethod:@"GET"];
        
        //Pass some default parameter(like content-type etc.)
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [theRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        //Now pass your own parameter
        
        
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  NSError *theError = NULL;
                  
                  NSMutableArray *dataResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&theError];
                  if([dataResponse valueForKey:@"data"])
                  {
                      pickerData =[[NSArray alloc]init];
                      timePicker =[[UIPickerView alloc]init];
                      pickerData =[dataResponse valueForKey:@"data"];

                      //  pickerData = @[@"12PM-2PM", @"2PM-4PM", @"4PM-6PM", @"5PM-7PM", @"7PM-10PM"];
                      timePicker.tag=1;
                      // Connect data
                      self.timePicker.dataSource = self;
                      self.timePicker.delegate = self;
                      self.time_field.inputView=self.timePicker;
                      self.time_field.text=@"";
                  }
                  else
                  {
                      
                  }
              });
              
              //  NSLog(@"Delete webresponse=%@",res);
              
              
              
              
              
          }] resume];
    }
    if(textField==self.email_textfield)
    {
    NSString *newString = [self.email_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(newString.length==0)
    {
        return;
    }
    NSURL *theURL = [NSURL URLWithString: [NSString stringWithFormat:@"%sCheckUserNameExists?userName=%@",subURL,newString]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL      cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    //Specify method of request(Get or Post)
    [theRequest setHTTPMethod:@"GET"];
    
    //Pass some default parameter(like content-type etc.)
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //Now pass your own parameter
    
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          
          
          dispatch_async(dispatch_get_main_queue(), ^{
              NSError *theError = NULL;
              
              NSMutableArray *dataResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&theError];
            if([[dataResponse valueForKey:@"data"] isEqualToString:@"success"])
            {
                self.mobile_textfield.text=@"";

            [uAppDelegate showMessage:@"Invalid Email" withTitle:@"Message"];
            }
            else
            {
              
            }
          });
          
          //  NSLog(@"Delete webresponse=%@",res);
          
          
          
          
          
      }] resume];
    
    }
    if(textField==self.mobile_textfield)
    {
        NSString *newString = [self.mobile_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(newString.length==0)
        {
            return;
        }
        NSURL *theURL = [NSURL URLWithString: [NSString stringWithFormat:@"%sCheckMobileNumber?mobileNumber=%@",subURL,newString]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL      cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
        
        //Specify method of request(Get or Post)
        [theRequest setHTTPMethod:@"GET"];
        
        //Pass some default parameter(like content-type etc.)
        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [theRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        //Now pass your own parameter
        
        
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  NSError *theError = NULL;
                  
                  NSMutableArray *dataResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&theError];
                  if([[dataResponse valueForKey:@"data"] isEqualToString:@"success"])
                  {
                      [uAppDelegate showMessage:@"Invalid mobile" withTitle:@"Message"];
                      self.mobile_textfield.text=@"";
                  }
                  else
                  {
                      
                  }
              });
              
              //  NSLog(@"Delete webresponse=%@",res);
              
              
              
              
              
          }] resume];
        
    }
}

-(void)DoneButtonPressed{
    [self.coupontextfield resignFirstResponder];
    [self.vouchertextfield resignFirstResponder];
    [self.datefield resignFirstResponder];
    [self.time_field resignFirstResponder];
    [self.delivery_Area resignFirstResponder];
    [self.delivery_address resignFirstResponder];
    [self.nearestlandmark resignFirstResponder];
     [self.name resignFirstResponder];
     [self.email_textfield resignFirstResponder];
     [self.password_textfield resignFirstResponder];
     [self.mobile_textfield resignFirstResponder];
     [self.confirm_password resignFirstResponder];
    
}
-(void)loadareaData
{
   
    NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"Order/GetAllArea"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]   cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    //Specify method of request(Get or Post)
    [theRequest setHTTPMethod:@"GET"];
    
    //Pass some default parameter(like content-type etc.)
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //Now pass your own parameter
    
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          
          
          dispatch_async(dispatch_get_main_queue(), ^{
              NSError *theError = NULL;
              
              NSMutableArray *dataResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&theError];
            
              NSLog(@"are detail response%@",dataResponse);
              self.areaPicker=[[UIPickerView alloc]init];
               self.areaPicker.tag=2;
              self.areaArray =[[NSMutableArray alloc]init];
              [self.areaArray addObjectsFromArray:[dataResponse valueForKey:@"data"]];
             
              self.areaPicker.dataSource = self;
              self.areaPicker.delegate = self;
               self.delivery_Area.inputView=self.areaPicker;
              // [self loadcollectionData:dataResponse];
              
          });
          
      }] resume];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
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
     NSLog(@"test=%@",self.contentArray);
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = [[self.contentArray valueForKey:@"ItemTitle"]objectAtIndex:indexPath.row];
    
    UILabel *price = (UILabel *)[cell viewWithTag:3];
    price.text =[NSString stringWithFormat:@"%@ AED", [[self.contentArray valueForKey:@"ItemPrice"]objectAtIndex:indexPath.row]];
    
    UILabel *weight = (UILabel *)[cell viewWithTag:2];
    weight.text =[NSString stringWithFormat:@"%@", [[self.contentArray valueForKey:@"ItemQty"]objectAtIndex:indexPath.row]];
    
    UILabel *sumtotal = (UILabel *)[cell viewWithTag:4];
    sumtotal.text =[NSString stringWithFormat:@"%.2f", [[[self.contentArray valueForKey:@"ItemQty"]objectAtIndex:indexPath.row] floatValue]*[[[self.contentArray valueForKey:@"ItemPrice"]objectAtIndex:indexPath.row] floatValue]];
    
  
    return cell;
}

- (IBAction)submit_ButtonClick:(id)sender {
    [self OrderItemmethod];
}
-(void)OrderItemmethod
{
   //  NSString *deliverytime = [self.time_field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *deliverydate = [self.datefield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *deliveryArea = [self.delivery_Area.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *deliveryaddress = [self.delivery_address.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *landmark = [self.nearestlandmark.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *customername = [self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *mobile = [self.mobile_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *email = [self.email_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *customerId = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"customerId"];
   
    if(deliveryArea.length == 0)
    {
        [uAppDelegate showMessage:@"Please enter Delivery Area" withTitle:@"Message"];
        
        return;
        
    }
    else  if(deliveryaddress.length == 0)
    {
        
        [uAppDelegate showMessage:@"Please enter delivery address" withTitle:@"Message"];
        
        return;
        
    }
       else  if(self.accept_button.selected ==false)
    {
        [uAppDelegate showMessage:@"Please accept the terms and conditions" withTitle:@"Message"];
        return;
        
        
    }
    
   
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    [post setValue:[NSNumber numberWithInt:(int)_time_field.tag] forKey:@"DeliveryTime"];
    [post setValue:deliverydate forKey:@"DeliveryDate"];
     [post setValue:[NSNumber numberWithInt:(int)self.delivery_Area.tag] forKey:@"DeliveryArea"];
     [post setValue:deliveryaddress forKey:@"DeliveryNote"];
     [post setValue:[NSNumber numberWithBool:YES] forKey:@"TermsandConditions"];
    if(customerId.length>0)
    {
        NSString *Mobile = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"Mobile"];
        NSString *userName = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userName"];
        NSString *FirstName = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"FirstName"];
        [post setValue:[NSNumber numberWithInt:[customerId intValue]] forKey:@"CustomerId"];
        [post setValue:FirstName forKey:@"CustomerName"];
        [post setValue:Mobile forKey:@"Mobile"];
        [post setValue:userName forKey:@"Email"];
        
    }
    else
    {
        if(customername.length == 0)
        {
            
            [uAppDelegate showMessage:@"Please enter Customer Name" withTitle:@"Message"];
            
            return;
            
        }
        else  if(mobile.length > 9)
        {
            
            [uAppDelegate showMessage:@"Mobile number should not exceed 9 digits" withTitle:@"Message"];
            
            return;
            
        }
        else  if(mobile.length == 0)
        {
            
            [uAppDelegate showMessage:@"Please enter mobile number" withTitle:@"Message"];
            
            return;
            
        }
        else  if(email.length == 0)
        {
            
            [uAppDelegate showMessage:@"Please enter Email" withTitle:@"Message"];
            
            return;
            
        }

        
     [post setValue:[NSNumber numberWithInt:0] forKey:@"CustomerId"];
     [post setValue:customername forKey:@"CustomerName"];
     [post setValue:mobile forKey:@"Mobile"];
     [post setValue:email forKey:@"Email"];
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:@"Mobile"];
        [[NSUserDefaults standardUserDefaults] setObject:customername forKey:@"FirstName"];
    }
     [post setValue:deliveryaddress forKey:@"DeliveryAddress"];
     [post setValue:landmark forKey:@"DeliveryLocation"];
     [post setValue:@"Dubai" forKey:@"DeliveryEmirate"];
     [post setValue:deliveryaddress forKey:@"BillingAddress"];
     [post setValue:landmark forKey:@"BillingLocation"];
     [post setValue:@"Dubai" forKey:@"BillingEmirate"];
     if(customerId.length>0)
     {
        [post setValue:[NSNumber numberWithInt:1] forKey:@"CheckoutType"];
     }
     else
     {
       [post setValue:[NSNumber numberWithInt:2] forKey:@"CheckoutType"];
     }
     [post setValue:[NSNumber numberWithInt:[customerId intValue]] forKey:@"CustomerId"];
     [post setValue:[NSNumber numberWithFloat:sumtotal-voucherdiscount-coupondiscount] forKey:@"CartTotal"];
     [post setValue:[NSNumber numberWithFloat:sumtotal] forKey:@"SubTotal"];
     [post setValue:[NSNumber numberWithInt:0] forKey:@"DeliveryCharge"];
   // if(voucherdiscount+coupondiscount>0)
    {
        [post setValue:[NSNumber numberWithBool:YES] forKey:@"CouponApplied"];
        [post setValue:@"" forKey:@"Coupon"];
        [post setValue:[NSNumber numberWithInt:0] forKey:@"DiscountApplied"];
    }
    [post setValue:[NSNumber numberWithBool:YES] forKey:@"VoucherApplied"];
    [post setValue:@"" forKey:@"VoucherCode"];
    [post setValue:[NSNumber numberWithInt:1] forKey:@"PaymentType"];
    [post setValue:@"" forKey:@"Latitude"];
    [post setValue:@"" forKey:@"Longitude"];
    
    [indicator startAnimating];
     NSError *writeError = nil;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
     NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"Order/AddOrder"];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSError *error1;
          if(data==nil)
          {
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                   {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if([res valueForKey:@"data"])
                  {
                      [self addsuborder:[[res valueForKey:@"data"] intValue] orderreferenceid:[res valueForKey:@"data1"]] ;
                  }
                  else
                  {
                 
                  [uAppDelegate showMessage:@"An error occured" withTitle:@"Message"];
                  }
                 
              });
              
              
          }
          NSLog(@"webresponse=%@",res);
        
      }] resume];
    
}

-(void)addsuborder:(int)orderid orderreferenceid:(NSString*)orderreferenceid
{
    NSData *data= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * cartarray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  
    for (int i=0; i<cartarray.count; i++) {
        
        int itemid = [[[cartarray valueForKey:@"ItemId"] objectAtIndex:i] intValue];
        int ItemPrice = [[[cartarray valueForKey:@"ItemPrice"] objectAtIndex:i] intValue];
        int ItemPriceId = [[[cartarray valueForKey:@"ItemPriceId"] objectAtIndex:i] intValue];

         int ItemQty = [[[cartarray valueForKey:@"ItemQty"] objectAtIndex:i] intValue];
        NSString *ItemTitle = [[cartarray valueForKey:@"ItemTitle"] objectAtIndex:i];
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    [post setValue:[NSNumber numberWithInt:orderid] forKey:@"OrderId"];
    [post setValue:[NSNumber numberWithInt:itemid] forKey:@"ItemId"];
    [post setValue:[NSNumber numberWithInt:ItemPrice] forKey:@"Price"];
    [post setValue:[NSNumber numberWithInt:ItemPriceId] forKey:@"PriceId"];
    [post setValue:[NSNumber numberWithInt:ItemQty] forKey:@"Qty"];
    [post setValue:ItemTitle forKey:@"ItemName"];
    [post setValue:[NSNumber numberWithInt:0] forKey:@"PriceId"];
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"Order/AddSubOrder"];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSError *error1;
          if(data==nil)
          {
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if([res valueForKey:@"data"])
                  {
                      if(i==cartarray.count-1)
                      {
                      [self gettransactionid:orderid orderreferenceid:orderreferenceid];
                      }
                  }
                  else
                  {
                      
                      [uAppDelegate showMessage:@"An error occured" withTitle:@"Message"];
                  }
                  
              });
              
              
          }
          NSLog(@"webresponse=%@",res);
          
      }] resume];
        
    }

}
-(void)gettransactionid:(int)orderid orderreferenceid:(NSString*)orderreferenceid
{
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    [post setValue:[NSString stringWithFormat:@"%d",orderid] forKey:@"OrderId"];
    [post setValue:orderreferenceid forKey:@"OrderRef"];
    [post setValue:[NSString stringWithFormat:@"%f",sumtotal] forKey:@"Amount"];
   
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"Order/PaymentRegistration"];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSError *error1;
          if(data==nil)
          {
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if([res valueForKey:@"data"])
                  {
                      if(_creditdebitbutton.selected == true)
                      {
                      WebViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
                      ViewController.transactionid=[res valueForKey:@"data"];
                      ViewController.orderid=[NSString stringWithFormat:@"%d",orderid];
                      [self.navigationController pushViewController:ViewController animated:YES];
                      }
                      else
                      {
                          [self updatetransaction_service:orderid transactionid:[res valueForKey:@"data"]];
                      }
                  }
                  else
                  {
                      
                      [uAppDelegate showMessage:@"An error occured" withTitle:@"Message"];
                  }
                   [indicator stopAnimating];
              });
              
              
          }
          NSLog(@"webresponse=%@",res);
          
      }] resume];
    

}
-(void)updatetransaction_service:(int)orderid transactionid:(NSString*)transactionid
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"userName"];
    NSString *Mobile = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"Mobile"];
    NSString *FirstName = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"FirstName"];
    //NSData *data= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
   // NSMutableArray * cartarray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    [post setValue:[NSString stringWithFormat:@"%d",orderid] forKey:@"OrderId"];
    [post setValue:transactionid forKey:@"TransactionId"];
    [post setValue:userName forKey:@"Email"];
    [post setValue:Mobile forKey:@"Mobile"];
    [post setValue:FirstName forKey:@"CustomerName"];
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s",subURL,"api/Order/UpdateTransaction"];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSError *error1;
          if(data==nil)
          {
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CART"];
                  [self.navigationController popToRootViewControllerAnimated:NO];
                  NSString *data = [NSString stringWithFormat:@"%@",[res valueForKey:@"data"]];
                  if ([data length] > 0) {
                      [uAppDelegate showMessage:@"Your order has been placed successfully" withTitle:@"Message"];
                  }
                  else
                  {
                  [uAppDelegate showMessage:@"An error occured" withTitle:@"Message"];
                  }
              });
              
              
          }
          NSLog(@"webresponse=%@",res);
          
      }] resume];
    
    
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

-(void)setAllViews
{
    datePicker =[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];

    [datePicker setMinimumDate: tomorrow];
    datePicker.hidden=NO;
    datePicker.date=[NSDate date];
    [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    self.datefield.inputView= datePicker;
    
   /* timePicker =[[UIDatePicker alloc]init];
    timePicker.datePickerMode=UIDatePickerModeTime;
    timePicker.hidden=NO;
    //timePicker.date=[NSDate date];
    [timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    self.time_field.inputView= timePicker;*/
    
   
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPressed)];
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    self.datefield.inputAccessoryView = pickerToolbar;
   
    self.time_field.inputAccessoryView=pickerToolbar;
    
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
    {   if (pickerView.tag == 1 ){
    return [pickerData count];
    }
    else
    {
      return [self.areaArray count];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1 ){
        return [[pickerData objectAtIndex:row] valueForKey:@"slotTime"];
    }
    else
    {
        return [[self.areaArray objectAtIndex:row] valueForKey:@"AreaName"];
    }
   
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1 ){
    self.time_field.text=[[pickerData objectAtIndex:row] valueForKey:@"slotTime"];
    self.time_field.tag=[[[pickerData objectAtIndex:row] valueForKey:@"slotId"] intValue];;
    }
    else  if (pickerView.tag == 2 )
    {
    self.delivery_Area.text=[[self.areaArray objectAtIndex:row] valueForKey:@"AreaName"];
    self.delivery_Area.tag=[[[self.areaArray objectAtIndex:row] valueForKey:@"AreaId"] intValue];
    }
}

/*
- (void)timeChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:self.timePicker.date];
    NSLog(@"%@", currentTime);
    self.time_field.text=currentTime;
}*/
-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    //assign text to label
    self.datefield.text=str;
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
  
   
   // NSError *writeError = nil;
    // NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    // NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"User/LoginUser"];
  //  NSString *dateStr = @"04/14/2018";
    
    // Convert string to date object
  //  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   // [dateFormat setDateFormat:@"MM/dd/yyyy"];
   // NSDate *date = [dateFormat dateFromString:dateStr];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s?couponCode=%@&deliveryDate=%@",baseURL,"Order/CheckValidCouponDiscount",couponcode,(NSDate*)self.datefield.text];
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
               [uAppDelegate showMessage:@"Invalid Coupon" withTitle:@"Message"];
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          if(res!=nil)
          {
         
              dispatch_async(dispatch_get_main_queue(), ^{
                
               coupondiscount =  [ [res valueForKey:@"data"] intValue];
                  coupondiscount =  [ [res valueForKey:@"data"] intValue];
                  self.couponapply_button.hidden=true;
                  self.coupon_deletebutton.hidden=false;
                  self.coupontextfield.userInteractionEnabled=false;
                  self.discount_lbl.text=[NSString stringWithFormat:@"AED %d",coupondiscount];
                  
                  self.total_lbl.text=[NSString stringWithFormat:@"AED %.2f",sumtotal-coupondiscount];
                 
                  NSString *coupon = [NSString stringWithFormat:@"Applied coupon of %d",coupondiscount];
                  [uAppDelegate showMessage:coupon withTitle:@"Message"];
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

-(void)VoucherValidationmethod
{
    NSString *couponcode = [self.coupontextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    // NSError *writeError = nil;
    // NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    // NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"User/LoginUser"];
    //  NSString *dateStr = @"04/14/2018";
    
    // Convert string to date object
    //  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // [dateFormat setDateFormat:@"MM/dd/yyyy"];
    // NSDate *date = [dateFormat dateFromString:dateStr];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s?voucherCode=%@&deliveryDate=%@",baseURL,"Order/CheckValidVoucherDiscount",couponcode,(NSDate*)self.datefield.text];
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
            [uAppDelegate showMessage:@"Invalid Voucher" withTitle:@"Message"];
              return ;
          }
          NSMutableArray *res=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
          if(res!=nil)
          {
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  voucherdiscount =  [ [res valueForKey:@"data"] intValue];
                  self.voucherapply_button.hidden=true;
                  self.voucher_deletebutton.hidden=false;
                  self.vouchertextfield.userInteractionEnabled=false;
                  self.discount_lbl.text=[NSString stringWithFormat:@"AED %d",voucherdiscount];
                  self.total_lbl.text=[NSString stringWithFormat:@"AED %.2f",sumtotal-voucherdiscount];
                  NSString *voucher = [NSString stringWithFormat:@"Applied Voucher of %d",voucherdiscount];
                   [uAppDelegate showMessage:voucher withTitle:@"Message"];
              });
              
          }
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  
                  [uAppDelegate showMessage:@"Voucher Error" withTitle:@"Message"];
              });
              
              
          }
          NSLog(@"webresponse=%@",res);
          
      }] resume];
    
}


- (IBAction)ApplyVoucher_buttonClick:(id)sender {
    [self VoucherValidationmethod];
}
- (IBAction)creditdebit_buttonClick:(id)sender {
   
        self.creditdebitbutton.selected=true;
         self.cashondeliverybutton.selected=false;

   
}

- (IBAction)cashondelivery_buttonClick:(id)sender {
  
        self.cashondeliverybutton.selected=true;
        self.creditdebitbutton.selected=false;
    
    

}
- (IBAction)coupondelete_buttonClick:(id)sender {
     self.total_lbl.text=[NSString stringWithFormat:@"AED %.2f",sumtotal];
    coupondiscount=0;
    self.discount_lbl.text=[NSString stringWithFormat:@"AED %d",coupondiscount];
   
     self.coupontextfield.userInteractionEnabled=true;
    self.coupontextfield.text=@"";
}

- (IBAction)Voucherdelete_buttonClick:(id)sender {
    self.total_lbl.text=[NSString stringWithFormat:@"AED %.2f",sumtotal];
    voucherdiscount=0;
    self.discount_lbl.text=[NSString stringWithFormat:@"AED %d",voucherdiscount];
    self.vouchertextfield.userInteractionEnabled=true;
    self.vouchertextfield.text=@"";
}
@end
