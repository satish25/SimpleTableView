//
//  ViewController.m
//  DemoProject
//
//  Created by satheesh on 5/27/15.
//  Copyright (c) 2015 mawaqaa. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SecondViewController.h"

@interface ViewController ()
{

   NSArray *tableData;
    NSMutableData * responseData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   /* tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];*/
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *parameters = @{@"lang_key": @"en"};
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://kipcoadmin.mawaqaademo.com/service/API.svc/Category" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        
        tableData = [responseObject objectForKey:@"List"];
        [self.mTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
   
  //  NSLog(@"TableData %@",tableData);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NextTableView"]) {
        
        NSIndexPath * indexPath = [self.mTableView indexPathForSelectedRow];
        SecondViewController * nextTV = segue.destinationViewController;
        nextTV.categoryID = [[tableData objectAtIndex:indexPath.row]valueForKey:@"category_id"];
    }
  
}

#pragma mark - TableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
 
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * identifier = @"identifier";
    
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.mLabel.text = [[tableData objectAtIndex:indexPath.row]valueForKey:@"category_name"];
    
    
    NSURL *url = [NSURL URLWithString:[[tableData objectAtIndex:indexPath.row]valueForKey:@"category_image"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    __weak UITableViewCell *weakCell = cell;
    
    [cell.mImageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    return cell;
}

@end
