using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using NotificationServices = UnityEngine.iOS.NotificationServices;
using NotificationType = UnityEngine.iOS.NotificationType;
using Device = UnityEngine.iOS.Device;
using RemoteNotification = UnityEngine.iOS.RemoteNotification;

public class AllUniteSdkPushNotificationDemo : MonoBehaviour {

	private bool tokenSent = false;

	private string apnToken;
	private string deviceId;

	void Start () {
		this.registerRemoteNotifications ();
	}

	void Update () {
		this.sendApnToken ();
		this.handleRemoteNotifications();
	}


	private void registerRemoteNotifications(){
		NotificationServices.RegisterForNotifications(
			NotificationType.Alert | 
			NotificationType.Badge | 
			NotificationType.Sound);
	}


	private void sendApnToken(){
		if (tokenSent) {
			return;
		}

		byte[] token = NotificationServices.deviceToken;
		if (token == null) {
			return;
		}
		this.apnToken = System.BitConverter.ToString(token).Replace("-", "");
		this.deviceId = Device.vendorIdentifier;
		this.tokenSent = true;

		Debug.Log ("Send apn token = " + apnToken + " for device " + deviceId);
	}

	private void handleRemoteNotifications(){

		if (NotificationServices.remoteNotificationCount == 0) {
			return;
		}

		foreach (RemoteNotification notification in NotificationServices.remoteNotifications) {
			Debug.Log ("Received remote notification");
			this.handleRemoteNotification (notification);
		}

		NotificationServices.ClearRemoteNotifications();
	}

	// Payload (silent): { "aps" : { "content-available" : 1, "sound" : "" }, "data" :{"allunite" : "RequestDeviceStatus"}}
	private void handleRemoteNotification(RemoteNotification remoteNotification) {
		if (!isAllUniteRequest (remoteNotification)) {
			Debug.Log ("Handle your remote push notification");
			return;
		}

		string allUniteRequest = this.getAllUniteRequest (remoteNotification);
		if (allUniteRequest == "RequestDeviceStatus") {
			Debug.Log ("AllUniteSdk. remote notification - " + allUniteRequest );
			AlluniteSdk.AllUnite_TrackDeviceState ();
		} else {
			Debug.Log ("AllUniteSdk. remote notification - unknown " + allUniteRequest);
		}

	}

	private bool isAllUniteRequest(RemoteNotification remoteNotification){
		return this.getAllUniteRequest (remoteNotification) != null;
	}

	private string getAllUniteRequest(RemoteNotification remoteNotification){
		IDictionary data = remoteNotification.userInfo ["data"] as IDictionary;
		if (data == null) {
			return null;
		}
		return data ["allunite"] as string;
	}
}
