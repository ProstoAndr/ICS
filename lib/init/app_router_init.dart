import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule_params.dart';
import 'package:ics/feature/created_rulebase/domain/usecase/created_rule_base_usecase_impl.dart';
import 'package:ics/feature/created_rulebase/presentation/cubit/rules_cubit.dart';
import 'package:ics/feature/created_rulebase/presentation/rules_page.dart';
import 'package:ics/feature/displaying_graphs/domain/usecase/charts_usecase_impl.dart';
import 'package:ics/feature/displaying_graphs/domain/usecase/membership_usecase_impl.dart';
import 'package:ics/feature/displaying_graphs/presentation/charts_page.dart';
import 'package:ics/feature/displaying_graphs/presentation/cubit/charts_cubit.dart';
import 'package:ics/feature/uploading_data/domain/entity/chart_params.dart';
import 'package:ics/feature/uploading_data/presentation/init_page.dart';

class AppRouterInit {
  final GoRouter _router;

  AppRouterInit()
      : _router = GoRouter(
          initialLocation: Routes.initData,
          routes: [
            GoRoute(
              path: Routes.initData,
              builder: (context, state) => const InitPage(),
            ),
            GoRoute(
              path: Routes.charts,
              builder: (context, state) {
                final params = state.extra as ChartParams?;

                final chartIndex = params?.chartIndex ?? 0;
                final termCount = params?.termCount ?? 0;

                return BlocProvider(
                  create: (_) => ChartsCubit(
                    chartsUseCase: ChartsUseCaseImpl(),
                    membershipUseCase: MembershipUseCaseImpl(
                      chartsUseCase: ChartsUseCaseImpl(),
                    ),
                  ),
                  child: ChartsPage(
                    chartIndex: chartIndex,
                    termCount: termCount,
                  ),
                );
              },
            ),
            GoRoute(
              path: Routes.rules,
              builder: (context, state) {
                final params = state.extra as RuleParams?;

                  return BlocProvider(
                    create: (_) => RulesCubit(
                      createdRuleBaseUseCase: CreatedRuleBaseUseCaseImpl(),
                    ),
                    child: RulesPage(ruleParams: params),
                  );
                }),
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
  static const initData = '/';
  static const charts = '/charts';
  static const rules = '/rules';
}
