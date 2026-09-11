import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasks_app/features/auth/presentation/auth_loading_screen.dart';
import 'package:tasks_app/features/auth/presentation/sign_in_screen.dart';
import 'package:tasks_app/features/auth/presentation/sign_up_screen.dart';
import 'package:tasks_app/features/home/presentation/home_screen.dart';
import 'package:tasks_app/features/tasks/presentation/create_task_screen.dart';
import 'package:tasks_app/features/tasks/presentation/tasks_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<AuthLoadingRoute>(path: '/auth/loading')
class AuthLoadingRoute extends GoRouteData with $AuthLoadingRoute {
  const AuthLoadingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthLoadingScreen();
  }
}

@TypedGoRoute<SignInRoute>(path: '/sign-in')
class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInScreen();
  }
}

@TypedGoRoute<SignUpRoute>(path: '/sign-up')
class SignUpRoute extends GoRouteData with $SignUpRoute {
  const SignUpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignUpScreen();
  }
}

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }

  
}

@TypedGoRoute<TasksRoute>(path: '/tasks')
  class TasksRoute extends GoRouteData with $TasksRoute {
    const TasksRoute();

    @override
    Widget build(BuildContext context, GoRouterState state) {
      return const TasksScreen();
    }

  }

@TypedGoRoute<CreateTaskRoute>(path:'/tasks/create')
class CreateTaskRoute extends GoRouteData with $CreateTaskRoute {
  const CreateTaskRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateTaskScreen();
  }
}


