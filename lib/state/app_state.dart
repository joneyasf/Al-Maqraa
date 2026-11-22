import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/arabic_utils.dart';

/// الحالة العامة للتطبيق، تُحفظ على الجهاز.
///
/// أهم قاعدة هنا — حسب طلب محمد:
/// الأرقام المشرقية ٠١٢٣٤٥٦٧٨٩ هي الافتراضي عند أول فتح للتطبيق،
/// والإنجليزية 123 مجرد خيار ثانوي في الإعدادات.
/// لذلك كل القيم الافتراضية هنا مشرقية: [_easternNumerals] = true
/// والتحميل من التخزين يستخدم `?? true` وليس `?? false` أبدًا.
class AppState extends ChangeNotifier {
  // الأرقام المشرقية هي الافتراضي. لا تغيّر هذا السطر إلى false.
  bool _easternNumerals = true;
  bool _darkMode = true;
  double _fontScale = 1.0;
  bool _reminderEnabled = true;
  String _userName = 'محمد';
  int _lastPage = 1;
  int _currentJuz = 7;
  int _tonightStartPage = 122;
  int _tonightEndPage = 126;
  String _giftedTo = 'والد صاحب التطبيق رحمه الله';
  int _attendanceStreak = 12;
  int _totalPagesRead = 342;

  final Set<int> _completedJuz = {1, 2, 3, 4, 5, 6};
  final Set<int> _bookmarks = {};
  final List<Map<String, String>> _completedKhatmas = [
    {'date': '2026-11-10', 'giftedTo': 'والد صاحب التطبيق رحمه الله'},
    {'date': '2026-10-31', 'giftedTo': 'والد صاحب التطبيق رحمه الله'},
  ];

  bool get easternNumerals => _easternNumerals;
  bool get darkMode => _darkMode;
  double get fontScale => _fontScale;
  bool get reminderEnabled => _reminderEnabled;
  String get userName => _userName;
  int get lastPage => _lastPage;
  int get currentJuz => _currentJuz;
  int get tonightStartPage => _tonightStartPage;
  int get tonightEndPage => _tonightEndPage;
  String get giftedTo => _giftedTo;
  int get attendanceStreak => _attendanceStreak;
  int get totalPagesRead => _totalPagesRead;
  Set<int> get completedJuz => Set.unmodifiable(_completedJuz);
  Set<int> get bookmarks => Set.unmodifiable(_bookmarks);
  List<Map<String, String>> get completedKhatmas =>
      List.unmodifiable(_completedKhatmas);

  int get completedJuzCount => _completedJuz.length;
  double get khatmaProgress => _completedJuz.length / 30;

  /// تنسيق أي رقم حسب اختيار المستخدم — مشرقي افتراضيًا.
  String fmt(int value) => formatDigits(value.toString(), _easternNumerals);

  /// تنسيق نص فيه أرقام حسب اختيار المستخدم.
  String fmtText(String value) => formatDigits(value, _easternNumerals);

  Future<void> load() async {
    try {
      await _loadPrefs();
    } catch (_) {
      // أي تلف في التخزين لا يمنع فتح التطبيق أبدًا — تبقى القيم الافتراضية.
    }
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // الافتراضي هنا true عمدًا: أول فتح للتطبيق تكون الأرقام مشرقية.
    _easternNumerals = prefs.getBool('easternNumerals') ?? true;
    _darkMode = prefs.getBool('darkMode') ?? true;
    _fontScale = prefs.getDouble('fontScale') ?? 1.0;
    _reminderEnabled = prefs.getBool('reminderEnabled') ?? true;
    _userName = prefs.getString('userName') ?? 'محمد';
    _lastPage = prefs.getInt('lastPage') ?? 1;
    final savedJuz = prefs.getStringList('completedJuz');
    if (savedJuz != null && savedJuz.isNotEmpty) {
      _completedJuz
        ..clear()
        ..addAll(savedJuz.map(int.parse));
    }
    final savedBookmarks = prefs.getStringList('bookmarks');
    if (savedBookmarks != null) {
      _bookmarks
        ..clear()
        ..addAll(savedBookmarks.map(int.parse));
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('easternNumerals', _easternNumerals);
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setDouble('fontScale', _fontScale);
    await prefs.setBool('reminderEnabled', _reminderEnabled);
    await prefs.setString('userName', _userName);
    await prefs.setInt('lastPage', _lastPage);
    await prefs.setStringList(
      'completedJuz',
      _completedJuz.map((e) => e.toString()).toList(),
    );
    await prefs.setStringList(
      'bookmarks',
      _bookmarks.map((e) => e.toString()).toList(),
    );
  }

  void setEasternNumerals(bool value) {
    _easternNumerals = value;
    _save();
    notifyListeners();
  }

  void toggleNumerals() => setEasternNumerals(!_easternNumerals);

  void setDarkMode(bool value) {
    _darkMode = value;
    _save();
    notifyListeners();
  }

  void setFontScale(double value) {
    _fontScale = value.clamp(0.85, 1.6);
    _save();
    notifyListeners();
  }

  void setReminderEnabled(bool value) {
    _reminderEnabled = value;
    _save();
    notifyListeners();
  }

  void setUserName(String value) {
    final name = value.trim();
    if (name.isEmpty) return;
    _userName = name;
    _save();
    notifyListeners();
  }

  void setLastPage(int page) {
    _lastPage = page.clamp(1, 604);
    _save();
    notifyListeners();
  }

  void toggleBookmark(int page) {
    if (_bookmarks.contains(page)) {
      _bookmarks.remove(page);
    } else {
      _bookmarks.add(page);
    }
    _save();
    notifyListeners();
  }

  bool isBookmarked(int page) => _bookmarks.contains(page);

  void completeJuz(int juz) {
    _completedJuz.add(juz);
    if (juz == _currentJuz && _currentJuz < 30) {
      _currentJuz = juz + 1;
    }
    _save();
    notifyListeners();
  }

  void startNewKhatma(String giftedTo) {
    _completedJuz.clear();
    _currentJuz = 1;
    _giftedTo = giftedTo.trim().isEmpty
        ? 'والد صاحب التطبيق رحمه الله'
        : giftedTo.trim();
    _save();
    notifyListeners();
  }

  void addCompletedKhatma(String date) {
    _completedKhatmas.insert(0, {'date': date, 'giftedTo': _giftedTo});
    notifyListeners();
  }
}
