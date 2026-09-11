import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasks_app/app/config/build_config_provider.dart';
import 'package:tasks_app/app/theme/theme_mode_controller.dart';

import 'app/router/app_router.dart';

import 'package:tasks_app/app/theme/app_theme.dart';
import 'package:tasks_app/app/config/supabase_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SupabaseSetting.fromDartDefine();
  await Supabase.initialize(
    url: settings.url,
    publishableKey: settings.publishableKey,
  );

  debugPrint('Supabase initialized successfully: ${settings.url}');

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch listen for change and rebuild the UI when the value changes.
    // ref.read read the value once and does not rebuild the UI when the value changes.
    final router = ref.watch(routerProvider);
    final config = ref.watch(buildConfigProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: config.settings.showDebugBanner,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // make the app follow the app default system 
      themeMode: themeMode,
    );
  }
}
