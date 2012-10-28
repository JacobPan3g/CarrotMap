//
//  SYSUViewController.h
//  CarrotMap_demo_map
//
//  Created by 王 瑞 on 12-10-15.
//  Copyright (c) 2012年 王 瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
@interface SYSUViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation,UIGestureRecognizerDelegate, RenrenDelegate>

@property (nonatomic, strong) MKMapView *myMapView;
@property (nonatomic, strong) CLLocationManager* myManager;
@property (nonatomic, strong) CLGeocoder *myGeocoder;
@property (nonatomic, strong) UIImageView *rightCornerView;
@property (nonatomic, strong) UIImageView *LocationTrackingView;
//@property (nonatomic, strong) UITapGestureRecognizer *myTapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *insertCarrot;
@property (nonatomic, strong) UITapGestureRecognizer *tapToChangeMode;
@property (nonatomic, strong)UIImageView *leftCornerView;
@property (nonatomic,strong)CALayer *leftCornerLayer;
@property (nonatomic,strong) UIPanGestureRecognizer *leftCornerLongPress;

/**JP CODE BY Jacob Pan **/
@property (nonatomic, strong) Renren *renren;

/** 
 用户和用户好友的信息都是以Dictionary的形式储存起来
 Dictionary说明：
    KET     描述
 ---------------------
    uid     用户ID
    name    用户姓名
    tinyurl 用户头像
 **/
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSMutableArray *friends;

/**JP END CODE **/

@end
