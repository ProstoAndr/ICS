import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';

import '../cubit/model_training_cubit.dart';

class TrainingSchedule extends StatefulWidget {
  final List<Rule> listRule;
  final double singleton;

  const TrainingSchedule({
    super.key,
    required this.listRule,
    required this.singleton,
  });

  @override
  State<TrainingSchedule> createState() => _TrainingScheduleState();
}

class _TrainingScheduleState extends State<TrainingSchedule> {
  @override
  void initState() {
    super.initState();
    final cubit = BlocProvider.of<ModelTrainingCubit>(context);
    cubit.training(widget.listRule, widget.singleton);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      height: 100,
      child: Placeholder(),
    );
  }
}
