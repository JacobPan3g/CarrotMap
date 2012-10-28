//
//  SYSUAddCorrotViewController.m
//  CarrotMap_demo_map
//
//  Created by Jacob Pan on 12-10-27.
//  Copyright (c) 2012年 王 瑞. All rights reserved.
//

#import "SYSUAddCorrotViewController.h"

@interface SYSUAddCorrotViewController ()

- (void)addfriendBtnPressed;

@end

@implementation SYSUAddCorrotViewController

@synthesize inputBox, addfriendBtn, friendsVC;

- (id)initWithUserInfo:(NSDictionary *)argUserInfo withFriendsList:(NSArray *)argFriendsList
{
    self = [super init];
    if (self) {
        userInfo = argUserInfo;
        friendsList = argFriendsList;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.inputBox = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 200, 30)];
    self.inputBox.borderStyle = UITextBorderStyleRoundedRect;
    
    self.addfriendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.addfriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [self.addfriendBtn setFrame:CGRectMake(30, 100, 100, 40)];
    [self.addfriendBtn addTarget:self action:@selector(addfriendBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.inputBox];
    [self.view addSubview:self.addfriendBtn];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Method
- (void)addfriendBtnPressed
{
    self.friendsVC = [[SYSUFriendsViewController alloc] initWithFriendsList:friendsList];
    NSLog(@"%@", friendsList);
    [self presentModalViewController:self.friendsVC animated:YES];
}

@end
