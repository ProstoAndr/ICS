import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule_params.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';

import '../../domain/entity/chart_data.dart';
import '../../boundary/usecase/charts_usecase.dart';
import '../../boundary/usecase/membership_usecase.dart';
import '../../domain/entity/plenty.dart';
import '../../domain/entity/point.dart';

part 'charts_state.dart';

class ChartsCubit extends Cubit<ChartsState> {
  final ChartsUseCase chartsUseCase;
  final MembershipUseCase membershipUseCase;

  ChartsCubit({
    required this.chartsUseCase,
    required this.membershipUseCase,
  }) : super(ChartsInitial());

   final List<Plenty> plenties = [
     Plenty(name: "Rain", data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0, 0, 0.2, 0, 0.1, 0, 0.1, 0.2]),
     Plenty(name: "Snowfall", data: [0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
     Plenty(name: "Cloud Cover", data: [0.91, 1, 1, 1, 1, 0.99, 0.68, 0.14, 0.29, 0.59, 0.52, 0.9, 0.8, 0.35, 1, 0.97, 0.47, 0.94, 1, 0.98, 0.94, 0.59, 0.48, 0.55, 0.49]),
     Plenty(name: "Weather Code", data: [0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.02, 0, 0.01, 0.02, 0.02, 0.03, 0.03, 0.01, 0.03, 0.53, 0.53, 0.03, 0.03, 0.51, 0.03, 0.51, 0.01, 0.51, 0.51])
  ];

  String nameMethod = '';
  RuleParams? ruleParams;

  void buildCharts(int numberChart, int countTerm) async {
    emit(ChartsLoading());

    List<ChartData> allCharts = [];
    for (final plenty in plenties) {
      List<List<Point>> graphData;
      List<List<Point>> membershipData;

      switch (numberChart) {
        case 0:
          nameMethod = 'Треугольный';
          graphData = await chartsUseCase.buildTriangle(plenty.data, countTerm);
          membershipData =
              await membershipUseCase.triangles(plenty.data, countTerm);
          break;
        case 1:
          nameMethod = 'Трапециевидный';
          graphData =
              await chartsUseCase.buildTrapezoidal(plenty.data, countTerm);
          membershipData =
              await membershipUseCase.trapezoids(plenty.data, countTerm);
          break;
        case 2:
          nameMethod = 'Гаусса';
          graphData = await chartsUseCase.buildGaussian(plenty.data, countTerm);
          membershipData =
              await membershipUseCase.gaussians(plenty.data, countTerm);
          break;
        case 3:
          nameMethod = 'Парабола';
          graphData =
              await chartsUseCase.buildParabolic(plenty.data, countTerm);
          membershipData =
              await membershipUseCase.parabolas(plenty.data, countTerm);
          break;
        default:
          return;
      }

      allCharts.add(ChartData(plenty.name, graphData, membershipData));
    }

    ruleParams = RuleParams(
      nameMethod: nameMethod,
      rulesData: RulesData(
        countTerm: countTerm,
        countPlenty: plenties.length,
        allCharts: allCharts,
      ),
    );

    emit(ChartsCreated(allCharts));
  }

  RuleParams? getParams() {
    return ruleParams;
  }
}
