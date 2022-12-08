import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/env/.env')
abstract class Env {
  @EnviedField(varName: 'WEB_KEY', obfuscate: true)
  static final firebaseWebKey = _Env.firebaseWebKey;

  @EnviedField(varName: 'ANDROID_KEY', obfuscate: true)
  static final firebaseAndroidKey = _Env.firebaseAndroidKey;

  @EnviedField(varName: 'IOS_KEY', obfuscate: true)
  static final firebaseIosKey = _Env.firebaseIosKey;

  @EnviedField(varName: 'MACOS_KEY', obfuscate: true)
  static final firebaseMacosKey = _Env.firebaseMacosKey;

  @EnviedField(varName: 'MAP_TOKEN', obfuscate: true)
  static final mapToken = _Env.mapToken;
}