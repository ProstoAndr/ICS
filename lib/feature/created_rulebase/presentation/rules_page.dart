import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule_params.dart';

import 'cubit/rules_cubit.dart';

class RulesPage extends StatefulWidget {
  final RuleParams? ruleParams;

  const RulesPage({super.key, required this.ruleParams});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  @override
  void initState() {
    super.initState();
    final cubit = BlocProvider.of<RulesCubit>(context);
    cubit.creatingRules(widget.ruleParams);
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
