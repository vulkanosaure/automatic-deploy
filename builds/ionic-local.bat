@ECHO OFF

set env=%1
set env=%1
IF "%env%"=="" (
	set env=prod
)

set outputfile=safahat-dz-%env%.apk
set keystore=my-release-key.keystore
set keystore_name=Vincent Huss



cd platforms/android/build/outputs/apk


REM if outputfile exist, delete

IF EXIST %outputfile% (
	del %outputfile%
)


REM if no .keystore, create

IF NOT EXIST %keystore% (
	echo keystore not found : generating...
	keytool -genkey -v -keystore %keystore% -alias "%keystore_name%" -keyalg RSA -keysize 2048 -validity 10000
)


REM sign apk

jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore %keystore% android-release-unsigned.apk "%keystore_name%"


REM optimize apk

C:\SDK\android-sdk\build-tools\27.0.3\zipalign -v 4 android-release-unsigned.apk %outputfile%
