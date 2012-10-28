//
//  RTParse.m
//  RTParsedemo
//
//  Created by 04 developer on 12-10-20.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "RTParse.h"

@implementation RTParse


/**
 *@name:signuUp
 *@param:username,password,email
 *@return:error msg
 **/

-(void)signUp:(NSString *)username password:(NSString*)psw email:(NSString *)email
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = psw;
    user.email = email;
    [user signUpInBackgroundWithTarget:self
                              selector:@selector(handleSignUp:error:)];
}
- (void)handleSignUp:(NSNumber *)result error:(NSError *)error {
    if (!error) {
        // Hooray! Let them use the app now. 
        NSLog(@"Hooray");
    } else {
    NSString *errorString =[[error userInfo] objectForKey:@"error"];
        // Show the errorString somewhere and let the user try again.
        NSLog(@"%@",errorString);
    }
}

/**
 *@name:logIn
 *@param:username,password
 **/
-(void)logIn:(NSString *)username password:(NSString *)psw
{
    [PFUser logInWithUsernameInBackground:username password:psw
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                        } else {
                                            NSLog(@"%@",error);
                                        }
                                    }];
}

/**
 *@name:Uplode Message
 *@param:to(number),isPublic(bool),msg(string)
 *@return:error
 **/
-(void)Uplode:(NSString *)to isPublic:(BOOL)isPublic msg:(NSArray *)msg loc:(float)loc Author:(NSString *)author
{
  
    
    if(!isPublic)
    {
        PFObject *My = [PFObject objectWithClassName:to];
        [My setObject:[NSArray arrayWithArray:msg] forKey:@"msg"];
        [My setObject:@"private" forKey:@"private"];
        [My saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // 成功
                NSLog(@"success");
            } else {
                // 失敗
                NSLog(@"Error: %@", error);
            }
        }];
    }
    else
    {
        PFObject *My = [PFObject objectWithClassName:@"Public"];
        [My setObject:[NSNumber numberWithFloat:loc] forKey:@"loc"];
        [My setObject:[NSArray arrayWithArray:msg] forKey:@"msg"];
        [My setObject:[NSString stringWithString:author] forKey:@"author"];
        [My saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // 成功
                NSLog(@"success");
            } else {
                // 失敗
                NSLog(@"fail");
            }
        }];
    }
}

/**
 *查看有谁给我发信息
 *@name:MsgForMe
 *@return:location(float),date,msg(string),author
 **/
-(NSArray *)MsgForMe:(NSString *)userId
{
    PFQuery *query = [PFQuery queryWithClassName:userId];
    [query whereKey:@"private" equalTo:@"private"];
    NSArray *msgs = [query findObjects];
    for (int i=0; i<[msgs count]; i++) {
        [[msgs objectAtIndex:i] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Records deleted!");
            }
        }];
    }
    return msgs;
}

/**
 *定时上传坐标，查看msg
 *@name:PublicMsg
 *@param:location
 *@return:date,msg(string),author
 **/
-(NSArray *)PublicMsg:(float)loc
{
    NSArray *msgs;
    PFQuery *query = [PFQuery queryWithClassName:@"Public"];
    [query whereKey:@"loc" equalTo:[NSNumber numberWithFloat:loc]];
    msgs = [query findObjects];
    return msgs;
}
@end
