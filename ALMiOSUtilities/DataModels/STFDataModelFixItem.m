//
//  STFDataModelFixItem.m
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 11/27/15.
//  Copyright © 2015 Weichuan Tian. All rights reserved.
//

#import "STFDataModelFixItem.h"

@implementation STFDataModelFixItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"itemID" : @"id",
             @"name" : @"name",
             @"price" : @"price",
             @"brand" : @"brand",
             @"imageURL" : @"image_url"
             };
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (BOOL)validate:(NSError *__autoreleasing *)error
{
    if (!self.itemID) {
        NSAssert(NO, @"ID is empty for fix item!");
        return NO;
    }
    return YES;
}

@end
