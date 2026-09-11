import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasks_app/features/auth/application/auth_controller.dart';
import 'package:tasks_app/features/auth/application/auth_providers.dart';
import 'package:tasks_app/gen/assets.gen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreen();

}
 class _HomeScreen extends ConsumerState<HomeScreen> {

  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final theme = Theme.of(context);

    

    return Scaffold(

     
      // Removed default AppBar for a cleaner landing screen look
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex:1),

              // 1. Logo (Fixed overflow risk and double .png extension)
              Flexible(
                child: Assets.images.mainLogoPng.image(
                  width: 500,
                 
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(flex: 1),

              // 2. Modern Typography
              Text(
                'Welcome to Tasks',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Organize your day, achieve your goals.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // 3. Material 3 Buttons
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/sign-in'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: theme.textTheme.titleMedium,
                  ),
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/sign-up');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: theme.textTheme.titleMedium,
                  ),
                  child: const Text('Create Account'),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

