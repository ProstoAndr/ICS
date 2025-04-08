import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

import '../../boudary/usecase/model_training_usecase.dart';

part 'model_training_state.dart';

class ModelTrainingCubit extends Cubit<ModelTrainingState> {
  final ModelTrainingUseCase modelTrainingUseCase;

  ModelTrainingCubit({
    required this.modelTrainingUseCase,
  }) : super(ModelTrainingInitial());

  late List<Rule> updatedRules;


  Future<void> training(
      List<Rule> listRule,
      double singleton,
      List<Plenty> plenties,
      List<ChartData> membershipAll,
      ) async {
    emit(ModelTrainingLoading());

    // Дадим Flutter успеть перерисовать крутилку
    await Future.delayed(Duration.zero);

    // Запускаем compute, передавая анонимную функцию
    final newRules = await compute<_TrainParams, List<Rule>>(
      _trainInIsolate,
      _TrainParams(
        listRule: listRule,
        singleton: singleton,
        plenties: plenties,
        membershipAll: membershipAll,
      ),
    );

    updatedRules = newRules;
    emit(ModelTrainingCreated());
  }

  List<Rule> _trainInIsolate(_TrainParams params) {
    // Здесь мы вызываем ваш UseCase:
    // Или как у вас там инициализация.

    // Выполняем саму логику внутри изолята:
    return modelTrainingUseCase.gradientDescent(
      params.listRule,
      params.singleton,
      params.plenties,
      params.membershipAll,
    );
  }


  Future<void> predictTSK(List<ChartData> membershipAll) async {
    final predictTSK = await modelTrainingUseCase.predictTSK(
      x0: 0,
      x1: 0.0357142857142857,
      x2: 1,
      listRule: updatedRules,
      membershipAll: membershipAll,
    );
    print(predictTSK);
  }
}

class _TrainParams {
  final List<Rule> listRule;
  final double singleton;
  final List<Plenty> plenties;
  final List<ChartData> membershipAll;

  _TrainParams({
    required this.listRule,
    required this.singleton,
    required this.plenties,
    required this.membershipAll,
  });
}
