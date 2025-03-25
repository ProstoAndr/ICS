import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule_params.dart';

import '../../boundary/usecase/created_rule_base_usecase.dart';

part 'rules_state.dart';

class RulesCubit extends Cubit<RulesState> {
  final CreatedRuleBaseUseCase createdRuleBaseUseCase;

  RulesCubit({
    required this.createdRuleBaseUseCase,
  }) : super(RulesInitial());

  Future<void> creatingRules(RuleParams? ruleParams) async {
    if (ruleParams == null) {
      throw UnimplementedError();
    } else {
      emit(RulesLoading());
      await createdRuleBaseUseCase.ruleBaseGeneration(ruleParams.rulesData);
      final num countRules = pow(ruleParams.rulesData.countTerm, ruleParams.rulesData.countPlenty);
      emit(
        RulesCreated(
          nameMethod: 'Название метода: ${ruleParams.nameMethod}',
          countTerm: 'Количесвто термов: ${ruleParams.rulesData.countTerm}',
          countPlenty: 'Количесвто литеров: ${ruleParams.rulesData.countPlenty}',
          countRules: 'Количесвто правил: $countRules',
        ),
      );
    }
  }

  Future<void> saveFile() async {
    await createdRuleBaseUseCase.creatingFile();
    await createdRuleBaseUseCase.singletonMethod();
  }
}
