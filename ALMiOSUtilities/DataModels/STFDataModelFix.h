//
//  STFDataModelFix.h
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 11/27/15.
//  Copyright © 2015 Weichuan Tian. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "STFDataModelFixItem.h"

@interface STFDataModelFix : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *fixID;
@property (nonatomic, copy, readonly) NSArray *shipmentFixItems;//array of STFDataModelFixItem

@end
