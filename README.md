Here is instructions how to open specific system settings page from your iOS application. It works from iOS version 8. I create small demo project which you can check, it's available on [GitHub](https://github.com/Hejki/ios_open_settings_example).

### Project setup

* First set bundle URL type to allow handle `prefs` URL scheme by your application
* In XCode open project settings: Targets - ApplicationTarget - Info - URL Types
![URL Types settings](https://dl.dropboxusercontent.com/u/16535698/tumblr/ios_settings/url_types.png)
* Or add `CFBundleURLTypes` key to application's `info.plist`

        <key>CFBundleURLTypes</key>
        <array>
            <dict>
                <key>CFBundleTypeRole</key>
                <string>Editor</string>
                <key>CFBundleURLSchemes</key>
                <array>
                    <string>prefs</string>
                </array>
            </dict>
        </array>
        
* Now you can use `UIApplication.sharedApplication().openURL(url)` to open desired setting page

        let app = UIApplication.sharedApplication()
        let url = NSURL(string: "prefs:root=General&path=About")!
        
        if app.canOpenURL(url) {
            app.openURL(url)
        }
        
* For available URLs check Links section below
* You can use URL string `UIApplicationOpenSettingsURLString` to open current application settings if application has any

### Links
* [URL Schemes](https://github.com/bumaociyuan/blog/blob/2a1fdef75d34b8d4718be53f0ea84846a2684273/source/_posts/2014-10-09-url-schemes.md)
* [StackOverflow with URL scheme definition](http://stackoverflow.com/a/31253743)
* [Another StackOverflow](http://stackoverflow.com/questions/9092142/ios-uialertview-button-to-go-to-setting-app)
