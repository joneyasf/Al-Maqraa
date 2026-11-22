import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';
import 'screens/khatma_screen.dart';
import 'screens/live_screen.dart';
import 'screens/mushaf_screen.dart';
import 'services/notification_service.dart';
import 'state/app_state.dart';
import 'state/live_controller.dart';
import 'widgets/app_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  final app = AppState();
  await app.load();
  final live = LiveController(app);
  await NotificationService.init();
  if (app.reminderEnabled) {
    await NotificationService.scheduleDailyReminder();
  }
  runApp(MaqraaApp(app: app, live: live));
}

class MaqraaApp extends StatelessWidget {
  const MaqraaApp({super.key, required this.app, required this.live});

  final AppState app;
  final LiveController live;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      app: app,
      live: live,
      child: AnimatedBuilder(
        animation: app,
        builder: (context, _) {
          return MaterialApp(
            title: kAppName,
            debugShowCheckedModeBanner: false,
            locale: const Locale('ar'),
            builder: (context, child) => Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: app.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainShell(),
          );
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = <Widget>[
    HomeScreen(),
    MushafScreen(),
    LiveScreen(),
    KhatmaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded),
            label: 'المصحف',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_rounded),
            label: 'المقرأة',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_rounded),
            label: 'الختمة',
          ),
        ],
      ),
    );
  }
}
