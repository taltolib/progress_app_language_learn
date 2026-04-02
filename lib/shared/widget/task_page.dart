import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/core/providers/task_image_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/domain/models/level_model.dart';
import 'package:progress/generated/task/task_generator.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/ball_counter.dart';
import 'package:progress/shared/widget/level_summary_widget.dart';
import 'package:progress/shared/widget/loading_widget.dart';
import 'package:progress/shared/widget/push_button.dart';
import 'package:progress/shared/widget/hearts_for_live.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  final int id;
  const TaskPage({super.key, required this.id});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<LevelModel> _levelFuture;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _levelFuture = TaskGenerator.loadOneLevel(widget.id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().startLevel(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<AppThemeColors>()!;
    final backG = themeColors.backgroundWhiteOrDark;
    final shadowColor = AppColors.borderGrey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<LevelModel>(
        future: _levelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (snapshot.hasError) {
            return Center(child: Text(LocaleKeys.errorWithText.tr(args: [snapshot.error.toString()])));
          }

          if (!snapshot.hasData) {
            return Center(child: Text(LocaleKeys.dataNotFound.tr()));
          }

          final level = snapshot.data!;
          final game = context.watch<GameProvider>();
          final imageProvider = context.watch<TaskImageProvider>();
          
          if (game.nextTask >= level.tasks.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              game.finishLevel(widget.id);
            });

            return LevelSummaryWidget(onHomeTap: () => Navigator.pop(context),);
          }

          final currentTask = level.tasks[game.nextTask];

          return Column(
            children: [
              SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: iconClose(onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<GameProvider>().startLevel(widget.id);
                        });
                        Navigator.pop(context);
                      } )),
                      Expanded(flex: 7, child: BallCounter(score: game.increaseInCondition)),
                      Expanded(
                        flex: 2,
                        child: HeartsForLive(tryS: game.playerProgress.hearts)
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: level.tasks.length,
                  itemBuilder: (context, taskIndex) {
                    final task = level.tasks[taskIndex];
                    return Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                imageProvider.getRandomImage(taskIndex, widget.id),
                                const SizedBox(width: 20),
                                Flexible(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: backG,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: shadowColor,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Text(
                                        task.question,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 2,
                              childAspectRatio: 1.7,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: task.answers.length,
                            itemBuilder: (context, answerIndex) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: PushButton(
                                  language: task.answers[answerIndex],
                                  flagAsset: Container(),
                                  border: Border.all(
                                    color: game.selectedIndex == answerIndex
                                        ? AppColors.blue.withOpacity(0.50)
                                        : shadowColor,
                                    width: 2,
                                  ),
                                  onTap: () {
                                    game.selectIndex(answerIndex);
                                  },
                                  isSelected: game.selectedIndex == answerIndex,
                                  height: 120,
                                  fontSize: 22,
                                  borderRadius: 15,
                                  color: backG,
                                  colorShadow: shadowColor,
                                  colorText:themeColors.text,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: PushButton(
                    language: LocaleKeys.confirm.tr(),
                    flagAsset: Container(),
                    onTap: () {
                      if (game.selectedIndex != null) {
                        game.correctIndex = currentTask.rightAnswer;
                        game.confirmAnswer(game.selectedIndex!);

                        if (game.nextTask < level.tasks.length) {
                           _pageController.animateToPage(
                            game.nextTask,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      }
                    },
                    height: 75,
                    borderRadius: 10,
                    fontSize: 18,
                    color: game.selectedIndex != null ? AppColors.green : AppColors.borderGrey,
                    colorShadow: game.selectedIndex != null ? AppColors.blackGreen : AppColors.borderGrey,
                    colorText: Colors.white,
                    isSelected: false,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget iconClose({required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Icon(Icons.close, color: AppColors.borderBlack, size: 30),
  );
}
