//
//  ViewController.h
//  DemoProject
//
//  Created by Satish on 5/27/15.
//  Copyright (c) 2015 Satish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

