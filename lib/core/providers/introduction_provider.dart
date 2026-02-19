import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IntroductionProvider extends ChangeNotifier {
  final PageController controller = PageController();
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  bool get isLastPage => _currentPage == 2;

  void next(BuildContext context) {
    if (isLastPage) {
      context.go('/language');
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void prev() {
    if (_currentPage > 0) {
      controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
