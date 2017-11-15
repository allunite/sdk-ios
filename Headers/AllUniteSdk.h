
#import <Foundation/Foundation.h>

#import "AllUniteSdkBeaconInfo.h"

@interface AllUniteSdk : NSObject

+ (BOOL) isSdkEnabled;
+ (void) setSdkEnabled: (BOOL) isSdkEnabled;

+ (BOOL) isLocationAvailable;

+ (BOOL) startBeaconTracking:(allunitesdk_beacon_block) findBeacon;

+ (void) trackLocationServicePermission: (NSString*) actionId
                             completion: (void (^)(NSError*)) completion;

@end

#pragma mark SDK Api

#ifdef __cplusplus
extern "C" {
#endif
    BOOL AllUnite_isSdkEnabled(void);
    
    int  AllUnite_InitSDK(const char *accountId, const char *accountKey);
    void AllUnite_Track(const char *actionCategory, const char *actionId);
    
    BOOL AllUnite_isBeaconTracking(void);
    int AllUnite_SendBeaconTrack(void);
    void AllUnite_StopBeaconTrack(void);
    
    BOOL AllUnite_isDeviceBounded(void);
    void AllUnite_BindDevice(void);
    void AllUnite_BindFbProfile(const char *profileToken, const char *profileData);
    
    BOOL AllUnite_isLocationAvailable(void);
    void AllUnite_RequestAlwaysAuthorization(void);
#ifdef __cplusplus
}
#endif
