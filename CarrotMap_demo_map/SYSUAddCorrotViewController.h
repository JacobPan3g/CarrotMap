//
//  SYSUAddCorrotViewController.h
//  CarrotMap_demo_map
//
//  Created by Jacob Pan on 12-10-27.
//  Copyright (c) 2012年 王 瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSUFriendsViewController.h"

@interface SYSUAddCorrotViewController : UIViewController
{
    NSDictionary *userInfo;
    NSArray *friendsList;
}

@property (nonatomic, strong) UITextField *inputBox;
@property (nonatomic, strong) UIButton *addfriendBtn;

@property (nonatomic, strong) SYSUFriendsViewController *friendsVC;

- (id)initWithUserInfo:(NSDictionary *)argUserInfo withFriendsList:(NSArray *)argFriendsList;

@end
