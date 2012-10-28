//
//  SYSUMyAnnotation.m
//  CarrotMap_demo_map
//
//  Created by 王 瑞 on 12-10-15.
//  Copyright (c) 2012年 王 瑞. All rights reserved.
//

#import "SYSUMyAnnotation.h"

@implementation SYSUMyAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize pinColor;

- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}
-(id)initWithCoordinate:(CLLocationCoordinate2D)paramcoordinate title:(NSString *)paramtitle subtitle:(NSString *)paramsubtitle
{
    
    self=[super init];
    if (self!=nil) {
        self.coordinate=paramcoordinate;
        title=paramtitle;
        subtitle=paramsubtitle;
        pinColor=MKPinAnnotationColorGreen;
       
    }
    return  self;
}
+(NSString *)reusableIdentifierForPinColor:(MKPinAnnotationColor)paramColor{
    NSString *result=nil;
    
    switch (paramColor) {
        case MKPinAnnotationColorRed:
            result=REUSABLE_PIN_RED;
            break;
        case MKPinAnnotationColorGreen:
            result=REUSABLE_PIN_GREEN;
            break;
        case MKPinAnnotationColorPurple:
            result=REUSABLE_PIN_PURPLE;
            break;
    }
    return result;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
