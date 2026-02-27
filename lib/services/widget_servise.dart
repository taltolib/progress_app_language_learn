// import 'dart:io';
//
// class WidgetService {
//   static const String appGroupId = 'group.com.progress.widget';
//
//   static Future<void> updateWidget({
//     required String title,
//     required String subtitle,
//     required String icon,
//     required String background,
//   }) async {
//
//     if (Platform.isIOS) {
//       await HomeWidget.setAppGroupId(appGroupId);
//     }
//
//     await HomeWidget.saveWidgetData('title', title);
//     await HomeWidget.saveWidgetData('subtitle', subtitle);
//     await HomeWidget.saveWidgetData('icon', icon);
//     await HomeWidget.saveWidgetData('background', background);
//
//     await HomeWidget.updateWidget(
//       iOSName: 'ProgressWidget',
//     );
//   }
// }