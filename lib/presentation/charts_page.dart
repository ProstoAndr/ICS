import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/presentation/widgets/created_charts.dart';
import 'package:ics/presentation/widgets/init_page.dart';

import 'cubit/charts_cubit.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Отрисовка графов'),
      ),
      body: BlocBuilder<ChartsCubit, ChartsState>(
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
            return const CreatedCharts();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
