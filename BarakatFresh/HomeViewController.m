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
#import "Config.h"

@interface HomeViewController ()<KASlideShowDataSource, KASlideShowDelegate,MenuScrollViewDelegate>
@property (weak, nonatomic) IBOutlet MenuScrollView *menuScrollView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *menu_underline;
@property (strong,nonatomic) IBOutlet KASlideShow * slideshow;

@end
UIScrollView *scrollview;
@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self KAslideShow];
    self.menuScrollView.theDelegate = self;
     self.menu_underline.hidden = NO;
    [self.menuScrollView addItemWithTitle:@"Fruits"];
    [self.menuScrollView addItemWithTitle:@"Fresh Vegitables"];
    [self.menuScrollView addItemWithTitle:@"Fresh Juices"];
    [self.menuScrollView addItemWithTitle:@"Soups and Salads"];
    [self.menuScrollView moveMenuScrollViewToIndex:1 animated:NO];
    for (UIButton *item in self.menuScrollView.itemsCollection) {
        // Customize view as you want
        [item setTitleColor:[UIColor colorWithRed:72/255.0 green:194/255.0 blue:120/255.0 alpha:1] forState:UIControlStateNormal];
    }
    [self loadcollectionData];
   // [self createcategory];
   // [self Loadtopimages];
    // Do any additional setup after loading the view.
}
-(void)loadcollectionData
{   self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    self.categoryContentarray =[[NSMutableArray alloc]init];
    [self.categoryContentarray addObject:@"spinach.jpg"];
   [self.categoryContentarray addObject:@"spinach.jpg"];
    [self.categoryContentarray addObject:@"spinach.jpg"];
    [self.categoryContentarray addObject:@"spinach.jpg"];
    [self.collectionview reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryContentarray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[self.categoryContentarray objectAtIndex:indexPath.row]];
    
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
    
    return cell;
}

- (IBAction)minusClickEvent:(id)sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.collectionview];
    
    NSIndexPath *indexPath = [self.collectionview indexPathForItemAtPoint: currentTouchPosition];
    UICollectionViewCell *cell = [self.collectionview cellForItemAtIndexPath:indexPath];
    UILabel *value = (UILabel *)[cell viewWithTag:4];
    if(value.text.intValue>0)
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
}
-(void)KAslideShow
{




//datasource = [@[[UIImage imageNamed:@"logo.png"],[NSURL URLWithString:@"https://i.imgur.com/7jDvjyt.jpg"],@"topbg.png"] mutableCopy];
    datasource = [@[[UIImage imageNamed:@"slider-new1.jpg"],
                    @"slider-new2.jpg"] mutableCopy];

// KASlideshow
_slideshow.datasource = self;
_slideshow.delegate = self;
[_slideshow setDelay:1]; // Delay between transitions
[_slideshow setTransitionDuration:1]; // Transition duration
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
    NSLog(@"slideShowWillShowNext, index : %@",@(slideShow.currentIndex));
}

- (void) slideShowWillShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"slideShowWillShowPrevious, index : %@",@(slideShow.currentIndex));
}

- (void) slideShowDidShowNext:(KASlideShow *)slideShow
{
    NSLog(@"slideShowDidShowNext, index : %@",@(slideShow.currentIndex));
}

-(void) slideShowDidShowPrevious:(KASlideShow *)slideShow
{
    NSLog(@"slideShowDidShowPrevious, index : %@",@(slideShow.currentIndex));
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

- (IBAction)MyAccount_ButtonClick:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actionSheet.view.frame.size.width, actionSheet.view.frame.size.height)];
    background.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
   // [actionSheet.view addSubview:background];
   // [actionSheet.view setBackgroundColor:[UIColor greenColor]];
   /* UIAlertAction *firstAA       = [UIAlertAction actionWithTitle:@"Beep Beep"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^( UIAlertAction *action ){
                                                              
                                                             
                                                          }];
    [firstAA setValue:[UIImage imageNamed:@"menuicon.png"] forKey:@"image"];
    [actionSheet addAction:firstAA];*/

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Register" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // take photo button tapped.
       
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose photo button tapped.
        LoginViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Loginview"];
        [self.navigationController pushViewController:ViewController animated:YES];
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"My Profile" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
      
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Purchase History" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

}
@end
