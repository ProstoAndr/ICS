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

  String nameMethod = '';
  RuleParams? ruleParams;

  void buildCharts(
    int numberChart,
    int countTerm,
    List<Plenty> listPlenty,
  ) async {
    emit(ChartsLoading());

    List<ChartData> allCharts = [];
    for (final plenty in listPlenty) {
      List<List<Point>> graphData;
      List<List<Point>> membershipData;

      switch (numberChart) {
        case 0:
          nameMethod = 'Треугольный';
          graphData = await chartsUseCase.buildTriangle(countTerm);
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
        countPlenty: listPlenty.length,
        allCharts: allCharts,
        plenties: listPlenty,
      ),
    );

    emit(ChartsCreated(allCharts));
  }

  RuleParams? getParams() {
    return ruleParams;
  }
}
