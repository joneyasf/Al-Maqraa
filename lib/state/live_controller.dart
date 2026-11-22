import 'dart:async';

import 'package:flutter/foundation.dart';

import 'app_state.dart';

/// عضو في المقرأة.
class Member {
  Member({
    required this.name,
    required this.role,
    this.isSheikh = false,
    this.streak = 0,
    this.pagesRead = 0,
    this.present = true,
    this.handRaised = false,
    this.micOn = true,
    this.videoOn = false,
  });

  final String name;
  final String role;
  final bool isSheikh;
  int streak;
  int pagesRead;
  bool present;
  bool handRaised;
  bool micOn;
  bool videoOn;
}

/// حالة الجلسة الحية: الدخول، الميك، الكاميرا، الدور، الصفحة الحالية.
class LiveController extends ChangeNotifier {
  LiveController(this.app);

  final AppState app;

  bool inSession = false;
  bool micOn = true;

  /// الكاميرا مغلقة افتراضيًا للجميع ما عدا الشيخ.
  bool videoOn = false;
  bool handRaised = false;
  bool isSheikh = false;

  /// محمد هو القارئ الحالي في بيانات العرض.
  int currentReaderIndex = 1;

  /// الليلة: الجزء 7، سورة المائدة من آية 82، صفحة 122.
  int currentPage = 122;
  String currentSurah = 'المائدة';
  int currentAyah = 82;

  Duration elapsed = Duration.zero;
  Timer? _timer;

  final List<Member> members = [
    Member(
      name: 'الشيخ',
      role: 'شيخ المقرأة',
      isSheikh: true,
      streak: 45,
      pagesRead: 1200,
      videoOn: true,
    ),
    Member(name: 'محمد', role: 'قارئ', streak: 12, pagesRead: 342),
    Member(name: 'أحمد', role: 'قارئ', streak: 10, pagesRead: 298),
    Member(name: 'عبدالله', role: 'قارئ', streak: 8, pagesRead: 210),
    Member(name: 'خالد', role: 'مستمع', streak: 6, pagesRead: 120),
    Member(name: 'مصطفى', role: 'قارئ', streak: 5, pagesRead: 96),
    Member(name: 'يوسف', role: 'مستمع', streak: 4, pagesRead: 64),
    Member(name: 'عمر', role: 'مستمع', streak: 3, pagesRead: 41),
  ];

  Member get currentReader => members[currentReaderIndex];

  Member get nextReader =>
      members[(currentReaderIndex + 1) % members.length];

  Member get afterNextReader =>
      members[(currentReaderIndex + 2) % members.length];

  Member get sheikh =>
      members.firstWhere((m) => m.isSheikh, orElse: () => members.first);

  /// رقم الدور الحالي بالأرقام المشرقية افتراضيًا (من AppState).
  String get turnLabel => app.fmt(currentReaderIndex + 1);

  void join() {
    if (inSession) return;
    inSession = true;
    elapsed = Duration.zero;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed += const Duration(seconds: 1);
      notifyListeners();
    });
    notifyListeners();
  }

  void leave() {
    inSession = false;
    handRaised = false;
    _timer?.cancel();
    _timer = null;
    elapsed = Duration.zero;
    notifyListeners();
  }

  void toggleMic() {
    micOn = !micOn;
    notifyListeners();
  }

  void toggleVideo() {
    videoOn = !videoOn;
    notifyListeners();
  }

  void toggleHand() {
    handRaised = !handRaised;
    notifyListeners();
  }

  void setSheikhMode(bool value) {
    isSheikh = value;
    if (value) videoOn = true;
    notifyListeners();
  }

  void advanceTurn() {
    currentReaderIndex = (currentReaderIndex + 1) % members.length;
    notifyListeners();
  }

  void setCurrentPage(int page, String surah, int ayah) {
    currentPage = page;
    currentSurah = surah;
    currentAyah = ayah;
    notifyListeners();
  }

  void toggleMemberHand(int index) {
    members[index].handRaised = !members[index].handRaised;
    notifyListeners();
  }

  void toggleMemberPresent(int index) {
    members[index].present = !members[index].present;
    notifyListeners();
  }

  void addMember(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return;
    members.add(Member(name: clean, role: 'مستمع'));
    notifyListeners();
  }

  void removeMember(int index) {
    if (index <= 0 || index >= members.length) return;
    members.removeAt(index);
    if (currentReaderIndex >= members.length) currentReaderIndex = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
