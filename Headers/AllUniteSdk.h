
#import <Foundation/Foundation.h>

#import "AllUniteSdkBeaconInfo.h"

@interface AllUniteSdk : NSObject

+ (BOOL) isSdkEnabled;
+ (void) setSdkEnabled: (BOOL) isSdkEnabled;

+ (BOOL) isLocationAvailable;

+ (BOOL) startBeaconTracking:(allunitesdk_beacon_block) findBeacon;

@end

#pragma mark SDK Api

#ifdef __cplusplus
extern "C" {
#endif
    BOOL AllUnite_isSdkEnabled();
    
    int  AllUnite_InitSDK(const char *accountId, const char *accountKey);
    void AllUnite_Track(const char *actionCategory, const char *actionId);
    
    BOOL AllUnite_isBeaconTracking();
    int AllUnite_SendBeaconTrack();
    void AllUnite_StopBeaconTrack();
    
    BOOL AllUnite_isDeviceBounded();
    void AllUnite_BindDevice();
    void AllUnite_BindFbProfile(const char *profileToken, const char *profileData);
    
    BOOL AllUnite_isLocationAvailable();
    void AllUnite_RequestAlwaysAuthorization();
#ifdef __cplusplus
}
#endif
