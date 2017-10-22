
#import <Foundation/Foundation.h>

#import "AllUniteSdkBeaconInfo.h"
#import <CoreLocation/CoreLocation.h>


typedef void (^allunitesdk_fetch_completion_block)(void);
typedef void (^allunitesdk_completion_block)(NSError* _Nullable);

typedef void (^allunitesdk_update_authorization_status_block)(CLAuthorizationStatus status);

typedef NS_ENUM(NSUInteger, AllUniteSdkAuthorizationAlgorithm) {
    always = 1,
    customAlwaysTwoDialog = 500,
};

@interface AllUniteSdkManager : NSObject

-(void) initializeAllUniteSdkWithAccountId:(NSString* _Nonnull) accountId
                                accountKey:(NSString* _Nonnull) accountKey
                             launchOptions:(NSDictionary * _Nullable) launchOptions;

+(AllUniteSdkManager* _Nonnull) sharedInstance;

+(NSError* _Nullable)  errorWithReason: (NSString* _Nonnull) errorMsg;
+(NSString* _Nullable) errorGetReasonMessage: (NSError* _Nonnull) error;

-(BOOL) isSdkEnabled;
-(void) setSdkEnabled: (BOOL) isEnabled;

-(BOOL) isLocationAvailable;

-(void) requestAutorizationStatusAlways;
-(void) requestAutorizationStatus: (AllUniteSdkAuthorizationAlgorithm) algorithm
                          handler: (allunitesdk_update_authorization_status_block _Nonnull) changeHandler;

-(void) backgroundFetch: (allunitesdk_fetch_completion_block _Nonnull) fetchCompleted;

-(BOOL) openUrl:(NSURL * _Nullable)url
        options:(NSDictionary * _Nullable)options;

-(void) initilize: (allunitesdk_completion_block _Nonnull) completion; // if already initilized no action
-(void) reinitilize: (allunitesdk_completion_block _Nonnull) completion; // reload data from server

-(BOOL) isDeviceBounded;
-(void) bindDevice: (allunitesdk_completion_block _Nonnull) completion;
-(void) bindFacebook: (NSString* _Nonnull) profileToken
         profileJson: (NSString* _Nonnull) profileJson
          completion: (allunitesdk_completion_block _Nonnull) completion;
-(void) trackWithCategory: (NSString* _Nonnull) actionCategory
                 actionId: (NSString* _Nonnull) actionId
               completion: (allunitesdk_completion_block _Nonnull) completion;

-(BOOL) isTrackingBeacons;
-(void) startTrackingBeacon: (allunitesdk_completion_block _Nonnull) completion didFindBeacon:(allunitesdk_beacon_block _Nullable) findBeacon;
-(void) stopTrackingBeacon;

@end
