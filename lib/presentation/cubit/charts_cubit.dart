import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../boundary/usecase/charts_usecase.dart';
import '../../domain/entity/plenty.dart';
import '../../domain/entity/point.dart';

part 'charts_state.dart';

class ChartsCubit extends Cubit<ChartsState> {
  final ChartsUseCase chartsUseCase;

  ChartsCubit({required this.chartsUseCase}) : super(ChartsInitial());

  final List<Plenty> plenties = [
    Plenty(name: "Rain", data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0, 0, 0.2, 0, 0.1, 0, 0.1, 0.2]),
    Plenty(name: "Snowfall", data: [0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
    Plenty(name: "Cloud Cover", data: [0.91, 1, 1, 1, 1, 0.99, 0.68, 0.14, 0.29, 0.59, 0.52, 0.9, 0.8, 0.35, 1, 0.97, 0.47, 0.94, 1, 0.98, 0.94, 0.59, 0.48, 0.55, 0.49]),
    Plenty(name: "Weather Code", data: [0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.02, 0, 0.01, 0.02, 0.02, 0.03, 0.03, 0.01, 0.03, 0.53, 0.53, 0.03, 0.03, 0.51, 0.03, 0.51, 0.01, 0.51, 0.51])
  ];

  void buildCharts(int numberChart, int countTerm) async {
    emit(ChartsLoading());

    List<ChartData> allCharts = [];
    switch (numberChart) {
      case 0: // Треугольный
        for (final plenty in plenties) {
          final triangles =
              await chartsUseCase.buildTriangle(plenty.data, countTerm);
          allCharts.add(ChartData(plenty.name, triangles));
        }
        emit(ChartsCreated(allCharts));
        break;
      case 1: // Трапециевидный
        for (final plenty in plenties) {
          final trapeziodal =
              await chartsUseCase.buildTrapezoidal(plenty.data, countTerm);
          allCharts.add(ChartData(plenty.name, trapeziodal));
        }
        emit(ChartsCreated(allCharts));
        break;
      case 2: // Гауссов
        for (final plenty in plenties) {
          final gaussian =
              await chartsUseCase.buildGaussian(plenty.data, countTerm);
          allCharts.add(ChartData(plenty.name, gaussian));
        }
        emit(ChartsCreated(allCharts));
        break;
      case 3: // Парабола
        for (final plenty in plenties) {
          final parabolas =
              await chartsUseCase.buildParabolic(plenty.data, countTerm);
          allCharts.add(ChartData(plenty.name, parabolas));
        }
        emit(ChartsCreated(allCharts));
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

class ChartData {
  final String name;
  final List<List<Point>> data;

  ChartData(this.name, this.data);
}
