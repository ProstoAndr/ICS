import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/charts_cubit.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChartsCubit>(context);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          cubit.buildCharts(0, 3);
        },
        child: const Text('Построить графики'),
      ),
    );
  }
}
