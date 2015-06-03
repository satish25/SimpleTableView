//
//  SecondViewController.h
//  DemoProject
//
//  Created by Satish on 5/27/15.
//  Copyright (c) 2015 Satish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *comTableView;
@property (strong , nonatomic) NSString * categoryID;


@end
