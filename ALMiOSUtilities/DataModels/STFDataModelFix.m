//
//  STFDataModelFix.m
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 11/27/15.
//  Copyright © 2015 Weichuan Tian. All rights reserved.
//

#import "STFDataModelFix.h"

@implementation STFDataModelFix

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"fixID" : @"id",
             @"shipmentFixItems" : @"shipment_items"
             };
}

+ (NSValueTransformer *)shipmentFixItemsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[STFDataModelFixItem class]];
}

- (BOOL)validate:(NSError *__autoreleasing *)error
{
    if (!self.fixID) {
        NSAssert(NO, @"ID is empty for fix!");
        return NO;
    }
    return YES;
}

@end
