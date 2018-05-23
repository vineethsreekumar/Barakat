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
    return CGSizeMake(picDimension, 130);
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    // [[cell contentView] setFrame:[cell bounds]];
    // [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = [[self.categoryContentarray valueForKey:@"Title"]objectAtIndex:indexPath.row];
    
    UILabel *price = (UILabel *)[cell viewWithTag:2];
    price.text =[NSString stringWithFormat:@"Price: %@ AED", [[self.categoryContentarray valueForKey:@"Price"]objectAtIndex:indexPath.row]];
    
    UILabel *weight = (UILabel *)[cell viewWithTag:9];
    weight.text =[NSString stringWithFormat:@"/ %@", [[self.categoryContentarray valueForKey:@"Unit"]objectAtIndex:indexPath.row]];
    
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    NSLog(@"contentt=%@",self.categoryContentarray);
    recipeImageView.image= [UIImage sd_animatedGIFNamed:@"thumbnail"];
    
    NSString *photoString = [[self.categoryContentarray valueForKey:@"Image"]objectAtIndex:indexPath.row] ;
    
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
    
    
    
    UIButton *minus = (UIButton *)[cell viewWithTag:3];
    [minus addTarget:self action:@selector(minusClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *plus = (UIButton *)[cell viewWithTag:5];
    [plus addTarget:self action:@selector(plusClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    UIView *addbutton = (UIView*)[cell viewWithTag:6];
    addbutton.layer.cornerRadius = 15;
    addbutton.layer.masksToBounds = YES;
    
    UIView *quantityview = (UIView*)[cell viewWithTag:7];
    quantityview.layer.cornerRadius = 15;
    quantityview.layer.masksToBounds = YES;
    
    UIButton *addcart = (UIButton*)[cell viewWithTag:6];
    [addcart addTarget:self action:@selector(AddtoCardButtonClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    ItemDetailViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailView"];
    ViewController.passarray=[[NSMutableDictionary alloc]init];
    ViewController.passarray=[self.categoryContentarray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ViewController animated:YES];
}
- (void)AddtoCardButtonClick:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.collectionview];
    
    NSIndexPath *indexPath = [self.collectionview indexPathForItemAtPoint: currentTouchPosition];
    UICollectionViewCell *cell = [self.collectionview cellForItemAtIndexPath:indexPath];
    UILabel *cartlbl = (UILabel *)[cell viewWithTag:4];
    
    // [indicator startAnimating];
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    NSString *itemid = [[self.categoryContentarray valueForKey:@"Id"]objectAtIndex:indexPath.row];
    NSString *ItemTypeId = [[self.categoryContentarray valueForKey:@"Group"]objectAtIndex:indexPath.row];
    
    NSString *ItemTitle = [[self.categoryContentarray valueForKey:@"Title"]objectAtIndex:indexPath.row];
    
    NSString *ItemPrice = [[self.categoryContentarray valueForKey:@"Price"]objectAtIndex:indexPath.row];
    
    NSString *ItemImage = [[self.categoryContentarray valueForKey:@"Image"]objectAtIndex:indexPath.row];
    
    NSString *ItemUnit = [[self.categoryContentarray valueForKey:@"Unit"]objectAtIndex:indexPath.row];
    NSString *quantity = cartlbl.text;
    
    [post setValue:itemid forKey:@"ItemId"];
    [post setValue:ItemTypeId forKey:@"ItemTypeId"];
    [post setValue:ItemTitle forKey:@"ItemTitle"];
    [post setValue:ItemPrice forKey:@"ItemPrice"];
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
    [self.tempcartarray addObject:post];
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


@end
