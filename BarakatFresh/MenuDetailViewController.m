//
//  MenuDetailViewController.m
//  BarakatFresh
//
//  Created by vineeth on 4/25/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "MenuDetailViewController.h"
#import "Config.h"
@interface MenuDetailViewController ()

@end

@implementation MenuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPressed)];
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    self.search_textfield.inputAccessoryView = pickerToolbar;
    
    [self loadfirstcollectionite];
    
    UIView *viewPassIntxtFieldDate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    UIImageView *imageViewpass = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
    imageViewpass.contentMode = UIViewContentModeScaleAspectFit;
    [imageViewpass setImage:[UIImage imageNamed:@"Searchiconpage.png"]];
    [viewPassIntxtFieldDate addSubview:imageViewpass];
    self.search_textfield.leftViewMode = UITextFieldViewModeAlways;
    self.search_textfield.leftView = viewPassIntxtFieldDate;
   
    self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    
    // Do any additional setup after loading the view.
}
-(void)loadfirstcollectionite
{
    NSLog(@"passcurrentarray=%@",self.passcurrentarray);
   // NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.barakatfresh.ae/webservice/api/Home/LoadItemGroupBasedList?groupId=%@&&LevelId=1",[[self.passcurrentarray valueForKey:@"CategoryId"] stringValue]]];
    NSURL *theURL = [NSURL URLWithString: [NSString stringWithFormat:@"%sHome/LoadItemGroupBasedList?groupId=%@&&LevelId=1",baseURL,[[self.passcurrentarray valueForKey:@"CategoryId"] stringValue]]];
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
              NSLog(@"url to send request= %@",theURL);
              NSLog(@"menu detail response%@",dataResponse);
              self.categoryContentarray =[[NSMutableArray alloc]init];
              [self.categoryContentarray addObjectsFromArray:[dataResponse valueForKey:@"data"]];
              self.indexArray = [[NSMutableArray alloc]init];
              for (int i =0; i<100; i++) {
                  [self.indexArray addObject:[NSNumber numberWithInt:0]];
              }

              [self.collectionview reloadData];
              // [self loadcollectionData:dataResponse];
              
          });
          
      }] resume];
    
    
}

-(void)DoneButtonPressed{
    [self.search_textfield resignFirstResponder];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryContentarray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width ;
    return CGSizeMake(picDimension, 170);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = [[self.categoryContentarray valueForKey:@"Title"]objectAtIndex:indexPath.row];
    
    
    
    UILabel *origin = (UILabel *)[cell viewWithTag:12];
    origin.text =[NSString stringWithFormat:@"Origin: %@", [[self.categoryContentarray valueForKey:@"Origin"]objectAtIndex:indexPath.row]];
    
    
    
    UITextField *newweight = (UITextField *)[cell viewWithTag:13];
    newweight.accessibilityValue = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down-arrow.png"]];
    arrow.frame = CGRectMake(0.0, 0.0, 20, 15);
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    newweight.delegate=self;
    newweight.rightView = arrow;
    newweight.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    
    NSMutableArray *temparray = [[self.categoryContentarray valueForKey:@"itemQtyImagePrice"] objectAtIndex:indexPath.row];
    int value = [[self.indexArray objectAtIndex:indexPath.row] intValue];
    if(temparray.count>0)
    {
        newweight.text=[[temparray objectAtIndex:value] valueForKey:@"ItemAvailable"];
    }
    else
    {
        newweight.text=@"not available";
    }
    
    
    UILabel *weight = (UILabel *)[cell viewWithTag:9];
    weight.text =[NSString stringWithFormat:@"/ %@", [[temparray objectAtIndex:value] valueForKey:@"ItemAvailable"]];
    
    
    UILabel *price = (UILabel *)[cell viewWithTag:2];
    price.text =[NSString stringWithFormat:@"Price: %@ AED", [[temparray valueForKey:@"Price"]objectAtIndex:value]];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(categoryDoneButtonPressed:)];
    doneBtn.tag=indexPath.row;
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    newweight.inputAccessoryView=pickerToolbar;
    
    NSString *photoString = [[temparray valueForKey:@"ImageFile"]objectAtIndex:value] ;
    recipeImageView.image= [UIImage sd_animatedGIFNamed:@"thumbnail"];
    NSURL *url = [NSURL URLWithString:[photoString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    dispatch_queue_t queue = dispatch_queue_create("photoList", NULL);
    
    // Start getting the data in the background
    dispatch_async(queue, ^{
        NSData* photoData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:photoData];
        
        // Once we get the data, update the UI on the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            recipeImageView.image = image;
        });
    });
    
    
    // recipeImageView.image = [UIImage imageNamed:];
    
    /*
     NSURL *url = [NSURL URLWithString:[[self.categoryContentarray objectAtIndex:indexPath.row] valueForKey:@"Image"]];
     NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     if (data) {
     UIImage *image = [UIImage imageWithData:data];
     if (image) {
     dispatch_async(dispatch_get_main_queue(), ^{
     
     recipeImageView.image = image;
     });
     }
     }
     }];
     [task resume];*/
    
    
    UIButton *minus = (UIButton *)[cell viewWithTag:3];
    [minus addTarget:self action:@selector(minusClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *plus = (UIButton *)[cell viewWithTag:5];
    [plus addTarget:self action:@selector(plusClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    UIView *addbutton = (UIView*)[cell viewWithTag:6];
    addbutton.layer.cornerRadius = 12.5;
    addbutton.layer.masksToBounds = YES;
    
    UIView *quantityview = (UIView*)[cell viewWithTag:7];
    quantityview.layer.cornerRadius = 12.5;
    quantityview.layer.masksToBounds = YES;
    
    UIButton *addcart = (UIButton *)[cell viewWithTag:6];
    [addcart addTarget:self action:@selector(AddtoCardButtonClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    UICollectionViewCell *cell;
    UIView *superview = textField.superview;
    
    while (superview) {
        if([superview isKindOfClass:[UICollectionViewCell class]]) {
            cell = (UICollectionViewCell *)superview;
            break;
        }
        superview = superview.superview;
    }
    
    
    
    NSMutableArray *temparray = [[self.categoryContentarray valueForKey:@"itemQtyImagePrice"] objectAtIndex:[textField.accessibilityValue intValue]];
    self.dataArray = [[NSMutableArray alloc] init];
    // Add some data for demo purposes.
    
    [self.dataArray addObjectsFromArray:temparray];
    
    UIPickerView *categoryPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    [categoryPickerView setDataSource: self];
    [categoryPickerView setDelegate: self];
    categoryPickerView.showsSelectionIndicator = YES;
    categoryPickerView.tag=[textField.accessibilityValue intValue];
    
    textField.inputView = categoryPickerView;
    
    
    
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    
    /*   NSLog(@"%@",[self.dataArray objectAtIndex:row]);
     self.activetextfield.text=[[self.dataArray objectAtIndex:row] valueForKey:@"ItemAvailable"];
     self.activetextfield.accessibilityValue=[NSString stringWithFormat:@"%ld", (long)row];
     
     NSData* photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:row] valueForKey:@"ImageFile"]]];
     UIImage* image = [UIImage imageWithData:photoData];
     self.activeimageview.image =image;
     pickerView.tag = row;*/
    NSLog(@"pickertag=%ld",(long)pickerView.tag);
    [self.indexArray replaceObjectAtIndex:pickerView.tag withObject:[NSNumber numberWithInt:(int)row]];
    //  [self.collectionview reloadData];
    [self.collectionview performBatchUpdates:^{
        [self.collectionview reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:pickerView.tag inSection:0]]];
    } completion:nil];
    
    //  self.categorytextfield.text = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:row]];
    
    // selectedCategory = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:row]];
}
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSLog(@"datacount%lu",(unsigned long)[self.dataArray count]);
    return [self.dataArray count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.dataArray objectAtIndex:row] valueForKey:@"ItemAvailable"];
    
    
    
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

-(void)categoryDoneButtonPressed:(id)sender{
    [self.view endEditing:true];
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSMutableArray *temparray = [[self.categoryContentarray valueForKey:@"itemQtyImagePrice"] objectAtIndex:indexPath.row];
    int value = [[self.indexArray objectAtIndex:indexPath.row] intValue];
    
    ItemDetailViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailView"];
    ViewController.passarray=[[NSMutableDictionary alloc]init];
    ViewController.innerarray=[[NSMutableArray alloc]init];
    ViewController.passarray=[self.categoryContentarray objectAtIndex:indexPath.row];
    ViewController.innerarray=[temparray objectAtIndex:value];
    ViewController.indexnumber = [NSNumber numberWithInt:value];
    [self.navigationController pushViewController:ViewController animated:YES];
}
- (void)AddtoCardButtonClick:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.collectionview];
    
    NSIndexPath *indexPath = [self.collectionview indexPathForItemAtPoint: currentTouchPosition];
    UICollectionViewCell *cell = [self.collectionview cellForItemAtIndexPath:indexPath];
    UILabel *cartlbl = (UILabel *)[cell viewWithTag:4];
    
    NSMutableArray *temparray = [[self.categoryContentarray valueForKey:@"itemQtyImagePrice"] objectAtIndex:indexPath.row];
    int value = [[self.indexArray objectAtIndex:indexPath.row] intValue];
    
    NSData *cartdata= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * token = [NSKeyedUnarchiver unarchiveObjectWithData:cartdata];
    NSString *itemid = [[self.categoryContentarray valueForKey:@"Id"]objectAtIndex:indexPath.row];
    NSString *priceid = [[temparray valueForKey:@"PriceId"]objectAtIndex:value];
    NSString *ItemPrice = [[temparray valueForKey:@"Price"]objectAtIndex:value];
    
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.ItemPriceId == %@",priceid];
    NSArray *contentArray = [token filteredArrayUsingPredicate:bPredicate];
    NSLog(@"HERE %@",contentArray);
    int finalquantity =0;
    float finalprice=0.0;
    int filteredindex=0;
    if(contentArray.count>0)
    {
        int currentquantity =[[[contentArray valueForKey:@"ItemQty"] objectAtIndex:0] intValue];
        float currentprice =[[[contentArray valueForKey:@"ItemPrice"] objectAtIndex:0] intValue];
        
        finalquantity= [cartlbl.text intValue] + currentquantity;
        finalprice=currentprice+[ItemPrice floatValue];
        NSInteger index = [token indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [bPredicate evaluateWithObject:obj];
        }];
        
        NSLog(@"Index of object %d",index);
        filteredindex = (int)index;
    }
    else
    {
        finalquantity = [cartlbl.text intValue];
        finalprice=[ItemPrice floatValue];
    }
    
    // [indicator startAnimating];
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    NSString *ItemTypeId = [[self.categoryContentarray valueForKey:@"Group"]objectAtIndex:indexPath.row];
    
    NSString *ItemTitle = [[self.categoryContentarray valueForKey:@"Title"]objectAtIndex:indexPath.row];
    
    
    NSString *ItemImage = [[temparray valueForKey:@"ImageFile"]objectAtIndex:value];
    
    NSString *ItemUnit = [[temparray valueForKey:@"ItemAvailable"]objectAtIndex:value];
    NSString *quantity = [NSString stringWithFormat:@"%d",finalquantity];
    
    [post setValue:itemid forKey:@"ItemId"];
    [post setValue:ItemTypeId forKey:@"ItemTypeId"];
    [post setValue:ItemTitle forKey:@"ItemTitle"];
    [post setValue:[NSString stringWithFormat:@"%.2f",finalprice] forKey:@"ItemPrice"];
    [post setValue:priceid forKey:@"ItemPriceId"];
    [post setValue:ItemImage forKey:@"ItemImage"];
    [post setValue:ItemUnit forKey:@"ItemUnit"];
    [post setValue:quantity forKey:@"ItemQty"];
    //  [post setValue:self.confirm_password.text forKey:@"Total"];
    
    self.tempcartarray=[[NSMutableArray alloc]init];
    if( [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"])
    {
        NSData *data= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
        NSMutableArray * token = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.tempcartarray addObjectsFromArray:token];
    }
    if(contentArray.count>0)
    {
        [self.tempcartarray replaceObjectAtIndex:filteredindex withObject:post];
    }
    else
    {
        [self.tempcartarray addObject:post];
    }
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.cartcount=[NSNumber numberWithInteger:self.tempcartarray.count];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.tempcartarray];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"CART"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [uAppDelegate showMessage:@"Item Added to cart" withTitle:@"Message"];
    
    
}

- (IBAction)minusClickEvent:(id)sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.collectionview];
    
    NSIndexPath *indexPath = [self.collectionview indexPathForItemAtPoint: currentTouchPosition];
    UICollectionViewCell *cell = [self.collectionview cellForItemAtIndexPath:indexPath];
    UILabel *value = (UILabel *)[cell viewWithTag:4];
    if(value.text.intValue>1)
    {
        value.text= [NSString stringWithFormat:@"%d",value.text.intValue-1];
    }
    
    
}
- (IBAction)plusClickEvent:(id)sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.collectionview];
    
    NSIndexPath *indexPath = [self.collectionview indexPathForItemAtPoint: currentTouchPosition];
    UICollectionViewCell *cell = [self.collectionview cellForItemAtIndexPath:indexPath];
    UILabel *value = (UILabel *)[cell viewWithTag:4];
    
    value.text= [NSString stringWithFormat:@"%d",value.text.intValue+1];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu_buttonClick:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];

}


- (IBAction)homebutton_click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HomeViewController *homeController = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:homeController];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

}

- (IBAction)searchbutton_Click:(id)sender {
    SearchViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchView"];
    [self.navigationController pushViewController:ViewController animated:NO];
}

- (IBAction)cartbutton_Click:(id)sender {
    NSData *data= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * contentArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    float sumtotal=0.0;
    for (int i=0; i<contentArray.count; i++) {
        sumtotal = sumtotal+[[[contentArray valueForKey:@"ItemQty"]objectAtIndex:i] floatValue]*[[[contentArray valueForKey:@"ItemPrice"]objectAtIndex:i] floatValue];
        
    }
    if (sumtotal<75) {
        [uAppDelegate showMessage:@"Minimum order AED 75" withTitle:@"Message"];
        return;
    }
    CartViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    [self.navigationController pushViewController:ViewController animated:NO];
}

- (IBAction)myaccountbutton_Click:(id)sender {
    NSString *customerId = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"customerId"];
    if(customerId.length>0)
    {
        [self customActionsheet];
    }
    else
    {
        LoginViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Loginview"];
        [self.navigationController pushViewController:ViewController animated:YES];
    }
}
-(void)customActionsheet
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"userName"];
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"HI"
                                        message:userName
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    /* [alert addAction:[UIAlertAction actionWithTitle:@"Profile"
     style:UIAlertActionStyleDefault
     handler:^void (UIAlertAction *action) {
     NSLog(@"Clicked Profile");
     }]];*/
    [alert addAction:[UIAlertAction actionWithTitle:@"Purchase History"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked history");
                                                HistoryViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Historyview"];
                                                [self.navigationController pushViewController:ViewController animated:YES];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Logout"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                //  NSLog(@"Clicked Purchase History");
                                                NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                                                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Cancel");
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)morebutton_Click:(id)sender {
    DefaultViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DefaultView"];
    [self.navigationController pushViewController:ViewController animated:NO];
}
@end
