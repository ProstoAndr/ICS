import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ics/theme/main_colors.dart';

import '../cubit/charts_cubit.dart';
import 'excel_file_uploader.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final List<String> chartTypes = [
    "Треугольный",
    "Трапециевидный",
    "Гаусса",
    "Парабола"
  ];

  String selectedChart = "Треугольный";
  final TextEditingController termController = TextEditingController(text: "3");

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChartsCubit>(context);
    return Container(
      decoration: BoxDecoration(
        color: MainColors.neutral010,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: ExcelUploaderWidget()),
                const Gap(32),
                SizedBox(
                  width: 560,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Выберите тип графика",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(16),

                      // Radio Buttons
                      Column(
                        children: chartTypes.map((chart) {
                          return RadioListTile<String>(
                            title: Text(chart),
                            value: chart,
                            groupValue: selectedChart,
                            onChanged: (String? value) {
                              setState(() {
                                selectedChart = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),

                      const Gap(32),
                      const Text("Количество термов"),
                      TextField(
                        controller: termController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Введите число",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final termCount = int.tryParse(termController.text);
                  if (termCount == null || termCount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Введите корректное число термов"),
                      ),
                    );
                    return;
                  }
                  final chartIndex = chartTypes.indexOf(selectedChart);
                  cubit.buildCharts(chartIndex, termCount);
                },
                child: const Text('Построить графики'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
