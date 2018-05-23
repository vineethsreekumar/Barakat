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
    self.itemtitle.text = [self.passarray valueForKey:@"Title"];
    
   
    self.itemprice.text =[NSString stringWithFormat:@"Price: %@ AED", [self.passarray valueForKey:@"Price"]];
    
   
    self.itemweight.text =[NSString stringWithFormat:@"/ %@", [self.passarray valueForKey:@"Unit"]];
    
    
    
    NSString *photoString = [self.passarray valueForKey:@"Image"] ;
  
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
              self.nutrition_txtview.attributedText=[self returnattributtedstring:[dict valueForKey:@"Bebefits"]];
              self.storingins_txtview.attributedText=[self returnattributtedstring:[dict valueForKey:@"Usage"]];;
              
          });
          
          //  NSLog(@"Delete webresponse=%@",res);
          
          
          
          
          
      }] resume];
    
    

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
    
    NSString *ItemPrice = [self.passarray valueForKey:@"Price"];
    
    NSString *ItemImage = [self.passarray valueForKey:@"Image"];
    
    NSString *ItemUnit = [self.passarray valueForKey:@"Unit"];
    NSString *quantity = self.quantity_lbl.text;
    
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
   // self.cart_lbl.text = [NSString stringWithFormat:@"%@",appDelegate.cartcount];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.tempcartarray];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"CART"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [uAppDelegate showMessage:@"Item Added to cart" withTitle:@"Message"];

}
@end
