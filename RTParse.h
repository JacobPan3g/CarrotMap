//
//  RTParse.h
//  RTParsedemo
//
//  Created by 04 developer on 12-10-20.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface RTParse : NSObject

-(void)signUp:(NSString *)username password:(NSString*)psw email:(NSString *)email;

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error;

-(void)logIn:(NSString *)username password:(NSString *)psw;

-(void)Uplode:(NSString *)object isPublic:(BOOL)isPublic msg:(NSArray *)msg loc:(float)loc Author:(NSString *)author;

-(NSArray *)PublicMsg:(float)loc;
-(NSArray *)MsgForMe:(NSString *)userId;

@end
