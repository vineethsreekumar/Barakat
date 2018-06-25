//
//  HomeViewController.m
//  BarakatFresh
//
//  Created by vineeth on 4/10/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "HomeViewController.h"
#import "MenuScrollView.h"
#import "ForHerCell.h"
#import "UIImage+GIF.h"
#import "Config.h"

@interface HomeViewController ()<KASlideShowDataSource, KASlideShowDelegate,MenuScrollViewDelegate>
@property (weak, nonatomic) IBOutlet MenuScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *menu_underline;
@property (strong,nonatomic) IBOutlet KASlideShow * slideshow;

@end
UIScrollView *scrollview;
NSCache *imageCache;
@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _hasRun=true;
    [self KAslideShow];
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
    layout.itemSize = CGSizeMake(100, 100);
   // layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.naviHeight = 41;
    self.collectionview.collectionViewLayout =layout;

    self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    self.cart_lbl.layer.cornerRadius = 12.5;
    self.cart_lbl.layer.masksToBounds = YES;

    [self getContentService];
  
   // [self createcategory];
   // [self Loadtopimages];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self cartcount];
    NSData *data1= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * newcontentArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    float sumtotal=0.0;
    for (int i=0; i<newcontentArray.count; i++) {
        sumtotal = sumtotal+[[[newcontentArray valueForKey:@"ItemQty"]objectAtIndex:i] floatValue]*[[[newcontentArray valueForKey:@"ItemPrice"]objectAtIndex:i] floatValue];
        
    }
    self.sum_lbl.text =[NSString stringWithFormat:@"AED %.2f",sumtotal];
}
-(void)getContentService
{
    
        //NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.barakatfresh.ae/webservice/api/Home/LoadNavigationCategory"]];
      NSURL *theURL = [NSURL URLWithString: [NSString stringWithFormat:@"%s%s",baseURL,"Home/LoadNavigationCategory"]];
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
             // NSLog(@"navigation response%@",dataResponse);
              self.innerdatarray = [[NSMutableArray alloc]init];
              self.innerdatarray  = [dataResponse valueForKey:@"data"];
              NSMutableArray *groupname = [ self.innerdatarray  valueForKey:@"groupName"];
               NSMutableArray *groupid = [ self.innerdatarray  valueForKey:@"groupId"];
              self.menuScrollView.theDelegate = self;
            //  self.menu_underline.hidden = NO;
              for (int i=0; i<groupname.count; i++) {
                  [self.menuScrollView addItemWithTitle:[groupname objectAtIndex:i]];
                  [self.menuScrollView setTag:[[groupid objectAtIndex:i] intValue]];
              }
              /*[self.menuScrollView addItemWithTitle:@"Fruits"];
              [self.menuScrollView addItemWithTitle:@"Fresh Vegitables"];
              [self.menuScrollView addItemWithTitle:@"Fresh Juices"];
              [self.menuScrollView addItemWithTitle:@"Soups and Salads"];*/
              [self.menuScrollView moveMenuScrollViewToIndex:0 animated:NO];
              for (UIButton *item in self.menuScrollView.itemsCollection) {
                  // Customize view as you want
                  [item setTitleColor:[UIColor colorWithRed:72/255.0 green:194/255.0 blue:120/255.0 alpha:1] forState:UIControlStateNormal];
              }
            /*  if(self.innerdatarray.count>1)
              {
              [self loadcollectionData: [self.innerdatarray objectAtIndex:1]];
              }*/
             // NSLog(@"innerresponse response%@",groupname);
              
          });
          
          //  NSLog(@"Delete webresponse=%@",res);
          
          
          
          
          
      }] resume];
    
    
}


-(void)setUpNewsCubeMenu{
    // Create NCMenuItem
    // Base Image
    NSArray *anArray = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"freshfruiticon.png"],
                        [UIImage imageNamed:@"freshvegicon.png"],
                        [UIImage imageNamed:@"cutfruitsvegicon.png"],
                        [UIImage imageNamed:@"freshjuiceicon.png"],

                        [UIImage imageNamed:@"icecreamicon.png"],
                        
                        [UIImage imageNamed:@"soupsicon.png"],
                        nil];
    NSArray *selectedArray = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"freshfruiticon selected.png"],
                        [UIImage imageNamed:@"freshvegicon selected.png"],
                        [UIImage imageNamed:@"cutfruitsvegiconselected.png"],
                        [UIImage imageNamed:@"freshjuiceicon selected.png"],
                        [UIImage imageNamed:@"icecreamiconselected.png"],
                       
                        
                        [UIImage imageNamed:@"soupsiconselected.png"],
                        nil];
 //   UIImage *nc_button_baseImage = [UIImage imageNamed:@"Listicon.png"];
 //   UIImage *nc_button_highlightedBaseImage = [UIImage imageNamed:@"Listicon.png"];
    
    // ContentImage
 //   UIImage *nc_contentImage = [UIImage imageNamed:@"Listicon.png"];
    
    NSMutableArray *menus = [NSMutableArray array];
    for (int i = 0; i < anArray.count; i++) {
        
        UIImage *nc_button_baseImage = [anArray objectAtIndex:i];
        UIImage *nc_button_highlightedBaseImage =[selectedArray objectAtIndex:i];
        
        // ContentImage
        UIImage *nc_contentImage =[anArray objectAtIndex:i];
        

        NCMenuItem *menuItem = [[NCMenuItem alloc] initWithImage:nc_button_baseImage highlightedImage:nc_button_highlightedBaseImage ContentImage:nc_contentImage highlightedContentImage:nc_contentImage];
        if(i==0)
        {
            menuItem.highlighted=YES;
        }
        [menus addObject:menuItem];
    }
    
    CGRect newsCubeMenuPos = CGRectMake(0,0, self.view.frame.size.width, 60);
    _newsCubeMenu = [[NCMenu alloc] initWithFrame:newsCubeMenuPos withBackgroundColor:[UIColor clearColor] menuItems:menus];
    [_newsCubeMenu setDelegate:self];
    [self.menu_view addSubview:_newsCubeMenu];
    [self loadfirstcollectionite];
   
    // PopUpMenus
  /*  int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self popUpNewsCubeMenu];
    });
    */
}

-(void)popUpNewsCubeMenu{
    NSLog(@"%s",__func__);
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = _newsCubeMenu.frame;
                frame.origin.y -= _newsCubeMenu.frame.size.height;
        frame.origin.y -= frame.size.height;
        _newsCubeMenu.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)loadfirstcollectionite
{
      NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s",baseURL,"Home/LoadItemGroupBasedList?groupId=12&&LevelId=0"]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL      cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    //Specify method of request(Get or Post)
    [theRequest setHTTPMethod:@"GET"];
    
    //Pass some default parameter(like content-type etc.)
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //Now pass your own parameter
    
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          if(data==nil)
          {
              return ;
          }
          
          dispatch_async(dispatch_get_main_queue(), ^{
              NSError *theError = NULL;
              
              NSMutableArray *dataResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&theError];
           //   NSLog(@"url to send request= %@",theURL);
           //   NSLog(@"navigation response%@",dataResponse);
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
-(void)newsCubeMenu:(NCMenu *)menu didSelectIndex:(NSInteger)selectedIndex{
  
    int groupid =  [[ [self.innerdatarray objectAtIndex:selectedIndex]  valueForKey:@"groupId"] intValue];
    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"%sHome/LoadItemGroupBasedList?groupId=%d&&LevelId=0",baseURL,groupid]];
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
           //   NSLog(@"url to send request= %@",theURL);
           //   NSLog(@"navigation response%@",dataResponse);
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




-(void)loadcollectionData:(NSMutableArray*)jsonarray
{   self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    self.categoryContentarray =[[NSMutableArray alloc]init];
    [self.categoryContentarray addObject:@"spinach.jpg"];
   [self.categoryContentarray addObject:@"spinach.jpg"];
    [self.categoryContentarray addObject:@"spinach.jpg"];
    [self.categoryContentarray addObject:@"spinach.jpg"];
    [self.collectionview reloadData];
    
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width / 2.0f;
    return CGSizeMake(picDimension, picDimension+100);
    
 }*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width ;
    return CGSizeMake(picDimension, 170);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
   if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        }
       if(_hasRun==true)
       {
        
      
        _menu_view =  [reusableview viewWithTag:201];
         _menuScrollView =  [reusableview viewWithTag:202];
        _menu_underline =  [reusableview viewWithTag:203];
        [self setUpNewsCubeMenu];
       }
        _hasRun=false;
       
    }


    return reusableview;
   /* UICollectionViewLayoutAttributes *attributes = [self.superclass layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    
    attributes.frame = CGRectMake(0, 0, 100, 100);
    attributes.zIndex = 1024;
    
    return attributes;*/
   // return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        return CGSizeMake(0, 70);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section==0)
    {
        return 1;
    }
    else{
    return self.categoryContentarray.count;
    }
}
- (IBAction)history_buttonClick:(id)sender {
    HistoryViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Historyview"];
    [self.navigationController pushViewController:ViewController animated:YES];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
    {
        static NSString *identifier = @"slidingcell";
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        _slideshow =  [cell viewWithTag:200];
        [self KAslideShow];
        return cell;
    }
    else
    {
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
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activetextfield=textField;
    UICollectionViewCell *cell;
    UIView *superview = textField.superview;
    
    while (superview) {
        if([superview isKindOfClass:[UICollectionViewCell class]]) {
            cell = (UICollectionViewCell *)superview;
            break;
        }
        superview = superview.superview;
    }

    
    self.activeimageview=(UIImageView *)[cell viewWithTag:100];
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
    finalprice=currentprice;
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
    self.cart_lbl.text = [NSString stringWithFormat:@"%@",appDelegate.cartcount];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.tempcartarray];

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"CART"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSData *data1= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * newcontentArray = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    float sumtotal=0.0;
    for (int i=0; i<newcontentArray.count; i++) {
        sumtotal = sumtotal+[[[newcontentArray valueForKey:@"ItemQty"]objectAtIndex:i] floatValue]*[[[newcontentArray valueForKey:@"ItemPrice"]objectAtIndex:i] floatValue];
        
    }
    self.sum_lbl.text =[NSString stringWithFormat:@"AED %.2f",sumtotal];
    [uAppDelegate showMessage:@"Item Added to cart" withTitle:@"Message"];
   /*
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:&writeError];
    NSMutableURLRequest *urlrequest=[[NSMutableURLRequest alloc]init];
    NSString *urlstring = [NSString stringWithFormat:@"%s%s",baseURL,"Home/AddItemsToCart"];
    [urlrequest setURL:[NSURL URLWithString:urlstring]];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
         // [indicator stopAnimating];
          dispatch_async(dispatch_get_main_queue(), ^{
              NSString *outputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              
              if([outputString isEqualToString:@"\"Success\""])
              {
                  
              }
              
          });
      }] resume];*/


}
-(void)cartcount
{
    NSData *data= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * cart = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.cartcount=[NSNumber numberWithInteger:cart.count];
    self.cart_lbl.text = [NSString stringWithFormat:@"%@",appDelegate.cartcount];
    if(appDelegate.cartcount==0)
    {
        self.cart_lbl.hidden=true;
    }

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

-(void)createcategory
{
   
        // CLEARING ALL SUBVIEWS
    
        for (UIView *sub in self.categoryScrollview.subviews) {
            [sub removeFromSuperview];
        }
        self.categoryScrollview.backgroundColor = [UIColor clearColor];
        
        [self.categoryScrollview setContentOffset:CGPointZero];
        self.categoryScrollview.scrollEnabled=YES;
        
        // ADDING ITEMS TO THE LIST SCROLL
        
        CGFloat offsetValue = 10.0f;
        int colCount = 0;
        float yVal = 0.0f;
        float scrollHeight = 0.0f;
        
        ForHerCell * xy = [[ForHerCell alloc]init];
        CGFloat viewWidth = xy.frame.size.width;
        for (int i=1; ((i*viewWidth)<(self.categoryScrollview.frame.size.width-offsetValue)); i++)
        {
            colCount = i;
        }
        
    
                for (int i=0,j=0; i<3; i++,j=j+5)
                {
                    
                    int colIndex = i%colCount;
                    
                    ForHerCell * forHercell = [[ForHerCell alloc]init];
                    forHercell.frame = CGRectMake(((colIndex*viewWidth)+(offsetValue*colIndex)), (yVal+offsetValue),  forHercell.frame.size.width, forHercell.frame.size.height);
                   
                    forHercell.forHerProductName.text =@"haaaai";
                    
                    
                    [self.categoryScrollview addSubview:forHercell];
                    
                    if (colIndex == (colCount - 1))
                    {
                        yVal = forHercell.frame.origin.y + forHercell.frame.size.height;
                    }
                    
                    scrollHeight = forHercell.frame.origin.y + forHercell.frame.size.height;
                    
                }
                self.categoryScrollview.contentSize = CGSizeMake(self.categoryScrollview.frame.size.width, (scrollHeight + offsetValue));
    


}

- (void)menuMovedToItem:(UIButton *)item atIndex:(int)index {
    
 int groupid =  [[ [self.innerdatarray objectAtIndex:index]  valueForKey:@"groupId"] intValue];
       // NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.barakatfresh.ae/webservice/api/Home/LoadItemGroupBasedList?groupId=%d&&LevelId=0",groupid]];
     NSURL *theURL = [NSURL URLWithString: [NSString stringWithFormat:@"%sHome/LoadItemGroupBasedList?groupId=%d&&LevelId=0",baseURL,groupid]];
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
                //  NSLog(@"url to send request= %@",theURL);
                //  NSLog(@"navigation response%@",dataResponse);
                  self.categoryContentarray =[[NSMutableArray alloc]init];
                  [self.categoryContentarray addObjectsFromArray:[dataResponse valueForKey:@"data"]];
                  [self.collectionview reloadData];
                  [self.collectionview reloadData];
                 // [self loadcollectionData:dataResponse];
              
              });
              
              //  NSLog(@"Delete webresponse=%@",res);
              
              
              
              
              
          }] resume];
        

    
}
-(void)KAslideShow
{




//datasource = [@[[UIImage imageNamed:@"logo.png"],[NSURL URLWithString:@"https://i.imgur.com/7jDvjyt.jpg"],@"topbg.png"] mutableCopy];
    datasource = [@[[UIImage imageNamed:@"slider-new1.jpg"],
                    @"slider-new2.jpg"] mutableCopy];

// KASlideshow
_slideshow.datasource = self;
_slideshow.delegate = self;
[_slideshow setDelay:4]; // Delay between transitions
[_slideshow setTransitionDuration:2]; // Transition duration
[_slideshow setTransitionType:KASlideShowTransitionSlideHorizontal]; // Choose a transition type (fade or slide)
[_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
[_slideshow addGesture:KASlideShowGestureTap]; // Gesture t
  
//[_slideshow start];
}
-(void)viewDidAppear:(BOOL)animated
{
    [_slideshow start];
}
#pragma mark - KASlideShow datasource

- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return datasource[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return datasource.count;
}

#pragma mark - KASlideShow delegate

- (void) slideShowWillShowNext:(KASlideShow *)slideShow
{
   // NSLog(@"slideShowWillShowNext, index : %@",@(slideShow.currentIndex));
}

- (void) slideShowWillShowPrevious:(KASlideShow *)slideShow
{
   // NSLog(@"slideShowWillShowPrevious, index : %@",@(slideShow.currentIndex));
}

- (void) slideShowDidShowNext:(KASlideShow *)slideShow
{
   // NSLog(@"slideShowDidShowNext, index : %@",@(slideShow.currentIndex));
}

-(void) slideShowDidShowPrevious:(KASlideShow *)slideShow
{
   // NSLog(@"slideShowDidShowPrevious, index : %@",@(slideShow.currentIndex));
}

-(void)Loadtopimages
{
    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.main_slideview.frame.size.width, self.main_slideview.frame.size.height)];
    scr.tag = 1;
    scr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:scr];
    [self setupScrollView:scr];
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 264, 480, 36)];
    [pgCtr setTag:12];
    pgCtr.numberOfPages=10;
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    [self.main_slideview addSubview:pgCtr];
}
- (void)setupScrollView:(UIScrollView*)scrMain {
    // we have 10 images here.
    // we will add all images into a scrollView &amp; set the appropriate size.
    
    for (int i=1; i==10; i++) {
        // create image
      //  UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sti%02i.jpeg",i]];
        UIImage *image = [UIImage imageNamed:@"logo.png"];
        // create imageView
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height)];
        // set scale to fill
        imgV.contentMode=UIViewContentModeScaleToFill;
        // set image
        [imgV setImage:image];
        // apply tag to access in future
        imgV.tag=i+1;
        // add to scrollView
        [scrMain addSubview:imgV];
    }
    // set the content size to 10 image width
    [scrMain setContentSize:CGSizeMake(scrMain.frame.size.width*10, scrMain.frame.size.height)];
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer {
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    // same way, access pagecontroll access
    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:12];
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = scrMain.contentOffset.x;
    // calculate next page to display
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
    // if page is not 10, display it
    if( nextPage!=10 )  {
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=nextPage;
        // else start sliding form 1 :)
    } else {
        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=0;
    }
}
-(void)Loadscrollimage
{
   /* scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.main_slideview.bounds.size.width,self.main_slideview.bounds.size.height)];
    [scrollview setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    NSInteger viewcount= self.products_array.count;
    
    for(int i = 0; i< viewcount; i++)
    {
        CGFloat x = i * self.main_slideview.bounds.size.width;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0,self.main_slideview.bounds.size.width,self.main_slideview.bounds.size.height)];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
      
        view.backgroundColor = [UIColor clearColor];
       
        
        UIImageView *img_view=[[UIImageView alloc] initWithFrame:CGRectMake(80, 0, self.main_slideview.frame.size.width-160,self.main_slideview.frame.size.height)];
        
        NSURL *url = [[NSURL alloc] initWithString:[self.products_array objectAtIndex:i]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (data) {
                
                
                UIImage *image=[UIImage imageWithData:data];
                
                img_view.image=image;
                
                
            }
        }];
    }
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menu_buttonClick:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];

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
- (IBAction)searchview_buttonClick:(id)sender {
    SearchViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchView"];
    [self.navigationController pushViewController:ViewController animated:YES];

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
- (IBAction)myaccount_buttonClick:(id)sender {
   // [self customActionsheet];
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

        /*
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actionSheet.view.frame.size.width, actionSheet.view.frame.size.height)];
    background.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
   
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
    }]];
    
   
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose photo button tapped.
        LoginViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Loginview"];
        [self.navigationController pushViewController:ViewController animated:YES];
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"My Profile" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];*/
    }
}

- (IBAction)Home_buttonClick:(id)sender {
}

- (IBAction)Cart_buttonClick:(id)sender {
       CartViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    [self.navigationController pushViewController:ViewController animated:YES];

}

- (IBAction)cart_tabbuttonClick:(id)sender {
  /*  NSData *data= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * contentArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    float sumtotal=0.0;
    for (int i=0; i<contentArray.count; i++) {
        sumtotal = sumtotal+[[[contentArray valueForKey:@"ItemQty"]objectAtIndex:i] floatValue]*[[[contentArray valueForKey:@"ItemPrice"]objectAtIndex:i] floatValue];
        
    }
    if (sumtotal<75) {
        [uAppDelegate showMessage:@"Minimum order AED 75" withTitle:@"Message"];
        return;
    }*/

    CartViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CartView"];
    [self.navigationController pushViewController:ViewController animated:YES];
}
- (IBAction)more_buttonClick:(id)sender {
    
   /* UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:nil
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Policies"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Profile");
                                                privacyViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyView"];
                                                [self.navigationController pushViewController:ViewController animated:YES];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"About Us"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                AboutViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutView"];
                                                [self.navigationController pushViewController:ViewController animated:YES];
                                                //  NSLog(@"Clicked Purchase History");
                                                
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Contact Us"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Cancel");
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Cancel");
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];*/
    DefaultViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DefaultView"];
    [self.navigationController pushViewController:ViewController animated:YES];

}
@end
