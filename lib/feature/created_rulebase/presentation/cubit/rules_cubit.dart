import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule_params.dart';

import '../../boundary/usecase/created_rule_base_usecase.dart';
import '../../domain/enity/rule.dart';

part 'rules_state.dart';

class RulesCubit extends Cubit<RulesState> {
  final CreatedRuleBaseUseCase createdRuleBaseUseCase;

  late double singleton;

  RulesCubit({
    required this.createdRuleBaseUseCase,
  }) : super(RulesInitial());

  Future<void> creatingRules(RuleParams? ruleParams) async {
    if (ruleParams == null) {
      throw UnimplementedError();
    } else {
      emit(RulesLoading());
      final listRule = await createdRuleBaseUseCase.ruleBaseGeneration(ruleParams.rulesData);
      final num countRules = pow(ruleParams.rulesData.countTerm, ruleParams.rulesData.countPlenty);
      singleton = await createdRuleBaseUseCase.singletonMethod();
      if(listRule != null) {
        emit(
          RulesCreated(
            nameMethod: 'Название метода: ${ruleParams.nameMethod}',
            countTerm: 'Количесвто термов: ${ruleParams.rulesData.countTerm}',
            countPlenty: 'Количесвто литеров: ${ruleParams.rulesData
                .countPlenty}',
            countRules: 'Количесвто правил: $countRules',
            singleton: singleton,
            listRule: listRule,
          ),
        );
      }
    }
  }

  Future<void> saveFile() async {
    await createdRuleBaseUseCase.creatingFile();
  }
}
