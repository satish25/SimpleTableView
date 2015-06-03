//
//  ViewController.m
//  DemoProject
//
//  Created by Satish on 5/27/15.
//  Copyright (c) 2015 Satish. All rights reserved.
//


/*
 
 Use this for AsyncImageView
 
 NSString * imgUrlString = [[tabledata objectAtIndex:indexPath.row] valueForKey:@"image"];
 if ([self isValid:[[tabledata objectAtIndex:indexPath.row] valueForKey:@"image"]])
 {
 // imgUrlString = [OfferDic objectForKey:@"Images"];
 if (![imgUrlString hasPrefix:@"http"])
 {
 imgUrlString = [NSString stringWithFormat:@"http://%@",imgUrlString];
 }
 }
 [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.mImageView];
 NSURL *url = [NSURL URLWithString:imgUrlString];
 ((AsyncImageView *)cell.mImageView).imageURL = url;
 
 
 -(BOOL)isValid:(id)sender
 {
 BOOL status = NO;
 if ((sender!=nil)&&(![sender isEqual:[NSNull null]]))
 {
 status = YES;
 }
 return status;
 }
 
 
 // Sipnner and URLConnetion Asyncronuc
 UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 indicator.frame = CGRectMake(0.0, 0.0, 200.0, 200.0);
 indicator.center = self.view.center;
 [self.tableView addSubview:indicator];
 [indicator bringSubviewToFront:self.view];
 [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
 
 
 //   self.navigationController.navigationBarHidden = YES;
 [indicator startAnimating];
 NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dairam.com/index.php?route=api/bestseller/list&language=1&currency=KWD"]];
 [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
 NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
 
 tabledata = [json objectForKey:@"products"];
 [self.tableView reloadData];
 NSLog(@"the output  array is %@",tabledata);
 [indicator stopAnimating];
 [indicator setHidden:YES];
 [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
 }];

 
 */
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
    
    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc]init];
    indicatorView.frame = CGRectMake(0, 0, 200, 200);
    indicatorView.center = self.view.center;
    [self.mTableView addSubview:indicatorView];
    [indicatorView bringSubviewToFront:self.view];
  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;

      [indicatorView startAnimating];
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
        NSLog(@"JSON tableData: %@", tableData);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
        
        [indicatorView stopAnimating];
        [indicatorView setHidden:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
   
  //  NSLog(@"TableData %@",tableData);
}
- (void)viewWillAppear:(BOOL)animated {
      [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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
                                       [weakCell layoutSubviews];
                                       
                                   } failure:nil];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
 UIView * new = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
  return new;
}

@end
