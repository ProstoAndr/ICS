import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../domain/usecase/upload_file_usecase_impl.dart';
import '../cubit/model_training_cubit.dart';
import '../cubit/upload_file_cubit.dart';
import 'excel_file_uploader.dart';

class TrainingSchedule extends StatefulWidget {
  final List<Rule> listRule;
  final List<Plenty> plenties;
  final List<ChartData> membershipAll;

  const TrainingSchedule({
    super.key,
    required this.listRule,
    required this.plenties,
    required this.membershipAll,
  });

  @override
  State<TrainingSchedule> createState() => _TrainingScheduleState();
}

class _TrainingScheduleState extends State<TrainingSchedule> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ModelTrainingCubit>(context);
    return BlocBuilder<ModelTrainingCubit, ModelTrainingState>(
      builder: (context, state) {
        if (state is ModelTrainingInitial) {
          return ElevatedButton(
            onPressed: () {
              cubit.training(
                widget.listRule,
                widget.plenties,
                widget.membershipAll,
              );
            },
            child: Text('Обучить'),
          );
        }
        if (state is ModelTrainingLoading) {
          print("Loading");
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ModelTrainingCreated) {
          return Column(
            children: [
              const Gap(16),
              BlocProvider(
                create: (_) => UploadFileCubit(
                  uploadFileUseCase: UploadFileUseCaseImpl(),
                ),
                child: const SizedBox(
                  height: 341,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ExcelUploaderWidget(),
                  ),
                ),
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.predictTSK(
                        state.updatedRules,
                        widget.plenties,
                        widget.membershipAll,
                      );
                    },
                    child: Text('Test'),
                  ),
                ),
              ),
              const Gap(16),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
