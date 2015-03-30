//
//  RestaurantModel.m
//  WeHungry
//
//  Created by Max Campolo on 7/16/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import "RestaurantModel.h"

@implementation RestaurantModel

@synthesize restaurant_id;
@synthesize name;
@synthesize address;
@synthesize snippet_image_url;
@synthesize thumbURL;
@synthesize ratingURL;
@synthesize yelpURL;
@synthesize mobileURL;
@synthesize phone;
@synthesize city;
@synthesize display_address;

@synthesize coord;
@synthesize latitude;
@synthesize longitude;

@synthesize rating;
@synthesize review_count;
@synthesize is_closed;
@synthesize is_claimed;
@synthesize distance;

- (id) initWithRestaurant: (NSString*) theRestID andName: (NSString*) theName andAddress: (NSString*) theAddress andThumbURL:(NSString*)theThumbURL andRatingURL:(NSString*) theRatingURL andYelpURL:(NSString*) theYelpURL andMobileURL:(NSString*) theMobileURL andPhone:(NSString*) thePhone andCity:(NSString*)theCity andDisplayAddress:(NSString*)theDisplayAddress andCoordinate: (CLLocationCoordinate2D) theCoordinate andRating:(NSNumber*)theRatingNumber andReviewCount:(NSNumber*)theReviewCount andIsClosed:(NSString*)IsClosed andIsClaimed:(NSString*) IsClaimed  andDistance:(NSNumber*)theDistance
{
    self = [super init];
    if( self ){
        restaurant_id = theRestID;
        name = theName;
        address = theAddress;
        thumbURL = theThumbURL;
        ratingURL = theRatingURL;
        yelpURL = theYelpURL;
        mobileURL = theMobileURL;
        phone = thePhone;
        city = theCity;
        display_address = theDisplayAddress;
        
        coord = CLLocationCoordinate2DMake(theCoordinate.latitude, theCoordinate.longitude);
        
        rating = theRatingNumber;
        review_count = theReviewCount;
        is_closed = IsClosed;
        is_claimed = IsClaimed;
        distance = theDistance;
    }
    return self;
}


- (NSString*) description
{
    //    return [NSString stringWithFormat:@"%@ %@ %@ %d %g %g", city, region, country, [population integerValue], coord.latitude, coord.longitude];
    return 0;
}
//
//- (void) setCoord:(CLLocationCoordinate2D)aCoord{
//    self.coord = aCoord;
//}

- (NSString*) longitudeString{
    double theta = coord.longitude;
    double deg = floor(theta);
    double min = floor((theta - deg) * 60.0);
    double sec = floor((theta - deg - (min/60.0)) * 3600.0);
    return [NSString stringWithFormat: @"%g° %g' %g\"", deg, min, sec];
}

- (NSString*) latitudeString{
    double theta = coord.latitude;
    double deg = floor(theta);
    double min = floor((theta - deg) * 60.0);
    double sec = floor((theta - deg - (min/60.0)) * 3600.0);
    return [NSString stringWithFormat: @"%g° %g' %g\"", deg, min, sec];
}

- (NSComparisonResult)compareDistance:(RestaurantModel *)otherObject {
    return [self.distance compare:otherObject.distance];
}

- (NSComparisonResult)compareReviewCount:(RestaurantModel *)otherObject {
    return [self.review_count compare:otherObject.review_count];
}

@end
