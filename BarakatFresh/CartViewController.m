//
//  CartViewController.m
//  BarakatFresh
//
//  Created by vineeth on 4/30/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "CartViewController.h"
#import "Config.h"
@interface CartViewController ()

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPressed)];
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    self.search_textfield.inputAccessoryView = pickerToolbar;
    
   // [self loadfirstcollectionite];
    
    UIView *viewPassIntxtFieldDate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    UIImageView *imageViewpass = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
    imageViewpass.contentMode = UIViewContentModeScaleAspectFit;
    [imageViewpass setImage:[UIImage imageNamed:@"Searchiconpage.png"]];
    [viewPassIntxtFieldDate addSubview:imageViewpass];
   
    self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    NSData *data= [[NSUserDefaults standardUserDefaults] valueForKey:@"CART"];
    NSMutableArray * token = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.categoryContentarray =[[NSMutableArray alloc]init];
    [self.categoryContentarray addObjectsFromArray:token];
    [self.collectionview reloadData];
    
    // Do any additional setup after loading the view.
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
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPressed)];
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    self.search_textfield.inputAccessoryView = pickerToolbar;
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = [[self.categoryContentarray valueForKey:@"ItemTitle"]objectAtIndex:indexPath.row];
    
    UILabel *price = (UILabel *)[cell viewWithTag:2];
    price.text =[NSString stringWithFormat:@"Price: %@ AED", [[self.categoryContentarray valueForKey:@"ItemPrice"]objectAtIndex:indexPath.row]];
    
    UILabel *weight = (UILabel *)[cell viewWithTag:9];
    weight.text =[NSString stringWithFormat:@"/ %@", [[self.categoryContentarray valueForKey:@"ItemUnit"]objectAtIndex:indexPath.row]];
    
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
  //  NSLog(@"cart contentt=%@",self.categoryContentarray);
    recipeImageView.image= [UIImage sd_animatedGIFNamed:@"thumbnail"];
    
    NSString *photoString = [[self.categoryContentarray valueForKey:@"ItemImage"]objectAtIndex:indexPath.row] ;
    
    NSURL *url = [NSURL URLWithString:photoString];
    
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
    
    UILabel *selectedqty = (UILabel *)[cell viewWithTag:4];
    selectedqty.text =[NSString stringWithFormat:@"%@", [[self.categoryContentarray valueForKey:@"ItemQty"]objectAtIndex:indexPath.row]];

    UILabel *total = (UILabel *)[cell viewWithTag:10];
    float carttotal= [[[self.categoryContentarray valueForKey:@"ItemPrice"]objectAtIndex:indexPath.row] floatValue]*[[[self.categoryContentarray valueForKey:@"ItemQty"]objectAtIndex:indexPath.row] intValue];
    total.text =[NSString stringWithFormat:@"TotalPrice:%.2f", carttotal];
    

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
    UIButton *delete = (UIButton *)[cell viewWithTag:11];
    [delete addTarget:self action:@selector(deleteClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (IBAction)deleteClickEvent:(id)sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.collectionview];
    
    NSIndexPath *indexPath = [self.collectionview indexPathForItemAtPoint: currentTouchPosition];
    [self.categoryContentarray removeObjectAtIndex:indexPath.row];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.categoryContentarray];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"CART"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.collectionview reloadData];
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
        
        int carttotal= [[[self.categoryContentarray valueForKey:@"ItemPrice"]objectAtIndex:indexPath.row] intValue]*value.text.intValue;
        UILabel *total = (UILabel *)[cell viewWithTag:10];
        total.text =[NSString stringWithFormat:@"TotalPrice:%d", carttotal];

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
    
    
    int carttotal= [[[self.categoryContentarray valueForKey:@"ItemPrice"]objectAtIndex:indexPath.row] intValue]*value.text.intValue;
    UILabel *total = (UILabel *)[cell viewWithTag:10];
    total.text =[NSString stringWithFormat:@"TotalPrice:%d", carttotal];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu_buttonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)Checkout_buttonClick:(id)sender {
    CheckoutViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Checkoutview"];
    ViewController.passcontentarray = [[NSMutableArray alloc]init];
    ViewController.passcontentarray=self.categoryContentarray;
    [self.navigationController pushViewController:ViewController animated:YES];
}
@end
