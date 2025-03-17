import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule_params.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';
import 'package:ics/init/app_router_init.dart';
import 'package:ics/theme/main_colors.dart';
import 'package:ics/utils/browser_helper.dart';

import 'cubit/charts_cubit.dart';
import 'widgets/created_charts.dart';

class ChartsPage extends StatefulWidget {
  final int chartIndex;
  final int termCount;

  const ChartsPage({
    super.key,
    required this.chartIndex,
    required this.termCount,
  });

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = BlocProvider.of<ChartsCubit>(context);
    cubit.buildCharts(widget.chartIndex, widget.termCount);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChartsCubit>(context);
    return Scaffold(
      backgroundColor: MainColors.neutral030,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MainColors.neutral030,
        title: const Text('Отрисовка графов'),
        actions: [
          ElevatedButton(
            onPressed: () {
              final params = cubit.getParams();
              context.go(
                Routes.rules,
                extra: params,
              );
            },
            child: const Text('Правила'),
          ),
        ],
      ),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: BlocBuilder<ChartsCubit, ChartsState>(
                builder: (context, state) {
                  if (state is ChartsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ChartsCreated) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            browserHistoryBack();
                            blockBrowserBackButton();
                          },
                          child: const Text('Назад'),
                        ),
                        const Gap(32),
                        const CreatedCharts(),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
