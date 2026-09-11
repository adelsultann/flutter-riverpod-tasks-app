import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_app/app/router/routes.dart';
import 'package:tasks_app/features/auth/application/auth_controller.dart';

/// Collects credentials and creates a new email/password account.
class SignUpScreen extends ConsumerStatefulWidget {
  /// Creates the sign-up screen.
  const SignUpScreen({super.key});

  @override
  /// Creates state because text controllers and form validation need disposal.
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

/// Owns the sign-up form's controllers and submission behavior.
class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  /// Releases the text controllers when this screen leaves the widget tree.
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates the form, then delegates account creation to the controller.
  ///
  /// The router responds to any resulting session event rather than this method
  /// navigating directly.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authControllerProvider.notifier)
        .signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  /// Builds the form and listens for command errors to show as a snack bar.
  Widget build(BuildContext context) {
    final authAction = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: authAction.isLoading ? null : _submit,
                    child: authAction.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create account'),
                  ),
                  TextButton(
                    onPressed: authAction.isLoading
                        ? null
                        : () => const SignInRoute().go(context),
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ensures the user supplied a minimally valid email before calling Supabase.
String? _validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Enter your email address.';
  if (!email.contains('@')) return 'Enter a valid email address.';
  return null;
}

/// Ensures the password meets Supabase's default minimum length requirement.
String? _validatePassword(String? value) {
  if ((value?.length ?? 0) < 6) return 'Use at least 6 characters.';
  return null;
}
