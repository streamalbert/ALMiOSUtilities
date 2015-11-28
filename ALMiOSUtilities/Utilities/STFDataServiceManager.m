//
//  STFDataServiceManager.m
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 11/27/15.
//  Copyright © 2015 Weichuan Tian. All rights reserved.
//

#import "STFDataServiceManager.h"
#import "ALMNetworkService.h"
#import "STFConstants.h"
#import "STFDataModelFix.h"

#import <Mantle/Mantle.h>

@interface STFDataServiceManager ()

@property (nonatomic) NSURL *baseServiceURL;

@end

@implementation STFDataServiceManager

+ (STFDataServiceManager *)sharedManager
{
    static STFDataServiceManager *sharedManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[STFDataServiceManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.baseServiceURL = [NSURL URLWithString:STFDataServiceURLString];
    }
    return self;
}

- (void)fetchCurrentFixWithCompletion:(void(^)(STFDataModelFix *currentFix, NSError *error))completion
{
    NSString *serviceURLString = [NSString stringWithFormat:@"%@%@", [self.baseServiceURL absoluteString], STFDataServiceCurrentFixSubpath];
    NSURL *serviceURL = [NSURL URLWithString:serviceURLString];

    __weak STFDataServiceManager *weakSelf = self;
    [[ALMNetworkService sharedInstance] requestWithURL:serviceURL parameters:nil method:ALMNetworkServiceRequestMethodGet completion:^(id responseObject, NSError *error) {
        // called back in background thread

        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSError *jsonParsingError = nil;
                NSDictionary *responseDict = (NSDictionary *)responseObject;
                STFDataModelFix *parsedFix = [MTLJSONAdapter modelOfClass:[STFDataModelFix class] fromJSONDictionary:responseDict error:&jsonParsingError];

                STFDataServiceManager *strongSelf = weakSelf;
                if (!jsonParsingError && strongSelf) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(parsedFix, nil);
                        });
                    }
                }
                else {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, jsonParsingError);
                        });
                    }
                }
            }
            else {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [NSError errorWithDomain:STF_ERROR_DOMAIN code:STFErrorDomainCodeUnexpectedServerResponseFormat userInfo:nil]);
                    });
                }
            }
        }//error
        else {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
            }
        }
    }];
}

@end
