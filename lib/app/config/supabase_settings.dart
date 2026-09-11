


// to run the app with local supabase settings,
// and use flutter run --dart-define-from-file=tool/staging.json for staging settings, and flutter run --dart-define-from-file=tool/production.json for production settings.
class SupabaseSetting {
  final String url;
  final String publishableKey;

  const SupabaseSetting({
    required this.url,
    required this.publishableKey,
  });


// why factory constructor? because we want to read 
//the values from dart-define and validate them 
//before returning the instance.
// factory constructor can read the value from dart-define 
//Factory constructor | can validate | can throw exception | 

  factory SupabaseSetting.fromDartDefine() {
    // 1. Read the values first
    const url = String.fromEnvironment('SUPABASE_URL');
    const publishableKey =
        String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

    // 2. Validate them before returning
    if (url.isEmpty || publishableKey.isEmpty) {
      throw Exception(
        'Supabase URL and Publishable Key must be provided via --dart-define or --dart-define-from-file.',
      );
    }

    // 3. Return the instance
    return SupabaseSetting(
      url: url,
      publishableKey: publishableKey,
    );
  }
}
