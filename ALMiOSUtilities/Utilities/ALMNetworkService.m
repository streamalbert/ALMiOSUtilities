//
//  ALMNetworkService.m
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 8/23/15.
//  Copyright (c) 2015 Weichuan Tian. All rights reserved.
//

#import "ALMNetworkService.h"
#import "ALMConstants.h"

@interface ALMNetworkService ()

@property (nonatomic) NSMutableDictionary *pendingRequests;

@end

@implementation ALMNetworkService

+ (ALMNetworkService *)sharedInstance
{
    static ALMNetworkService *_sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ALMNetworkService alloc] init];
    });
    return _sharedInstance;
}

- (void)requestWithURL:(NSURL *)url parameters:(ALMNetworkServiceParameters *)parameters method:(ALMNetworkServiceRequestMethod)method completion:(void(^)(id responseObject, NSError *error))completion
{
    NSAssert([[url absoluteString] length] > 0, @"Invalid url for network service!");
    if ([[url absoluteString] length] == 0) {
        return;
    }

    NSString *requestKey = [self requestKeyWithURL:url parameters:parameters method:method];
    if ([self.pendingRequests objectForKey:requestKey] != nil) {
        // Duplicate request
        return;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    switch (method) {
        case ALMNetworkServiceRequestMethodGet: {

            request.HTTPMethod = [self requestMethodStringWithMethod:ALMNetworkServiceRequestMethodGet];

            break;
        }
        case ALMNetworkServiceRequestMethodPost: {

            request.HTTPMethod = [self requestMethodStringWithMethod:ALMNetworkServiceRequestMethodPost];

            if ([parameters.httpBodyParameters count] > 0) {
                NSError *serializationError = nil;
                NSData *jsonBinaryData = [NSJSONSerialization dataWithJSONObject:parameters.httpBodyParameters options:0 error:&serializationError];
                request.HTTPBody = jsonBinaryData;
                if (serializationError) {
                    NSAssert(NO, @"Http body json serialization error!");
                }
            }
            break;
        }
        case ALMNetworkServiceRequestMethodPut: {

            request.HTTPMethod = [self requestMethodStringWithMethod:ALMNetworkServiceRequestMethodPut];

            if ([parameters.httpBodyParameters count] > 0) {
                NSError *serializationError = nil;
                NSData *jsonBinaryData = [NSJSONSerialization dataWithJSONObject:parameters.httpBodyParameters options:0 error:&serializationError];
                request.HTTPBody = jsonBinaryData;
                if (serializationError) {
                    NSAssert(NO, @"Http body json serialization error!");
                }
            }
            break;
        }
        default: {
            NSAssert(NO, @"Unsupported network service!");
            return;
            break;
        }
    }

    [self.pendingRequests setObject:request forKey:requestKey];

    NSMutableString *queryString = [[NSMutableString alloc] initWithString:@""];
    [parameters.urlParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])) {
            NSString *paramKey = [[NSString stringWithFormat:@"%@", key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
            NSString *paramValue = [[NSString stringWithFormat:@"%@", obj] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
            [queryString appendFormat:@"%@=%@&", paramKey, paramValue];
        }
        else {
            NSAssert(NO, @"Unsupported url query string format!");
        }
    }];

    // set url
    NSMutableString *requestURLString = [[NSMutableString alloc] initWithString:[url absoluteString]];
    if ([queryString length] > 0) {
        [requestURLString appendFormat:@"?%@", queryString];
    }
    [request setURL:[NSURL URLWithString:requestURLString]];

    // add headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [parameters.httpHeaderParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])) {
            [request setValue:obj forHTTPHeaderField:key];
        }
        else {
            NSAssert(NO, @"Http header unsupported format!");
        }
    }];

    __weak ALMNetworkService *weakSelf = self;
    NSURLSessionDataTask *requestTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        ALMNetworkService *strongSelf = weakSelf;
        if (strongSelf) {

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (!error) {
                if ([self isSuccessStatusCode:httpResponse.statusCode]) {
                    // deserialize the response into a json dictionary
                    NSError *deserializationError = nil;
                    id deserializedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
                    if (!deserializationError) {
                        [strongSelf.pendingRequests removeObjectForKey:requestKey];
                        if (completion) {
                            completion(deserializedData, nil);
                        }
                    }
                    else {
                        [strongSelf.pendingRequests removeObjectForKey:requestKey];
                        if (completion) {
                            completion(response, deserializationError);
                        }
                    }
                }
                else {
                    [strongSelf.pendingRequests removeObjectForKey:requestKey];
                    if (completion) {
                        completion(response, [NSError errorWithDomain:ALM_ERROR_DOMAIN code:ALMErrorDomainCodeUnsuccessfulHttpResponse userInfo:nil]);
                    }
                }
            }
            else {
                [strongSelf.pendingRequests removeObjectForKey:requestKey];
                if (completion) {
                    completion(response, error);
                }
            }
        }
    }];

    [requestTask resume];
}

- (NSMutableDictionary *)pendingRequests
{
    if (!_pendingRequests) {
        _pendingRequests = [[NSMutableDictionary alloc] init];
    }
    return _pendingRequests;
}

- (NSString *)requestKeyWithURL:(NSURL *)url parameters:(ALMNetworkServiceParameters *)parameters method:(ALMNetworkServiceRequestMethod)method
{
    return [NSString stringWithFormat:@"%@:%@%@", [self requestMethodStringWithMethod:method], [url absoluteString], [parameters description]];
}

- (NSString *)requestMethodStringWithMethod:(ALMNetworkServiceRequestMethod)method
{
    switch (method) {
        case ALMNetworkServiceRequestMethodGet: {
            return @"Get";
            break;
        }
        case ALMNetworkServiceRequestMethodPost: {
            return @"Post";
            break;
        }
        case ALMNetworkServiceRequestMethodPut: {
            return @"Put";
            break;
        }
        default: {
            NSAssert(NO, @"Unknown network service!");
            return @"Unknown";
            break;
        }
    }
}

- (BOOL)isSuccessStatusCode:(NSInteger)statusCode
{
    // Assume 2XX is success status code
    if (statusCode / 100 == 2) {
        return YES;
    }
    return NO;
}

@end

@interface ALMNetworkServiceParameters ()

@property (nonatomic, copy) NSDictionary *urlParameters;
@property (nonatomic, copy) NSDictionary *httpHeaderParameters;
@property (nonatomic, copy) NSDictionary *httpBodyParameters;

@end

@implementation ALMNetworkServiceParameters

- (instancetype)initWithURLParameters:(NSDictionary *)urlParameters
                 httpHeaderParameters:(NSDictionary *)headerParameters
                   httpBodyParameters:(NSDictionary *)bodyParameters
{
    if (self = [super init]) {
        self.urlParameters = urlParameters;
        self.httpHeaderParameters = headerParameters;
        self.httpBodyParameters = bodyParameters;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@%@%@", self.urlParameters, self.httpHeaderParameters, self.httpBodyParameters];
}

@end
