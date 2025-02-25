import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ics/presentation/widgets/created_charts.dart';
import 'package:ics/presentation/widgets/init_page.dart';
import 'package:ics/theme/main_colors.dart';

import 'cubit/charts_cubit.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  final ScrollController _scrollController = ScrollController();

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
                  if (state is ChartsInitial) {
                    return const InitPage();
                  }
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
                            cubit.back();
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
