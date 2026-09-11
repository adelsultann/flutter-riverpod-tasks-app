import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'build_config.dart';



//This makes your environment available everywhere.

final buildConfigProvider = Provider<BuildConfig>((ref) {
  
  return BuildConfig.fromDartDefine();
});
