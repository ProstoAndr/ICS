import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/presentation/cubit/charts_cubit.dart';
import 'package:ics/theme/MainColors.dart';

class CreatedCharts extends StatelessWidget {
  const CreatedCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsCubit, ChartsState>(
      builder: (context, state) {
        if (state is ChartsCreated) {
          return Container(
            decoration: BoxDecoration(
              color: MainColors.neutral010,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 840 - 32,
                height: 256 - 32,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false), // Убираем подписи сверху
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false), // Убираем подписи справа
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4),
                              // Даем немного места справа
                              child: Text(
                                value.toStringAsFixed(1),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(value.toStringAsFixed(1)),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: state.triangles.map((triangle) {
                      return LineChartBarData(
                        spots:
                            triangle.map((p) => FlSpot(p.x, p.y)).toList(),
                        isCurved: false,
                        // Должны быть прямые линии!
                        barWidth: 2,
                        isStrokeCapRound: false,
                        belowBarData: BarAreaData(show: false),
                        color: Colors.blue,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(child: Text("Нет данных"));
      },
    );
  }
}
