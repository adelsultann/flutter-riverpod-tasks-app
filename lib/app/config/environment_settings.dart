final class EnvironmentSettings {
  final String baseUrl;
  final bool enableLogging;
  final bool enableMockData;
  final bool showDebugBanner;

  const EnvironmentSettings({
    required this.baseUrl,
    required this.enableLogging,
    required this.enableMockData,
    required this.showDebugBanner,
  });
}
