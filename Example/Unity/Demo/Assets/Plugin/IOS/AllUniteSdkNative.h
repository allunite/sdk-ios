#ifdef __cplusplus
extern "C" {
#endif
    void AllUnite_enableDebugLog(void);
    
    BOOL AllUnite_isSdkEnabled(void);
    
    typedef void (*CALLBACK_RESULT)(int result);
    int   AllUnite_InitSDK(const char *accountId, const char *accountKey);
    int   AllUnite_InitSDK(const char *accountId, const char *accountKey);
    void  AllUnite_InitSDK_Async(const char *accountId, const char *accountKey, CALLBACK_RESULT callback);
    
    void AllUnite_Track(const char *actionCategory, const char *actionId);
    void AllUnite_TrackDeviceState();
    
    BOOL AllUnite_isBeaconTracking(void);
    int AllUnite_SendBeaconTrack(void);
    void AllUnite_StopBeaconTrack(void);
    
    BOOL AllUnite_isDeviceBounded(void);
    void AllUnite_BindDevice(void);
    void AllUnite_BindFbProfile(const char *profileToken, const char *profileData);
    
    BOOL AllUnite_isLocationAvailable(void);
    void AllUnite_RequestAlwaysAuthorization(CALLBACK_RESULT callback);
#ifdef __cplusplus
}
#endif
