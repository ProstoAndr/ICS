import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../boundary/usecase/charts_usecase.dart';
import '../../domain/entity/point.dart';

part 'charts_state.dart';

class ChartsCubit extends Cubit<ChartsState> {
  final ChartsUseCase chartsUseCase;

  ChartsCubit({required this.chartsUseCase}) : super(ChartsInitial());

  void buildCharts(int numberChart, int countTerm) async {
    emit(ChartsLoading());
    List<List<Point>> chartData;
    switch (numberChart) {
      case 0: // Треугольный
        chartData = await chartsUseCase.buildTriangle(countTerm);
        emit(ChartsCreated(chartData));
        break;
      case 1: // Трапециевидный
      //chartData = await chartsUseCase.buildTrapezoidal(countTerm);
        break;
      case 2: // Гауссов
      //chartData = await chartsUseCase.buildGaussian(countTerm);
        break;
      case 3: // Парабола
      //chartData = await chartsUseCase.buildParabolic(countTerm);
        break;
      default:
      //emit(ChartsError("Неизвестный тип графика"));
        return;
    }

  }

  void back() {
    emit(ChartsInitial());
  }
}
