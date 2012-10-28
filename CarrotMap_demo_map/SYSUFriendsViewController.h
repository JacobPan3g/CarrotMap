//
//  SYSUFriendsViewController.h
//  CarrotMap_demo_map
//
//  Created by Jacob Pan on 12-10-27.
//  Copyright (c) 2012年 王 瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYSUFriendsViewController : UITableViewController
{
    NSArray *friendsList;
}

- (id)initWithFriendsList:(NSArray *)argFriendsList;

@end
