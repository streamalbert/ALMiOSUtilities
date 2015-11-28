//
//  STFDataServiceManager.h
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 11/27/15.
//  Copyright © 2015 Weichuan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STFDataModelFix;

@interface STFDataServiceManager : NSObject

+ (STFDataServiceManager *)sharedManager;

- (void)fetchCurrentFixWithCompletion:(void(^)(STFDataModelFix *currentFix, NSError *error))completion;

@end
