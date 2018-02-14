Unity. AllUnite Demo (IOS platform)
===============================

libAllUniteSdk.a (version 1.2.21)

##### 1. Open Unity project.
##### 2. Switch platform to ios (**REQUIRED**)
##### 3. Build ios platform (Unity create new XCode project)

##### 3. Open Xcode project.
##### 3.1. General settigs. Change app bundle identifier and select your Team. Required: enable push notification and register certificate in apple developer account (if need).
##### 3.2. Product Build Settigns. Add the value of the Other Linker Flags build setting to the -ObjC to your project
For more details see there: https://developer.apple.com/library/content/qa/qa1490/_index.html
##### 3.3. Add to info.plist file:

```
<key>UIBackgroundModes</key>
<array>
    <string>bluetooth-central</string>
    <string>remote-notification</string>
</array>
```

