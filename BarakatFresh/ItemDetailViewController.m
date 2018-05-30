//
//  ItemDetailViewController.m
//  BarakatFresh
//
//  Created by vineeth on 5/16/18.
//  Copyright © 2018 MyOrganization. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "UIImage+GIF.h"
#import "Config.h"
@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down-arrow.png"]];
    arrow.frame = CGRectMake(0.0, 0.0, 20, 15);
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    self.category_txtfield.delegate=self;
    self.category_txtfield.rightView = arrow;
    self.category_txtfield.rightViewMode = UITextFieldViewModeAlways;
    self.itemtitle.text = [self.passarray valueForKey:@"Title"];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(categoryDoneButtonPressed:)];
    [pickerToolbar setItems:@[flexSpace, flexSpace, doneBtn] animated:YES];
    self.category_txtfield.inputAccessoryView=pickerToolbar;

    
    NSMutableArray *temparray = [self.passarray valueForKey:@"itemQtyImagePrice"];
    self.dataArray = [[NSMutableArray alloc] init];
    // Add some data for demo purposes.
    
    [self.dataArray addObjectsFromArray:temparray];
    
    UIPickerView *categoryPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    [categoryPickerView setDataSource: self];
    [categoryPickerView setDelegate: self];
    categoryPickerView.showsSelectionIndicator = YES;
    
    self.category_txtfield.inputView = categoryPickerView;

    
    
    self.itemprice.text =[NSString stringWithFormat:@"Price: %@ AED", [self.innerarray valueForKey:@"Price"]];
    
   
    self.itemweight.text =[NSString stringWithFormat:@"/ %@", [self.innerarray valueForKey:@"ItemAvailable"]];
    
    self.origin_lbl.text =[NSString stringWithFormat:@"Origin: %@", [self.passarray valueForKey:@"Origin"]];
    
    NSString *photoString = [self.innerarray valueForKey:@"ImageFile"] ;
  
    self.itemimage.image= [UIImage sd_animatedGIFNamed:@"thumbnail"];
    NSURL *url = [NSURL URLWithString:[photoString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    dispatch_queue_t queue = dispatch_queue_create("photoList", NULL);
    
    // Start getting the data in the background
    dispatch_async(queue, ^{
        NSData* photoData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:photoData];
        
        // Once we get the data, update the UI on the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.itemimage.image = image;
        });
    });
    
    [self loaditemdescriptionanddetails];
    

    // Do any additional setup after loading the view.
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
    
     self.category_txtfield.text = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:row]];
    
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


-(void)loaditemdescriptionanddetails
{
    NSString *newString =[self.passarray valueForKey:@"Id"];
    NSURL *theURL = [NSURL URLWithString: [NSString stringWithFormat:@"%sHome/GetItemDetails?ItemId=%@",baseURL,newString]];
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
              NSLog(@"dataResponse webresponse=%@",dataResponse);
              NSMutableDictionary *dict =[[dataResponse valueForKey:@"data"] objectAtIndex:0];
             // self.desc_txtview.text=[dict valueForKey:@"Description"];
              NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                      initWithData: [[dict valueForKey:@"Description"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                      options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                      documentAttributes: nil
                                                      error: nil
                                                      ];
              self.desc_txtview.attributedText = attributedString;
              self.desc_txtview.delegate=self;
            /*  CGRect frame = self.desc_txtview.frame;
              
              frame.size = self.desc_txtview.contentSize;
              
              self.desc_txtview.frame = frame;
              
              [self.desc_txtview sizeThatFits:CGSizeMake(self.desc_txtview.frame.size.width, CGFLOAT_MAX)];*/
              CGSize sizeThatFitsTextView = [self.desc_txtview sizeThatFits:CGSizeMake(self.desc_txtview.frame.size.width, MAXFLOAT)];
              
              self.descheightconstraint.constant = sizeThatFitsTextView.height;

              self.nutrition_txtview.attributedText=[self returnattributtedstring:[dict valueForKey:@"Bebefits"]];
              
              CGSize sizeThatFitsTextView1 = [self.nutrition_txtview sizeThatFits:CGSizeMake(self.nutrition_txtview.frame.size.width, MAXFLOAT)];
              
              self.benifitsheightconstraint.constant = sizeThatFitsTextView1.height;
              
              
              self.storingins_txtview.attributedText=[self returnattributtedstring:[dict valueForKey:@"Usage"]];;
              
              
              CGSize sizeThatFitsTextView2 = [self.storingins_txtview sizeThatFits:CGSizeMake(self.storingins_txtview.frame.size.width, MAXFLOAT)];
              
              self.useheightconstraint.constant = sizeThatFitsTextView2.height;


              
          });
          
          //  NSLog(@"Delete webresponse=%@",res);
          
          
          
          
          
      }] resume];
    
    

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1500)];
}
- (void)textViewDidChange:(UITextView *)txtView{
    float height = txtView.contentSize.height;
    [UITextView beginAnimations:nil context:nil];
    [UITextView setAnimationDuration:0.5];
    
    CGRect frame = txtView.frame;
    frame.size.height = height + 10.0; //Give it some padding
    txtView.frame = frame;
    [UITextView commitAnimations];
}

-(NSAttributedString*)returnattributtedstring:(NSString*)data
{
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [data dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    return attributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu_buttonClick:(id)sender {
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

- (IBAction)minus_buttonClick:(id)sender {
    
    if(self.quantity_lbl.text.intValue>1)
    {
        self.quantity_lbl.text= [NSString stringWithFormat:@"%d",self.quantity_lbl.text.intValue-1];
    }
    

}

- (IBAction)plus_buttonClick:(id)sender {
   
    
    self.quantity_lbl.text= [NSString stringWithFormat:@"%d",self.quantity_lbl.text.intValue+1];

}

- (IBAction)Addtocart_buttonClick:(id)sender {
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
  
    NSString *itemid = [self.passarray valueForKey:@"Id"];
    NSString *ItemTypeId = [self.passarray valueForKey:@"Group"];
    
    NSString *ItemTitle = [self.passarray valueForKey:@"Title"];
    
    NSString *ItemPrice = [self.innerarray valueForKey:@"Price"];
    
    NSString *ItemImage = [self.innerarray valueForKey:@"ImageFile"];
    
    NSString *ItemUnit = [self.innerarray valueForKey:@"ItemAvailable"];
    NSString *priceid = [self.innerarray valueForKey:@"PriceId"];
    NSString *quantity = self.quantity_lbl.text;
    
    [post setValue:itemid forKey:@"ItemId"];
    [post setValue:ItemTypeId forKey:@"ItemTypeId"];
    [post setValue:ItemTitle forKey:@"ItemTitle"];
    [post setValue:ItemPrice forKey:@"ItemPrice"];
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
    [self.tempcartarray addObject:post];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.cartcount=[NSNumber numberWithInteger:self.tempcartarray.count];
   // self.cart_lbl.text = [NSString stringWithFormat:@"%@",appDelegate.cartcount];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.tempcartarray];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"CART"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [uAppDelegate showMessage:@"Item Added to cart" withTitle:@"Message"];

}
@end
