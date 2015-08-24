//
//  ALMNetworkService.m
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 8/23/15.
//  Copyright (c) 2015 Weichuan Tian. All rights reserved.
//

#import "ALMNetworkService.h"

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

- (void)networkServiceRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters requestMethod:(ALMNetworkServiceRequestMethod)requestMethod respondKeyPath:(NSString *)respondKeyPath completion:(ALMNetworkServiceRequestCompletion)completion
{
    if ([[url absoluteString] length] == 0) {
        NSAssert(NO, @"%s -- Invalid base URL or path",__PRETTY_FUNCTION__);
        return;
    }

    // build request based on the http method
    NSMutableURLRequest *request = nil;

    if (requestMethod == ALMNetworkServiceRequestMethodGet) {

        // build the query string
        NSMutableString *queryString = [[NSMutableString alloc] initWithString:@""];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

            // for query string keys/values, encode all non-alphanumeric characters
            if (([key isKindOfClass:[NSNumber class]] || [key isKindOfClass:[NSString class]]) || ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])) {
                NSString *paramKey = [[NSString stringWithFormat:@"%@",key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
                NSString *paramValue = [[NSString stringWithFormat:@"%@",obj] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];

                [queryString appendFormat:@"%@=%@&", paramKey, paramValue];
            }
            else {
                NSAssert(NO, @"%s -- query string key/values can only be either NSString or NSNumber types",__PRETTY_FUNCTION__);
            }
        }];

        // create the request URL
        NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",[url absoluteString], queryString]];
        // create the request
        request = [NSMutableURLRequest requestWithURL:requestURL];
        request.HTTPMethod = @"GET";
    }
    else if (requestMethod == ALMNetworkServiceRequestMethodPost) {

        request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";

        // serialize the parameters as json binary data
        NSError *serializationError = nil;
        NSData *jsonBinaryData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&serializationError];
        request.HTTPBody = jsonBinaryData;
        if (serializationError) {
            NSAssert(NO, @"%s -- parameter serialization error",__PRETTY_FUNCTION__);
        }
    }
    else {
        NSAssert(NO, @"%s -- unsupported method", __PRETTY_FUNCTION__);
    }

    if (request) {

        // add headers
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        // Create a task.
        NSURLSessionDataTask *requestTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

            NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
            
            if (!error)
            {
                // only 200 is valid status code
                if (httpURLResponse.statusCode == 200) {

                    // deserialize the response into a json dictionary
                    NSError *deserializationError = nil;
                    NSDictionary *serverResponseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];

                    id serverData = serverResponseDict;

                    if ([respondKeyPath length]) {
                        @try {
                            serverData = [serverResponseDict valueForKeyPath:respondKeyPath];
                        }
                        @catch (NSException *exception) {
                            NSAssert(NO, @"%s -- unable to filter response data with key path %@", __PRETTY_FUNCTION__, respondKeyPath);
                            serverData = nil;
                        }
                        @finally {
                            
                        }
                    }

                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(serverData, nil);
                        });
                    }
                }
                else {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, error);
                        });
                    }
                }
                
            }
            else {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, error);
                    });
                }
            }
        }];

        [requestTask resume];
    }
    else {
        NSAssert(NO, @"%s -- no valid request", __PRETTY_FUNCTION__);
    }
}

@end
