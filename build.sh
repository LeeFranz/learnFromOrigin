keyAlias=xx
storePassword=xx
keyPassword=xx
signed_aligned_apk=signed_align.apk
target_apk=target.apk
aligned_apk=aligned.apk
channel=$1
versionNameAndCode=1.0
if [ ! -n "$channel" ];then
		channel=google
fi
domain=pb.163.com
apiDomain=qa.pbt.163.com
debugApiDomain=qa-amban.igame.163.com
if [ "$2" == "-dm" ];then
	domain=$3
fi
if [ "$4" == "-dmlook" ];then
    apiDomain=$5
fi
echo "domain is: "$domain
./gradlew clean assemblerelease -PappDomain=\"$domain\" -PreleaseApiBaseUrl=\"$apiDomain\" -PdebugApiBaseUrl=\"$debugApiDomain\" -Pchannel=\"$channel\"
#目前使用和云音乐一样的轻量级加密方案，字符串混淆，防止反编译，签名校验等功能
# java -jar NHPProtect.jar -yunconfig -input app/build/outputs/apk/release/app-armeabi-release.apk
cp app/build/outputs/apk/release/app-armeabi-release.apk $target_apk

./zipalign -v 4 $target_apk $aligned_apk

java -jar apksigner.jar sign --ks cloudmusic.keystore --ks-pass pass:$storePassword --key-pass pass:$keyPassword \
--ks-key-alias $keyAlias --out $signed_aligned_apk $aligned_apk

#jarsigner -verbose -keystore app/keystore/release.jks -signedjar $live_signed_apk $target_apk $keyAlias -digestalg SHA1 \
#-sigalg MD5withRSA -keypass $keyPassword -storepass $storePassword;
#./zipalign -v 4 $live_signed_apk $signed_aligned_apk
#python checkLiveApk.py $signed_aligned_apk
echo "input channel is $channel"
versionNameAndCodeValue=`cat $versionNameAndCode`
mv $signed_aligned_apk iCreator_"$channel"_"$versionNameAndCodeValue".apk
#rm $versionNameAndCode $align_apk $target_apk

