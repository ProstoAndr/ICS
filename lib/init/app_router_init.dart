import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ics/presentation/cubit/charts_cubit.dart';

import '../domain/usecase/charts_usecase_impl.dart';
import '../presentation/charts_page.dart';

class AppRouterInit {
  final GoRouter _router;

  AppRouterInit()
      : _router = GoRouter(
          initialLocation: Routes.charts,
          routes: [
            GoRoute(
              path: Routes.charts,
              builder: (context, state) => BlocProvider(
                create: (_) => ChartsCubit(chartsUseCase: ChartsUseCaseImpl()),
                child: const ChartsPage(),
              ),
            ),
          ],
          errorPageBuilder: (context, state) {
            return MaterialPage(
              child: Scaffold(
                body: Center(
                  child: Text('Error ${state.error}'),
                ),
              ),
            );
          },
        );

  GoRouter get router => _router;
}

class Routes {
  static const charts = '/';
}
