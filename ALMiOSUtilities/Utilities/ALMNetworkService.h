//
//  ALMNetworkService.h
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 8/23/15.
//  Copyright (c) 2015 Weichuan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALMNetworkServiceParameters;

typedef NS_ENUM(NSInteger, ALMNetworkServiceRequestMethod) {
    ALMNetworkServiceRequestMethodGet,
    ALMNetworkServiceRequestMethodPost,
    ALMNetworkServiceRequestMethodPut
};

@interface ALMNetworkService : NSObject

+ (ALMNetworkService *)sharedInstance;

/**
 *  Make a http request with a completion handler. Underlying using NSURLSession
 *  which will fulfill the task in a background thread automatically. Completion
 *  will be called on the background thread.
 *
 *  @param url        The url of the request.
 *  @param parameters The parameters of the request. Can container URL query string, 
                      specific http headers, and http body.
 *  @param method     The http method for the request.
 *  @param completion Completion handler to be called when the request has returned.
                      2XX http status code is considered successful, and will return
                      the json serialized data, otherwise will return the NSURLResponse
                      with an appropriate error description.
 */
- (void)requestWithURL:(NSURL *)url
            parameters:(ALMNetworkServiceParameters *)parameters
                method:(ALMNetworkServiceRequestMethod)method
            completion:(void(^)(id responseObject, NSError *error))completion;

@end

@interface ALMNetworkServiceParameters : NSObject

@property (nonatomic, copy, readonly) NSDictionary *urlParameters;
@property (nonatomic, copy, readonly) NSDictionary *httpHeaderParameters;
@property (nonatomic, copy, readonly) NSDictionary *httpBodyParameters;

// Body parameters are ignored for Get method
- (instancetype)initWithURLParameters:(NSDictionary *)urlParameters
                 httpHeaderParameters:(NSDictionary *)headerParameters
                   httpBodyParameters:(NSDictionary *)bodyParameters;

@end
