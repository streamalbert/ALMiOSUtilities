//
//  ALMConstants.h
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 11/27/15.
//  Copyright © 2015 Weichuan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BUNDLE_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define ALM_ERROR_DOMAIN [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

typedef NS_ENUM(NSInteger, ALMErrorDomainCode) {
    ALMErrorDomainCodeUnknown = 100,
    ALMErrorDomainCodeUnsuccessfulHttpResponse = 101
};