using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using AOT;
using NotificationServices = UnityEngine.iOS.NotificationServices;
using NotificationType = UnityEngine.iOS.NotificationType;
using Device = UnityEngine.iOS.Device;

public class AlluniteSdk : MonoBehaviour {

	#if UNITY_IPHONE

	[DllImport("__Internal")]
	public static extern int AllUnite_enableDebugLog();

	[DllImport("__Internal")]
	public static extern int AllUnite_InitSDK(string accountId, string accountKey);
	[DllImport("__Internal")]
	private static extern void AllUnite_InitSDK_Async(string accountId, string accountKey, Callback callback);
	[DllImport("__Internal")]
	public static extern void AllUnite_Track(string actionCategory, string actionId);
	[DllImport("__Internal")]
	public static extern void AllUnite_TrackDeviceState();
		
	[DllImport("__Internal")]
	public static extern bool AllUnite_isBeaconTracking();
	[DllImport("__Internal")]
	public static extern void AllUnite_SendBeaconTrack();
	[DllImport("__Internal")]
	public static extern void AllUnite_StopBeaconTrack();

	[DllImport("__Internal")]
	public static extern bool AllUnite_isDeviceBounded();
	[DllImport("__Internal")]
	public static extern void AllUnite_BindDevice();
	[DllImport("__Internal")]
	public static extern void AllUnite_BindFbProfile(string profileToken, string profileData);
	[DllImport("__Internal")]
	public static extern void AllUnite_RequestAlwaysAuthorization();


	public delegate void Callback(int error);

	#endif

	private static string YOUR_ACCOUNT_ID = "UnityDemo";
	private static string YOUR_ACCOUNT_KEY = "2414863EEE4C41EAAE505983A9F2CD23";

	public void onClickInitSdk(){

		AllUnite_enableDebugLog();

		int res = AllUnite_InitSDK (YOUR_ACCOUNT_ID, YOUR_ACCOUNT_KEY);
		if (res == 0) {
			print ("Init SDK. Success");
		} else {
			print ("Init SDK. Failed network request");
		}
	}

	public void onClickInitSdkAsync(){
		Debug.Log("AllUnite_InitSDK_Async");

		AllUnite_enableDebugLog();

		AllUnite_InitSDK_Async (YOUR_ACCOUNT_ID, YOUR_ACCOUNT_KEY, asyncInitResult);
	}

	[MonoPInvokeCallback(typeof(Callback))]
	private static void asyncInitResult(int res) {
		Debug.Log("Init result: " + res);
		if (res == 0) {
			Debug.Log ("Init SDK. Success");
		} else {
			Debug.Log ("Init SDK. Failed network request");
		}
	}

	public void onClickRequestAutorizationStatus() {
		AllUnite_RequestAlwaysAuthorization();
	}

	public void onClickBindDevice(){
		AllUnite_enableDebugLog();
		if (!AllUnite_isDeviceBounded ()) {
			Debug.Log("AllUnite_BindDevice");
			AllUnite_BindDevice ();
		} else {
			Debug.Log ("Device already bounded");
		}
	}

	public void onClickTrack(){
		Debug.Log("AllUnite_Track");

		string actionCategory = "track";
		string actionId = "test";

		AllUnite_Track (actionCategory, actionId);
	}

	public void onClickStartTrack(){
		
		if (!AllUnite_isBeaconTracking ()) {
			Debug.Log("AllUnite_SendBeaconTrack");
			AllUnite_SendBeaconTrack ();
		} else {
			Debug.Log("Device already tracking beacon");
		}
	}

	public void onClickStopTrack(){
		Debug.Log("AllUnite_StopBeaconTrack");
		AllUnite_StopBeaconTrack();
	}

	public void onClickBindFbProfile(){
		Debug.Log("AllUnite_StopBeaconTrack");
		string profileToken = "ADlwLwlsdj42j";
		string profileJsonData = "{\"id\": \"12345678\", \"birthday\": \"1/1/1950\", \"first_name\": \"Chris\", \"gender\": \"male\", \"last_name\": \"Colm\", \"link\": \"http://www.facebook.com/12345678\", \"location\": { \"id\": \"110843418940484\", \"name\": \"Seattle, Washington\" }, \"locale\": \"en_US\", \"name\": \"Chris Colm\", \"timezone\": -8, \"updated_time\": \"2010-01-01T16:40:43+0000\", \"verified\": true}"; 
		AllUnite_BindFbProfile (profileToken, profileJsonData);
	}

	public void onEnableDebugLog(){
		Debug.Log("AllUnite_enableDebugLog");
		AllUnite_enableDebugLog();
	}
}
