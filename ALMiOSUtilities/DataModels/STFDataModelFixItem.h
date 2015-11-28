//
//  STFDataModelFixItem.h
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 11/27/15.
//  Copyright © 2015 Weichuan Tian. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface STFDataModelFixItem : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *itemID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *price;
@property (nonatomic, copy, readonly) NSString *brand;
@property (nonatomic, copy, readonly) NSURL *imageURL;

@end
