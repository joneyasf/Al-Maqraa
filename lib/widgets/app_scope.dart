import 'package:flutter/widgets.dart';

import '../state/app_state.dart';
import '../state/live_controller.dart';

/// يوفّر الحالة العامة لكل الشاشات.
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.app,
    required this.live,
    required super.child,
  });

  final AppState app;
  final LiveController live;

  static AppScope of(BuildContext context) {
    final s = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(s != null, 'AppScope غير موجود');
    return s!;
  }

  /// قراءة بدون اشتراك (تصلح داخل initState).
  static AppScope read(BuildContext context) {
    final s = context.getInheritedWidgetOfExactType<AppScope>();
    assert(s != null, 'AppScope غير موجود');
    return s!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
