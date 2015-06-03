//
//  SecondViewController.m
//  DemoProject
//
//  Created by Satish on 5/27/15.
//  Copyright (c) 2015 Satish. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"
#import "SecondTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface SecondViewController ()
{

    NSMutableArray * CompanyList;
    NSMutableArray * tabledata;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary * postDic = @{@"lang_key":@"en", @"category_id":self.categoryID};
    NSLog(@"The Response is %@",postDic);
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://kipcoadmin.mawaqaademo.com/service/API.svc/Company" parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        CompanyList = [responseObject objectForKey:@"List"];
       if (CompanyList.count==0) {
         [self.comTableView reloadData];
            return ;
        }
        
        tabledata =[[CompanyList valueForKey:@"Company_List"]objectAtIndex:0] ;
        [self.comTableView reloadData];
        
        NSLog(@"The Response is %@",tabledata);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"THe ERROR %@",error);
    }];
    
    
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tabledata count];
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString * CellIdentifier= @"CellIdentifier";
    
    SecondTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
     cell.companyName.text = [[tabledata objectAtIndex:indexPath.row]valueForKey:@"company_name"];
  /*  cell.companyName.text =  [[tabledata objectAtIndex:indexPath.row ]valueForKey:@"company_name"];*/
    
   /* cell.companyName.text = [[tabledata objectAtIndex:indexPath.row]valueForKey:@"company_name"];*/
    
    NSURL *url = [NSURL URLWithString:[[tabledata objectAtIndex:indexPath.row]valueForKey:@"company_image"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    __weak UITableViewCell *weakCell = cell;
    
    [cell.companyImage setImageWithURLRequest:request
                           placeholderImage:placeholderImage
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        
                                        weakCell.imageView.image = image;
                                        [weakCell setNeedsLayout];
                                        
                                    } failure:nil];
    return cell;
  
}

@end
