//
//  ALMNetworkService.h
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 8/23/15.
//  Copyright (c) 2015 Weichuan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ALMNetworkServiceRequestMethod) {
    ALMNetworkServiceRequestMethodGet,
    ALMNetworkServiceRequestMethodPost
};

typedef void(^ALMNetworkServiceRequestCompletion)(id respondObject, NSError *error);

@interface ALMNetworkService : NSObject

+ (ALMNetworkService *)sharedInstance;

//- (void)networkServiceRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(ALMNetworkServiceRequestMethod)requestMethod respondKeyPath:(NSString *)respondKeyPath completion:(void(^)(id respondObject, NSError *error))completion;

- (void)networkServiceRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(ALMNetworkServiceRequestMethod)requestMethod respondKeyPath:(NSString *)respondKeyPath completion:(ALMNetworkServiceRequestCompletion)completion;

@end
