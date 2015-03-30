//
//  PAWConstants.h
//  Anywall
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#ifndef Anywall_PAWConstants_h
#define Anywall_PAWConstants_h

static int HOLAUserDefaultSort(){
    return 0;
}

static int HOLAUserDefaultcategory(){
    return 1;
}

static int HOLAUserDefaultDistance(){
    return 1;
}

static double PAWFeetToMeters(double feet) {
    return feet * 0.3048;
}

static double PAWMetersToFeet(double meters) {
    return meters * 3.281;
}

static double PAWMetersToKilometers(double meters) {
    return meters / 1000.0;
}

static double const PAWDefaultFilterDistance = 1000.0;
static double const PAWWallPostMaximumSearchDistance = 100.0; // Value in kilometers

static NSUInteger const PAWWallPostsSearchDefaultLimit = 20; // Query limit for pins and tableviewcells

// Parse API key constants:
static NSString * const PAWParsePostsClassName = @"Posts";
static NSString * const PAWParsePostUserKey = @"user";
static NSString * const PAWParsePostUsernameKey = @"username";
static NSString * const PAWParsePostTextKey = @"text";
static NSString * const PAWParsePostLocationKey = @"location";
static NSString * const PAWParsePostNameKey = @"name";

// NSNotification userInfo keys:
static NSString * const kPAWFilterDistanceKey = @"userCategory";
static NSString * const kPAWLocationKey = @"location";

// Notification names:
static NSString * const PAWFilterDistanceDidChangeNotification = @"PAWFilterDistanceDidChangeNotification";
static NSString * const PAWCurrentLocationDidChangeNotification = @"PAWCurrentLocationDidChangeNotification";
static NSString * const PAWPostCreatedNotification = @"PAWPostCreatedNotification";

// UI strings:
static NSString * const kPAWWallCantViewPost = @"Can’t view post! Get closer.";

// NSUserDefaults
//static NSString * const PAWUserDefaultsFilterDistanceKey = @"filterDistance";
static NSString * const HOLAUserDefaultCategoryKey = @"userCategory";
static NSString * const HOLAUserDefaultDistanceKey = @"userDistance";
static NSString * const HOLAUserDefaultSortKey = @"userSort";

typedef double PAWLocationAccuracy;

#endif // Anywall_PAWConstants_h
