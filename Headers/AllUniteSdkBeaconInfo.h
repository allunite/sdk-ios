//
//  AllUniteSdkBeaconInfo.h
//  AllUniteSdk
//
//  Created by Yury on 05.07.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AllUniteSdkBeaconInfo : NSObject

@property (copy, nonatomic, nullable) NSString* beaconID;
@property (copy, nonatomic, nullable) NSString* name;

@property (copy, nonatomic, nullable) NSString* major;
@property (copy, nonatomic, nullable) NSString* minor;

@end

typedef void (^allunitesdk_beacon_block)(AllUniteSdkBeaconInfo* _Nonnull);
