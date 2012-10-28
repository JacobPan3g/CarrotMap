//
//  SYSUViewController.m
//  CarrotMap_demo_map
//
//  Created by 王 瑞 on 12-10-15.
//  Copyright (c) 2012年 王 瑞. All rights reserved.
//

#import "SYSUViewController.h"
#import "SYSUMyAnnotation.h"
#import "SYSUAddCorrotViewController.h"

@interface SYSUViewController ()

@end

@implementation SYSUViewController
@synthesize myMapView;
@synthesize myManager;
@synthesize myGeocoder;
@synthesize rightCornerView;
//@synthesize myTapGestureRecognizer;
@synthesize insertCarrot;
@synthesize tapToChangeMode;
@synthesize LocationTrackingView;
@synthesize leftCornerView;
@synthesize leftCornerLayer;
@synthesize leftCornerLongPress;
-(id)init{
    self=[super init];
    if (self) {
        
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
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //纯代码添加 mapview
    self.myMapView=[[MKMapView alloc] initWithFrame:self.view.bounds];
    self.myMapView.mapType=MKMapTypeStandard;
    self.myMapView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.myMapView.delegate=self;
    self.myMapView.userInteractionEnabled=YES;
    self.myMapView.showsUserLocation=YES;
    [self.myMapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES ];
    [self.view addSubview:myMapView];
    
    //设定地图起始的区域大小，和具体的地方。选定中国广州附近(由于使用了实时定位，这个以及没用了
    //CLLocationCoordinate2D coordinateForStartRegion=CLLocationCoordinate2DMake(23.0101, 113.3123);
    //self.myMapView.region=MKCoordinateRegionMakeWithDistance(coordinateForStartRegion, 10000, 10000);
    
    // 使用CLLocationManager 来使用定位功能
    if ([CLLocationManager locationServicesEnabled]) {
        myManager=[[CLLocationManager alloc] init];
        self.myManager.delegate=self;
        self.myManager.purpose=@"To provide functionality base on user's location.";
    
        
    //Location功能正式开启。其功能实现主要依靠于 location的8个协议方法，后面我只用了一个。
        [self.myManager startUpdatingLocation];
    }else{
        NSLog(@"Service are not available");
    }
    
    /* A Sample location*/
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(23.01, 113.33);
    
    CLLocation *GLocation=[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    //创建SYSUAnnotation, 这是我们自定义的Annotation
    SYSUMyAnnotation *annotation=[[SYSUMyAnnotation alloc] initWithCoordinate:location title:@"MyAnnotation" subtitle:@"SubTitle"];
    
    // 定义annotation的pin颜色属性为紫色（如果使用MKPinAnnotation的话，实际上下面的代码使用了MKAnnotation，用于我们自定义pin的图片）
    //    annotation.pinColor=MKPinAnnotationColorPurple;
    
    [self.myMapView addAnnotation:annotation];
    
    //获取具体地址，并赋值给我们的Pin
    self.myGeocoder=[[CLGeocoder alloc] init];
    [self.myGeocoder reverseGeocodeLocation:GLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error==nil&&[placemarks count]>0) {
            CLPlacemark *placemark=[placemarks objectAtIndex:0];
        //   NSLog(@"%@",placemark);
         //  NSLog(@"%@ : %@ : %@", placemark.subLocality,placemark.name, placemark.locality);
            annotation.title=placemark.name;
            annotation.subtitle=placemark.subLocality;
        } else if(error==nil&&[placemarks count]==0){
            NSLog(@"No Results returns");
        }else if (error!=nil){
            NSLog(@"Error=%@",error);
        }
    }];
    
    //添加了3击手势，并定义并发函数 handleTaps: .函数功能是获取点击处的CGPoint类型的图上坐标，然后用API转换成经纬度。再用此经纬度在地图上放置“萝卜”
/*
    self.myTapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
    self.myTapGestureRecognizer.numberOfTapsRequired=3;
    self.myTapGestureRecognizer.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:self.myTapGestureRecognizer];
 */

    //目的是放置一键插萝卜功能
    UIImage *rightCorner=[UIImage imageNamed:@"Icon.png"];
    rightCornerView=[[UIImageView alloc] initWithImage:rightCorner];
    self.rightCornerView.center=CGPointMake(290, 430);
    self.rightCornerView.userInteractionEnabled=YES;
    [self.view addSubview:self.rightCornerView];

    //定位图标，用来提供给用户，用以回到自己位置并开始实时定位
    UIImage *locationTracking=[UIImage  imageNamed:@"Icon.png"];
    LocationTrackingView=[[UIImageView alloc] initWithImage:locationTracking];
    self.LocationTrackingView.center=CGPointMake(230, 430);
    self.LocationTrackingView.userInteractionEnabled=YES;
    [self.view addSubview:self.LocationTrackingView];
    
    //寻找自己的位置并实时定位函数
    self.tapToChangeMode=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChangeMode:)];
    self.tapToChangeMode.numberOfTouchesRequired=1;
    self.tapToChangeMode.numberOfTapsRequired=1;
    self.tapToChangeMode.delegate=self;
    [self.LocationTrackingView addGestureRecognizer:tapToChangeMode];
    
    //插萝卜函数

    self.insertCarrot=[[UILongPressGestureRecognizer  alloc] initWithTarget:self action:@selector(PushCarrot:)];
    self.insertCarrot.minimumPressDuration=1.0f;
  //  self.insertCarrot.numberOfTapsRequired=1;
    self.insertCarrot.delegate=self;
    
    [self.rightCornerView addGestureRecognizer:self.insertCarrot];
    
    //拉兔兔喽

    self.leftCornerView=[[UIImageView alloc] init];
                         //WithImage:image];
    self.leftCornerView.userInteractionEnabled=YES;
    self.leftCornerView.frame=CGRectMake(0, 395, 64, 64);
    self.leftCornerView.center=CGPointMake(30, 430);
    [self.myMapView addSubview:leftCornerView];
    
    leftCornerLayer=[CALayer layer];
    leftCornerLayer.frame=leftCornerView.bounds;
    leftCornerLayer.contents=(id)[UIImage imageNamed:@"Icon.png"].CGImage;
    leftCornerLayer.cornerRadius=10.0f;
    
    [leftCornerView.layer addSublayer:leftCornerLayer];
    
    leftCornerLongPress=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    leftCornerLongPress.maximumNumberOfTouches=1;
    leftCornerLongPress.minimumNumberOfTouches=1;
    [self.leftCornerView addGestureRecognizer:leftCornerLongPress];

    
}

- (void)viewDidUnload
{
    self.leftCornerLongPress=nil;
    self.leftCornerLayer=nil;
   self.leftCornerView=nil;
     self.myMapView=nil;
     self.myManager=nil;
     self.myGeocoder=nil;
     self.myGeocoder=nil;
//   self.myTapGestureRecognizer=nil;
     self.insertCarrot=nil;
    self.tapToChangeMode=nil;
    self.LocationTrackingView=nil;
    [self.myManager stopUpdatingLocation];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CLLocation Delegate 

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //协议方法－－CClocation  一旦实施定位开启后，这个函数会在极短的时间内反复调用（即使你没有挪窝，这时两个位置参数的值一样）
//    NSLog(@"Latitude=%f, Longtitude=%f  ------",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
//    NSLog(@"Latitude=%f, Longtitude=%f   $$$$$$",oldLocation.coordinate.latitude,oldLocation.coordinate.longitude);
}

#pragma mark - MKMapView Delegate

-(void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated{
//    if (mode==MKUserTrackingModeNone) {
//       // NSLog(@"None!");
//        self.myMapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;
//    }
//    
//    if (mode==MKUserTrackingModeFollowWithHeading) {
//      //  NSLog(@"Heading!");
//         self.myMapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;
//    }
//    
//    if (mode==MKUserTrackingModeFollow) {
//       // NSLog(@"Follow");
//         self.myMapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;
//    }
    
}
#pragma mark - MKAnnotation Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
   
    /*
    MKAnnotationView *result=nil;
    if ([annotation isKindOfClass:[SYSUMyAnnotation class]]==NO) {
        return result;
    }
    
    if ([mapView isEqual:myMapView]==NO) {
        return result;
    }
    
    SYSUMyAnnotation *senderAnnotation=(SYSUMyAnnotation *)annotation;
    
    NSString *pinReusableIdentifier=[SYSUMyAnnotation reusableIdentifierForPinColor:senderAnnotation.pinColor];
    MKPinAnnotationView *annota=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    
    if (annota==nil) {
        annota=[[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableIdentifier];
        //[annota setCanShowCallout:YES];
    }
    
    
    
    //annota.pinColor=senderAnnotation.pinColor;
    // result=annota;
   
    
    UIImage *pinImage=[UIImage imageNamed:@"兔妹纸.png"];
    if (pinImage!=nil) {
        annota.image=pinImage;
    }
    result=annota;
    
    */
    
    //这个协议方法是由一个Annotation发起的，因此它需要创建一个MKAnnotationView，这个View会中被绘制在地图上并提供交互。IOS提供了一个定义好的（包括图片，颜色等属性）的MKAnnotation的子类，叫做MKPinAnnotation。你可以用它放置熟悉的大头针。
    MKAnnotationView *result=nil;
    if ([annotation isKindOfClass:[SYSUMyAnnotation class]]==NO) {
        return result;
    }
    
    if ([mapView isEqual:myMapView]==NO) {
        return result;
    }
    
    SYSUMyAnnotation *senderAnnotation=(SYSUMyAnnotation *)annotation;
    
    NSString *pinReusableIdentifier=[SYSUMyAnnotation reusableIdentifierForPinColor:senderAnnotation.pinColor];
    MKAnnotationView *annota=(MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    
    if (annota==nil) {
        annota=[[MKAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableIdentifier];
        [annota setCanShowCallout:YES];
       
    }
    
    
    /*
     annota.pinColor=senderAnnotation.pinColor;
     result=annota;
     */
    
    UIImage *pinImage=[UIImage imageNamed:@"Icon.png"];
    if (pinImage!=nil) {
        annota.image=pinImage;
    }
    result=annota;
    
    return result;
}

#pragma mark - GestureRecognizer HandleTaps

// 用来提供手工地图放置萝卜的函数
/*
-(void)handleTaps:(UITapGestureRecognizer *)parasender{
    
    CLLocationCoordinate2D coordinate=[self.myMapView convertPoint:[parasender locationInView:self.myMapView] toCoordinateFromView:self.myMapView];
    
//    NSLog(@"%f  :  %f ",coordinate.latitude,coordinate.longitude);
    SYSUMyAnnotation *annotation=[[SYSUMyAnnotation alloc] initWithCoordinate:coordinate title:@"MyAnnotation" subtitle:@"SubTitle"];
    [self.myMapView addAnnotation:annotation];
    
}
*/
//插萝卜函数
-(void)PushCarrot:(UILongPressGestureRecognizer  *)parasender{
   
    //不做下面的判断，函数会被激活两次。即：长按开始一次，结束（手指离开）一次
    if(parasender.state==UIGestureRecognizerStateBegan){
        MKUserLocation *usrLocation=self.myMapView.userLocation;
        CLLocation *location=usrLocation.location;
        CLLocationCoordinate2D location2D=CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        NSLog(@"%f : %f",location2D.latitude,location2D.longitude);
        SYSUMyAnnotation *tapAnnotation=[[SYSUMyAnnotation alloc] initWithCoordinate:location2D title:@"兔子军团" subtitle:@"萝卜世界"];
        [self.myMapView addAnnotation:tapAnnotation];
        
        /**JP CODE BY Jacob Pan **/
        SYSUAddCorrotViewController *addCorrotVC = [[SYSUAddCorrotViewController alloc] initWithUserInfo:self.userInfo withFriendsList:self.friends];
        [self presentModalViewController:addCorrotVC animated:YES];
        
        /**JP END CODE **/
}
    
//    if (parasender.state==UIGestureRecognizerStateEnded) {
//        CGMutablePathRef thePath=CGPathCreateMutable();
//        CGPathMoveToPoint(thePath, NULL, 16.0f, 16.0f);
//        CGPathAddLineToPoint(thePath, NULL, 16.0f, 160.0f);
//        
//        CAKeyframeAnimation *theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
//        
//        theAnimation.path=thePath;
//        CAAnimationGroup *theGroup=[CAAnimationGroup animation];
//        theGroup.animations=[NSArray arrayWithObject:theAnimation];
//        
//        theGroup.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        theGroup.duration=2.0;
//        
//        CFRelease(thePath);
//        [self.leftCornerTap.layer addAnimation:theGroup forKey:@"positon"];
//        
//    }


}
//实时定位函数
-(void)ChangeMode:(UITapGestureRecognizer *)parasender{
    if (parasender.state==UIGestureRecognizerStateEnded) {
        self.myMapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;
    }
    
}

//左边的兔子和列表
-(void)pan:(UIPanGestureRecognizer*)paramSender{
    
    
    
    if(paramSender.state==UIGestureRecognizerStateEnded) {
        
        if (paramSender.view.center.y==430) {
            
            
            CGMutablePathRef thePath=CGPathCreateMutable();
            CGPathMoveToPoint(thePath, NULL, 30.0f, 430.0f);
            CGPathAddLineToPoint(thePath, NULL, 30.0f, 160.0f);
            CGPathAddCurveToPoint(thePath, NULL, 30.0f, 145.0f, 30.0f, 170.0f, 30.0f, 154.0f);
            CGPathAddLineToPoint(thePath, NULL, 30.0f, 160.0f);
            CAKeyframeAnimation *theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
            
            
            theAnimation.path=thePath;
            CAAnimationGroup *theGroup=[CAAnimationGroup animation];
            theGroup.animations=[NSArray arrayWithObject:theAnimation];
            
            theGroup.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            theGroup.duration=0.2f;
            
            CFRelease(thePath);
            [self.leftCornerView.layer addAnimation:theGroup forKey:@"positon"];
            paramSender.view.center=CGPointMake(30.0f, 160.0f);
            
            
        }
        
        else if(paramSender.view.center.y==160){
            CGMutablePathRef thePath=CGPathCreateMutable();
            CGPathMoveToPoint(thePath, NULL, 30.0f, 160.0f);
            CGPathAddLineToPoint(thePath, NULL, 30.0f, 430.0f);
            CGPathAddCurveToPoint(thePath, NULL, 30.0f, 440.0f, 30.0f, 425.0f, 30.0f,432.0f);
            CGPathAddLineToPoint(thePath, NULL, 30.0f, 430.0f);
            CAKeyframeAnimation *theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
            
            theAnimation.path=thePath;
            CAAnimationGroup *theGroup=[CAAnimationGroup animation];
            theGroup.animations=[NSArray arrayWithObject:theAnimation];
            
            theGroup.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            theGroup.duration=0.2f;
            
            CFRelease(thePath);
            [self.leftCornerView.layer addAnimation:theGroup forKey:@"positon"];
            paramSender.view.center=CGPointMake(30.0f, 430.0f);
            
        }
    }
    
}


/**JP CODE BY Jacob Pan **/

- (void)viewDidAppear:(BOOL)animated
{
    //tmp
    /**JP CODE BY Jacob Pan **/
    //[[Renren sharedRenren] logout:self];
    
    self.renren = [Renren sharedRenren];
    if (![self.renren isSessionValid])
    {
        //[self.renren authorizationWithPermisson:nil andDelegate:self];
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.userInfo = [userDefaults objectForKey:@"userInfo"];
    }
    [self renrenDidLogin:self.renren];
}

#pragma mark - Renren Delegate

- (void)renrenDidLogin:(Renren *)renren
{
    NSLog(@"登录成功");

    //拉取自己的信息
    ROUserInfoRequestParam *requestParam = [[ROUserInfoRequestParam alloc] init];
	requestParam.fields = [NSString stringWithFormat:@"uid,name,tinyurl"];
	[self.renren getUsersInfo:requestParam andDelegate:self];
    
    //拉取好友信息
    ROGetFriendsInfoRequestParam *requestParam_ = [[ROGetFriendsInfoRequestParam alloc] init];
	requestParam_.count = @"";   //当count变量为@“”时，才会拉到全部好友
    requestParam_.fields = @"id,name,tinyurl";
	[self.renren getFriendsInfo:requestParam_ andDelegate:self];
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response
{
    NSLog(@"拉取好友成功");
    NSArray *responseArray = (NSArray *)(response.rootObject);
    NSLog(@"%d", [responseArray count]);
    
    //当 count＝1时，拉到的时用户的数据
    if ([responseArray count] == 1)
    {
        self.userInfo = [[responseArray objectAtIndex:0] responseDictionary];
        //把自己的信息存进UserDefaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.userInfo forKey:@"userInfo"];
    }
    else
    {
        self.friends = [[NSMutableArray alloc] init];
        for ( int i = 0; i < [responseArray count]; i++  )
        {
            [self.friends addObject:[[responseArray objectAtIndex:i] responseDictionary]];
        }
    }
    
    NSLog(@"%@", self.friends);
    
}

/**JP END CODE **/

@end
