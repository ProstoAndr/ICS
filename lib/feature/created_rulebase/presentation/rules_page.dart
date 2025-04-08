import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule_params.dart';
import 'package:ics/feature/created_rulebase/presentation/widgets/item_data_rules.dart';
import 'package:ics/feature/model_training/domain/usecase/model_training_usecase_impl.dart';
import 'package:ics/feature/model_training/presentation/cubit/model_training_cubit.dart';
import 'package:ics/feature/model_training/presentation/widgets/training_schedule.dart';
import 'package:ics/theme/main_colors.dart';

import '../domain/enity/rule.dart';
import 'cubit/rules_cubit.dart';

class RulesPage extends StatefulWidget {
  final RuleParams? ruleParams;

  const RulesPage({super.key, required this.ruleParams});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = BlocProvider.of<RulesCubit>(context);
    cubit.creatingRules(widget.ruleParams);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<RulesCubit>(context);
    return Scaffold(
      backgroundColor: MainColors.neutral030,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Правила и обучение модели'),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: Column(
                children: [
                  const Gap(32),
                  BlocBuilder<RulesCubit, RulesState>(
                    builder: (context, state) {
                      if (state is RulesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is RulesCreated) {
                        return Column(
                          children: [
                            Container(
                              width: 840 - 32 - 16,
                              decoration: BoxDecoration(
                                color: MainColors.neutral010,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 32,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: MainColors.neutral030,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.file_open,
                                          size: 80,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 516,
                                          decoration: BoxDecoration(
                                            color: MainColors.neutral030,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 16,
                                            ),
                                            child: Column(children: [
                                              ItemDataRules(
                                                parameter: state.nameMethod,
                                              ),
                                              const Gap(4),
                                              ItemDataRules(
                                                parameter: state.countTerm,
                                              ),
                                              const Gap(4),
                                              ItemDataRules(
                                                parameter: state.countPlenty,
                                              ),
                                              const Gap(4),
                                              ItemDataRules(
                                                parameter: state.countRules,
                                              ),
                                            ]),
                                          ),
                                        ),
                                        const Gap(16),
                                        ElevatedButton(
                                          onPressed: () {
                                            cubit.saveFile();
                                          },
                                          child: const Text('Скачать файл правил'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(24),
                            Container(
                              width: 840 - 32 - 16,
                              decoration: BoxDecoration(
                                color: MainColors.neutral010,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: BlocProvider(
                                  create: (_) => ModelTrainingCubit(
                                    modelTrainingUseCase: ModelTrainingUseCaseImpl(),
                                  ),
                                  child: TrainingSchedule(
                                    listRule: state.listRule,
                                    singleton: state.singleton,
                                    plenties: state.plenties,
                                    membershipAll: state.membershipAll,
                                  )),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
