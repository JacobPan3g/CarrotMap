//
//  SYSUMyAnnotation.h
//  CarrotMap_demo_map
//
//  Created by 王 瑞 on 12-10-15.
//  Copyright (c) 2012年 王 瑞. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

//系统提供了一个继承于AnnotationView的Pin(我们常见的大头针)，然后提供了3种可选颜色给我们，就是以下三种。（这个宏的作用已经没有了，因为在新版本代码里我们自定义了Pin）
#define REUSABLE_PIN_RED @"Red" 
#define REUSABLE_PIN_GREEN @"Green" 
#define REUSABLE_PIN_PURPLE @"Purple"


@interface SYSUMyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString * subtitle;
@property (nonatomic, unsafe_unretained)MKPinAnnotationColor pinColor;

//初始化我们的Annotation
-(id)initWithCoordinate:(CLLocationCoordinate2D)paramcoordinate title:(NSString *)paramtitle subtitle:(NSString *)paramsubtitle;

//使用系统提供的PinAnnotation时的遗留产物，现在还在用仅是为了获取一个 Identifier(字符串，red,green,purple）
+(NSString *)reusableIdentifierForPinColor:(MKPinAnnotationColor)paramColor;
@end
