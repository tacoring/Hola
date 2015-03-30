//
//  YelpAPIService.m
//  WeHungry
//
//  Created by Max Campolo on 7/16/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import "YelpAPIService.h"
#import "OAuthAPIConstants.h"
#import "RestaurantModel.h"

#define SEARCH_RESULT_LIMIT 50

@implementation YelpAPIService

#pragma mark Yelp API Helpers

-(void)searchNearByRestaurantsByFilter:(NSString *)categoryFilter atLatitude:(CLLocationDegrees)latitude
                          andLongitude:(CLLocationDegrees)longitude {
    NSString* urlString;
    if (categoryFilter != nil) {
        urlString = [NSString stringWithFormat:@"%@?term=%@&category_filter=%@&ll=%f,%f",
                               YELP_SEARCH_URL,
                               @"restaurants",
                               categoryFilter,
                               latitude, longitude];
    } else {
        urlString = [NSString stringWithFormat:@"%@?term=%@&ll=%f,%f",
                    YELP_SEARCH_URL,
                    @"restaurants",
                    latitude, longitude];

    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
                                                    secret:OAUTH_CONSUMER_SECRET];
    
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN
                                           secret:OAUTH_TOKEN_SECRET];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    
    [request prepare];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        self.urlRespondData = [NSMutableData data];
    }
}

- (void)searchNearByRestaurantsByFilter:(NSString *)categoryFilter andRadiusFilter:(NSString *)radiusFilter atLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    int radiusInt = [radiusFilter intValue] * 1609;
    NSString *urlString = [NSString stringWithFormat:@"%@?term=%@&category_filter=%@&radius_filter=%i&ll=%f,%f", YELP_SEARCH_URL, @"restaurants",categoryFilter, radiusInt, latitude,longitude];
    NSURL *URL = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY
                                                    secret:OAUTH_CONSUMER_SECRET];
    
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN
                                           secret:OAUTH_TOKEN_SECRET];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    
    [request prepare];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) {
        self.urlRespondData = [NSMutableData data];
    }
    
}

#pragma mark Connection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.urlRespondData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.urlRespondData appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Failed to connect to speech server"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSError *e = nil;
    
    NSDictionary *resultResponseDict = [NSJSONSerialization JSONObjectWithData:self.urlRespondData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&e];
    if (self.resultArray && [self.resultArray count] > 0) {
        [self.resultArray removeAllObjects];
    }
    
    if (!self.resultArray) {
        self.resultArray = [[NSMutableArray alloc] init];
    }
    
    if (resultResponseDict && [resultResponseDict count] > 0) {
        if ([resultResponseDict objectForKey:@"businesses"] &&
            [[resultResponseDict objectForKey:@"businesses"] count] > 0) {
            for (NSDictionary *restaurantDict in [resultResponseDict objectForKey:@"businesses"]) {
//                RestaurantModel *restaurantObj = [[RestaurantModel alloc] init];
                double longitude, latitude;
                longitude = [[[[restaurantDict objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"longitude"] doubleValue];
                latitude = [[[[restaurantDict objectForKey:@"location"] objectForKey:@"coordinate"] objectForKey:@"latitude"] doubleValue];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
                RestaurantModel *restaurantObj = [[RestaurantModel alloc]
                        initWithRestaurant:[restaurantDict objectForKey:@"id"]
                        andName:[restaurantDict objectForKey:@"name"]
                        andAddress:[[[restaurantDict objectForKey:@"location"] objectForKey:@"address"] componentsJoinedByString:@", "]
                        andThumbURL:[restaurantDict objectForKey:@"image_url"]
                        andRatingURL:[restaurantDict objectForKey:@"rating_img_url"]
                        andYelpURL:[restaurantDict objectForKey:@"url"]
                        andMobileURL:[restaurantDict objectForKey:@"mobile_url"]
                        andPhone:[restaurantDict objectForKey:@"phone"]
                        andCity:@""
                        andDisplayAddress:@""
                        andCoordinate:coord
                        andRating:[restaurantDict objectForKey:@"rating"]
                        andReviewCount:[restaurantDict objectForKey:@"review_count"]
                        andIsClosed:[restaurantDict objectForKey:@"is_closed"]
                        andIsClaimed:[restaurantDict objectForKey:@"is_claimed"]
                        andDistance:[restaurantDict objectForKey:@"distance"]];

                [self.resultArray addObject:restaurantObj];
            }
        }
    }
    
    [self.delegate loadResultWithDataArray:self.resultArray];
}



@end
