##  利用plist文件安装本地ipa

一、把ipa文件上传到蒲公英或fir第三方平台，生成二维码让用户下载安装即可。

二、上传到OSS服务器。   

1、配置plist文件（企业账号打包后生成）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>items</key>
    <array>
        <dict>
            <key>assets</key>
            <array>
                <dict>
                    <key>kind</key>
                    <string>software-package</string>
                    <key>url</key>
                    <string>填写你的ipa下载地址(比如:https://xxx.com/download/app.ipa)</string>
                </dict>
            </array>
            <key>metadata</key>
            <dict>
                <key>bundle-identifier</key>
                <string>填写你的开发者证书用户名即bundleId</string>
                <key>bundle-version</key>
                <string>填写你的APP版本号</string>
                <key>kind</key>
                <string>software</string>
                <key>title</key>
                <string>填写你的应用名称</string>
            </dict>
        </dict>
    </array>
</dict>
</plist>
```

2、将plist 文件和ipa包上传到OSS服务器  
3、前端写下载页面，配置下载链接  

```javascript
itms-services://?action=download-manifest&url=plist文件url
```

示例： 

```javascript
itms-services://?action=download-manifest&url=https://xxx.com/xx.plist
```


