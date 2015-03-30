//
//  RestaurantModel.h
//  WeHungry
//
//  Created by Max Campolo on 7/16/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RestaurantModel : NSObject

@property (nonatomic, strong) NSString *restaurant_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *snippet_image_url;
@property (nonatomic, strong) NSString *thumbURL;
@property (nonatomic, strong) NSString *ratingURL;
@property (nonatomic, strong) NSString *yelpURL;
@property (nonatomic, strong) NSString *mobileURL;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *display_address;

@property (readonly) CLLocationCoordinate2D coord;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *review_count;
@property (nonatomic, strong) NSString *is_closed;
@property (nonatomic, strong) NSString *is_claimed;
@property (nonatomic, strong) NSNumber *distance;

//- (void) setCoord:(CLLocationCoordinate2D)aCoord;

- (id) initWithRestaurant: (NSString*) theRestID andName: (NSString*) theName andAddress: (NSString*) theAddress andThumbURL:(NSString*)theThumbURL andRatingURL:(NSString*) theRatingURL andYelpURL:(NSString*) theYelpURL andMobileURL:(NSString*) theMobileURL andPhone:(NSString*) thePhone andCity:(NSString*)theCity andDisplayAddress:(NSString*)theDisplayAddress andCoordinate: (CLLocationCoordinate2D) theCoordinate andRating:(NSNumber*)theNumber andReviewCount:(NSNumber*)theReviewCount andIsClosed:(NSString*)IsClosed andIsClaimed:(NSString*)IsClaimed andDistance:(NSNumber*)theDistance;

//- (id) initWithStop:(NSString*) theRouteID andStopID: (NSString*) theStopID  andStopName: (NSString*) theStopName andCoordinate: (CLLocationCoordinate2D) theCoordinate andZoneID: (NSString*) theZoneID andStopUrl: (NSString*) theStopUrl;

- (NSString*) description;
- (NSString*) longitudeString;
- (NSString*) latitudeString;

//"review_count":340,
//    "is_closed":false,
//    "is_claimed":true,
//    "rating":4.5
//    "url":"http:\/\/www.yelp.com\/biz\/o-ya-boston",
//    "id":"o-ya-boston",
//    "image_url":"http:\/\/s3-media3.ak.yelpcdn.com\/bphoto\/pyRoQtCY4ou8_VvSikmidw\/ms.jpg",


@end

//{
//    "rating_img_url_large":"http:\/\/s3-media4.ak.yelpcdn.com\/assets\/2\/www\/img\/9f83790ff7f6\/ico\/stars\/v1\/stars_large_4_half.png",
//    "snippet_text":"Last night got off to a somewhat inauspicious start. As usual, I was dependent on my GPS to get us to our destination for the evening. Also as usual, I also...",
//    "phone":"6176549900",
//    "menu_date_updated":1383451144,
//    "rating_img_url":"http:\/\/s3-media2.ak.yelpcdn.com\/assets\/2\/www\/img\/99493c12711e\/ico\/stars\/v1\/stars_4_half.png",
//    "location":{
//        "neighborhoods":[
//                         "Waterfront",
//                         "Leather District",
//                         "South Boston"
//                         ],
//        "state_code":"MA",
//        "display_address":[
//                           "9 East St",
//                           "Waterfront",
//                           "Boston, MA 02111"
//                           ],
//        "address":[
//                   "9 East St"
//                   ],
//        "country_code":"US",
//        "postal_code":"02111",
//        "city":"Boston"
//    },
//    "menu_provider":"single_platform",
//    "review_count":340,
//    "is_closed":false,
//    "is_claimed":true,
//    "rating_img_url_small":"http:\/\/s3-media2.ak.yelpcdn.com\/assets\/2\/www\/img\/a5221e66bc70\/ico\/stars\/v1\/stars_small_4_half.png",
//    "url":"http:\/\/www.yelp.com\/biz\/o-ya-boston",
//    "id":"o-ya-boston",
//    "image_url":"http:\/\/s3-media3.ak.yelpcdn.com\/bphoto\/pyRoQtCY4ou8_VvSikmidw\/ms.jpg",
//    "name":"O Ya",
//    "display_phone":"+1-617-654-9900",
//    "snippet_image_url":"http:\/\/s3-media4.ak.yelpcdn.com\/photo\/QLLDC2CmRvTvFjullAC7tg\/ms.jpg",
//    "mobile_url":"http:\/\/m.yelp.com\/biz\/o-ya-boston",
//    "categories":[
//                  [
//                   "Japanese",
//                   "japanese"
//                   ]
//                  ],
//    "rating":4.5
//}
