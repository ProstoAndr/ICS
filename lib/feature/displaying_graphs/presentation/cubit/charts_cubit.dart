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
     Plenty(name: "Rain", data: [0.75,0,0,0,0,0,0,0,0.25,0,0,0,0.25,0.5,0.75,0.75,0.25,0.25,0,0,0,0.5,0.75,0,0.25,0.25,0,0.25,0.5,0.5,1]),
     Plenty(name: "Snowfall", data: [0,0.2,0.33333,0.26667,0.26667,0.13333,0.2,0.06667,0,0.06667,0.06667,0.26667,0.26667,0.13333,0.06667,0.06667,0.2,1,0.13333,0.86667,0.13333,0.06667,0,0,0.53333,0.33333,0.33333,0.26667,0.2,0.26667,0.06667]),
     Plenty(name: "Cloud Cover", data: [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]),
     Plenty(name: "Weather Code", data: [0,0.5,0.5,0.5,0.5,0.5,0.5,0,0,0,0,0.5,0.5,0.5,0,0,0.5,1,0.5,1,0.5,0,0,0,0.5,0.5,0.5,0.5,0.5,0.5,0])
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
