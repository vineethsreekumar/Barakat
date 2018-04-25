

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "UIColor+AppColors.h"

#import "Config.h"
static int const kHeaderSectionTag = 6900;
@implementation SideMenuViewController

#pragma mark -
#pragma mark - UITableViewDataSource

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section %d", section];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagearray=[[NSMutableArray alloc]initWithObjects:@"Fruitsside.png",@"VegetablesSide.png",@"cutfruits.png",@"Juices.png",@"icecreamside.png",@"Soups.png",@"party.png", nil];

   /* self.sectionNames = @[ @"iPhone", @"iPad", @"Apple Watch" ];
    self.sectionItems = @[ @[@"iPhone 5", @"iPhone 5s", @"iPhone 6", @"iPhone 6 Plus", @"iPhone 7", @"iPhone 7 Plus"],
                           @[@"iPad Mini", @"iPad Air 2", @"iPad Pro", @"iPad Pro 9.7"],
                           @[@"Apple Watch", @"Apple Watch 2", @"Apple Watch 2 (Nike)"]
                           ];
    // configure the tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.expandedSectionHeaderNumber = -1;*/
    [self getContactService];
}
-(void)getContactService
{
    
    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.barakatfresh.ae/webservice/api/Home/LoadNavigationCategory"]];
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
              NSLog(@"navigation response%@",dataResponse);
             NSMutableArray *innerdatarray = [[NSMutableArray alloc]init];
             innerdatarray  = [dataResponse valueForKey:@"data"];
              NSMutableArray *groupname = [innerdatarray  valueForKey:@"groupName"];
            //  NSMutableArray *groupid = [ innerdatarray  valueForKey:@"groupId"];
              self.sectionNames = groupname;
              self.sectionItems = [innerdatarray  valueForKey:@"itemCategories"];
              self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
              self.tableView.rowHeight = UITableViewAutomaticDimension;
              self.tableView.estimatedRowHeight = 100;
              self.expandedSectionHeaderNumber = -1;
            
              self.tableView.rowHeight = UITableViewAutomaticDimension;
              self.tableView.delegate=self;
              self.tableView.dataSource=self;
              [self.tableView setNeedsLayout];
              [self.tableView layoutIfNeeded];
              self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) ;
              [self.tableView reloadData];

              
          });
          
          //  NSLog(@"Delete webresponse=%@",res);
          
          
          
          
          
      }] resume];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.sectionNames.count > 0) {
        self.tableView.backgroundView = nil;
        return self.sectionNames.count;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"Retrieving data.\nPlease wait.";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
        [messageLabel sizeToFit];
        self.tableView.backgroundView = messageLabel;
        
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.expandedSectionHeaderNumber == section) {
        NSMutableArray *arrayOfItems = [self.sectionItems objectAtIndex:section];
        return arrayOfItems.count;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{  //NSMutableArray *arrayOfItems = [self.sectionNames objectAtIndex:indexPath.section];
   // NSMutableArray *innerarray = [[arrayOfItems objectAtIndex:indexPath.row] valueForKey:@"subCategories"];
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.sectionNames.count) {
        return [NSString stringWithFormat:@"     %@",[self.sectionNames objectAtIndex:section]];
    }
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // recast your view as a UITableViewHeaderFooterView
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    header.textLabel.textColor = [UIColor whiteColor];
    header.textLabel.font =[UIFont fontWithName:@"Helvetica Neue" size:15];
    UIImageView *viewWithTag = [self.view viewWithTag:kHeaderSectionTag + section];
    if (viewWithTag) {
        [viewWithTag removeFromSuperview];
    }
    
    UIImageView *sideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    sideImageView.image = [UIImage imageNamed:[self.imagearray objectAtIndex:section]];
   // sideImageView.tag = kHeaderSectionTag + section;
    [header addSubview:sideImageView];
    

    
    // add the arrow image
    CGSize headerFrame = self.view.frame.size;
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerFrame.width - 32, 13, 18, 18)];
    theImageView.image = [UIImage imageNamed:@"Chevron-Dn-Wht"];
    theImageView.tag = kHeaderSectionTag + section;
    [header addSubview:theImageView];
    
    // make headers touchable
    header.tag = section;
    UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderWasTouched:)];
    [header addGestureRecognizer:headerTapGesture];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
   
    NSMutableArray *section = [self.sectionItems objectAtIndex:indexPath.section];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font =[UIFont fontWithName:@"Helvetica Neue" size:15];
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",[[section objectAtIndex:indexPath.row] valueForKey:@"CategoryName"]];
    NSLog(@"headerarray=%@", section );

  /*  CustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"sample"];
    if(cell == nil)
    {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    NSMutableArray *section = [self.sectionItems objectAtIndex:indexPath.section];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [[section objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];
     NSLog(@"headerarray=%@", section );
    
    cell.headerAraay = section;
    
    cell.dataAraay= [[section objectAtIndex:indexPath.row] valueForKey:@"subCategories"];
    */
  /*  static NSString *cellIdentifier = @"categorycell";
    categoryCell *cell = (categoryCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSMutableArray *section = [self.sectionItems objectAtIndex:indexPath.section];
    if (cell == nil) {
        NSArray *t = [[NSBundle mainBundle] loadNibNamed:@"categoryCell" owner:nil options:nil];
        for (id currentObject in t)
        {
            if ([currentObject isKindOfClass:[categoryCell class]])
            {
                cell = (categoryCell *)currentObject;
                 cell.dataAraay= [[section objectAtIndex:indexPath.row] valueForKey:@"subCategories"];
                break;
            }
        }
    }*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateTableViewRowDisplay:(NSArray *)arrayOfIndexPaths {
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark - Expand / Collapse Methods

- (void)sectionHeaderWasTouched:(UITapGestureRecognizer *)sender {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger section = headerView.tag;
    UIImageView *eImageView = (UIImageView *)[headerView viewWithTag:kHeaderSectionTag + section];
    self.expandedSectionHeader = headerView;
    
    if (self.expandedSectionHeaderNumber == -1) {
        self.expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section withImage: eImageView];
    } else {
        if (self.expandedSectionHeaderNumber == section) {
            [self tableViewCollapeSection:section withImage: eImageView];
            self.expandedSectionHeader = nil;
        } else {
            UIImageView *cImageView  = (UIImageView *)[self.view viewWithTag:kHeaderSectionTag + self.expandedSectionHeaderNumber];
            [self tableViewCollapeSection:self.expandedSectionHeaderNumber withImage: cImageView];
            [self tableViewExpandSection:section withImage: eImageView];
        }
    }
}

- (void)tableViewCollapeSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = [self.sectionItems objectAtIndex:section];
    
    self.expandedSectionHeaderNumber = -1;
    if (sectionData.count == 0) {
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)tableViewExpandSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = [self.sectionItems objectAtIndex:section];
    
    if (sectionData.count == 0) {
        self.expandedSectionHeaderNumber = -1;
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((90.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        self.expandedSectionHeaderNumber = section;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}



@end
