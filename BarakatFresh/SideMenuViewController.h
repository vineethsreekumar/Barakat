

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Contacts/Contacts.h>
#import "ViewController.h"


@interface SideMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *contentArray;

@property (assign) NSInteger expandedSectionHeaderNumber;
@property (assign) UITableViewHeaderFooterView *expandedSectionHeader;
@property (strong) NSArray *sectionItems;
@property (strong) NSArray *sectionNames;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *imagearray;
- (IBAction)HomeButtonClick:(id)sender;

@end
