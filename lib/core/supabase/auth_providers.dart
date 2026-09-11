


// Supabase client in core because it is shared infrastructure; keep
// URLs and keys in app/config because they are environment configuration


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tasks_app/features/auth/data/supabase_auth_repository.dart';
import 'package:tasks_app/features/auth/domain/auth_repository.dart';



// This provider is not stateful; it just constructs and returns the repository instance.

// we created it in the core layer because it is shared infrastructure,
// and we want to keep the domain layer clean of any implementation details.
// share infrastructure examples : database | networking | storage | authentication| firebase

// We inject the AuthRepository (domain abstraction) with the real 
// Supabase implementation, and the repository uses the 
//Supabase client to get the user instance.

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // SupabaseAuthRepository requires a dependency 
  // we inject that dependency through the constructor 
  return SupabaseAuthRepository(Supabase.instance.client);
});