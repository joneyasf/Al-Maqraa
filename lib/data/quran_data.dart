import 'dart:convert';

import 'package:http/http.dart' as http;

/// بيانات حقيقية للمصحف المدني: أسماء السور وعدد آياتها وصفحة بدايتها
/// ونوعها (مكية/مدنية)، وبدايات الأجزاء الثلاثين.
/// مصدر الأرقام: المصحف المدني 604 صفحات.

class SurahInfo {
  const SurahInfo(this.number, this.name, this.ayahs, this.startPage, this.revelation);

  final int number;
  final String name;
  final int ayahs;
  final int startPage;
  final String revelation;
}

const List<SurahInfo> kSurahs = [
  SurahInfo(1, 'الفاتحة', 7, 1, 'مكية'),
  SurahInfo(2, 'البقرة', 286, 2, 'مدنية'),
  SurahInfo(3, 'آل عمران', 200, 50, 'مدنية'),
  SurahInfo(4, 'النساء', 176, 77, 'مدنية'),
  SurahInfo(5, 'المائدة', 120, 106, 'مدنية'),
  SurahInfo(6, 'الأنعام', 165, 128, 'مكية'),
  SurahInfo(7, 'الأعراف', 206, 151, 'مكية'),
  SurahInfo(8, 'الأنفال', 75, 177, 'مدنية'),
  SurahInfo(9, 'التوبة', 129, 187, 'مدنية'),
  SurahInfo(10, 'يونس', 109, 208, 'مكية'),
  SurahInfo(11, 'هود', 123, 221, 'مكية'),
  SurahInfo(12, 'يوسف', 111, 235, 'مكية'),
  SurahInfo(13, 'الرعد', 43, 249, 'مدنية'),
  SurahInfo(14, 'إبراهيم', 52, 255, 'مكية'),
  SurahInfo(15, 'الحجر', 99, 262, 'مكية'),
  SurahInfo(16, 'النحل', 128, 267, 'مكية'),
  SurahInfo(17, 'الإسراء', 111, 282, 'مكية'),
  SurahInfo(18, 'الكهف', 110, 293, 'مكية'),
  SurahInfo(19, 'مريم', 98, 305, 'مكية'),
  SurahInfo(20, 'طه', 135, 312, 'مكية'),
  SurahInfo(21, 'الأنبياء', 112, 322, 'مكية'),
  SurahInfo(22, 'الحج', 78, 332, 'مدنية'),
  SurahInfo(23, 'المؤمنون', 118, 342, 'مكية'),
  SurahInfo(24, 'النور', 64, 350, 'مدنية'),
  SurahInfo(25, 'الفرقان', 77, 359, 'مكية'),
  SurahInfo(26, 'الشعراء', 227, 367, 'مكية'),
  SurahInfo(27, 'النمل', 93, 377, 'مكية'),
  SurahInfo(28, 'القصص', 88, 385, 'مكية'),
  SurahInfo(29, 'العنكبوت', 69, 396, 'مكية'),
  SurahInfo(30, 'الروم', 60, 404, 'مكية'),
  SurahInfo(31, 'لقمان', 34, 411, 'مكية'),
  SurahInfo(32, 'السجدة', 30, 415, 'مكية'),
  SurahInfo(33, 'الأحزاب', 73, 418, 'مدنية'),
  SurahInfo(34, 'سبأ', 54, 428, 'مكية'),
  SurahInfo(35, 'فاطر', 45, 434, 'مكية'),
  SurahInfo(36, 'يس', 83, 440, 'مكية'),
  SurahInfo(37, 'الصافات', 182, 446, 'مكية'),
  SurahInfo(38, 'ص', 88, 453, 'مكية'),
  SurahInfo(39, 'الزمر', 75, 458, 'مكية'),
  SurahInfo(40, 'غافر', 85, 467, 'مكية'),
  SurahInfo(41, 'فصلت', 54, 477, 'مكية'),
  SurahInfo(42, 'الشورى', 53, 483, 'مكية'),
  SurahInfo(43, 'الزخرف', 89, 489, 'مكية'),
  SurahInfo(44, 'الدخان', 59, 496, 'مكية'),
  SurahInfo(45, 'الجاثية', 37, 499, 'مكية'),
  SurahInfo(46, 'الأحقاف', 35, 502, 'مكية'),
  SurahInfo(47, 'محمد', 38, 507, 'مدنية'),
  SurahInfo(48, 'الفتح', 29, 511, 'مدنية'),
  SurahInfo(49, 'الحجرات', 18, 515, 'مدنية'),
  SurahInfo(50, 'ق', 45, 518, 'مكية'),
  SurahInfo(51, 'الذاريات', 60, 520, 'مكية'),
  SurahInfo(52, 'الطور', 49, 523, 'مكية'),
  SurahInfo(53, 'النجم', 62, 526, 'مكية'),
  SurahInfo(54, 'القمر', 55, 528, 'مكية'),
  SurahInfo(55, 'الرحمن', 78, 531, 'مدنية'),
  SurahInfo(56, 'الواقعة', 96, 534, 'مكية'),
  SurahInfo(57, 'الحديد', 29, 537, 'مدنية'),
  SurahInfo(58, 'المجادلة', 22, 542, 'مدنية'),
  SurahInfo(59, 'الحشر', 24, 545, 'مدنية'),
  SurahInfo(60, 'الممتحنة', 13, 549, 'مدنية'),
  SurahInfo(61, 'الصف', 14, 551, 'مدنية'),
  SurahInfo(62, 'الجمعة', 11, 553, 'مدنية'),
  SurahInfo(63, 'المنافقون', 11, 554, 'مدنية'),
  SurahInfo(64, 'التغابن', 18, 555, 'مدنية'),
  SurahInfo(65, 'الطلاق', 12, 558, 'مدنية'),
  SurahInfo(66, 'التحريم', 12, 560, 'مدنية'),
  SurahInfo(67, 'الملك', 30, 562, 'مكية'),
  SurahInfo(68, 'القلم', 52, 564, 'مكية'),
  SurahInfo(69, 'الحاقة', 52, 566, 'مكية'),
  SurahInfo(70, 'المعارج', 44, 568, 'مكية'),
  SurahInfo(71, 'نوح', 28, 570, 'مكية'),
  SurahInfo(72, 'الجن', 28, 572, 'مكية'),
  SurahInfo(73, 'المزمل', 20, 574, 'مكية'),
  SurahInfo(74, 'المدثر', 56, 575, 'مكية'),
  SurahInfo(75, 'القيامة', 40, 577, 'مكية'),
  SurahInfo(76, 'الإنسان', 31, 578, 'مدنية'),
  SurahInfo(77, 'المرسلات', 50, 580, 'مكية'),
  SurahInfo(78, 'النبأ', 40, 582, 'مكية'),
  SurahInfo(79, 'النازعات', 46, 583, 'مكية'),
  SurahInfo(80, 'عبس', 42, 585, 'مكية'),
  SurahInfo(81, 'التكوير', 29, 586, 'مكية'),
  SurahInfo(82, 'الانفطار', 19, 587, 'مكية'),
  SurahInfo(83, 'المطففين', 36, 587, 'مكية'),
  SurahInfo(84, 'الانشقاق', 25, 589, 'مكية'),
  SurahInfo(85, 'البروج', 22, 590, 'مكية'),
  SurahInfo(86, 'الطارق', 17, 591, 'مكية'),
  SurahInfo(87, 'الأعلى', 19, 591, 'مكية'),
  SurahInfo(88, 'الغاشية', 26, 592, 'مكية'),
  SurahInfo(89, 'الفجر', 30, 593, 'مكية'),
  SurahInfo(90, 'البلد', 20, 594, 'مكية'),
  SurahInfo(91, 'الشمس', 15, 595, 'مكية'),
  SurahInfo(92, 'الليل', 21, 595, 'مكية'),
  SurahInfo(93, 'الضحى', 11, 596, 'مكية'),
  SurahInfo(94, 'الشرح', 8, 596, 'مكية'),
  SurahInfo(95, 'التين', 8, 597, 'مكية'),
  SurahInfo(96, 'العلق', 19, 597, 'مكية'),
  SurahInfo(97, 'القدر', 5, 598, 'مكية'),
  SurahInfo(98, 'البينة', 8, 598, 'مدنية'),
  SurahInfo(99, 'الزلزلة', 8, 599, 'مدنية'),
  SurahInfo(100, 'العاديات', 11, 599, 'مكية'),
  SurahInfo(101, 'القارعة', 11, 600, 'مكية'),
  SurahInfo(102, 'التكاثر', 8, 600, 'مكية'),
  SurahInfo(103, 'العصر', 3, 601, 'مكية'),
  SurahInfo(104, 'الهمزة', 9, 601, 'مكية'),
  SurahInfo(105, 'الفيل', 5, 601, 'مكية'),
  SurahInfo(106, 'قريش', 4, 602, 'مكية'),
  SurahInfo(107, 'الماعون', 7, 602, 'مكية'),
  SurahInfo(108, 'الكوثر', 3, 602, 'مكية'),
  SurahInfo(109, 'الكافرون', 6, 603, 'مكية'),
  SurahInfo(110, 'النصر', 3, 603, 'مدنية'),
  SurahInfo(111, 'المسد', 5, 603, 'مكية'),
  SurahInfo(112, 'الإخلاص', 4, 604, 'مكية'),
  SurahInfo(113, 'الفلق', 5, 604, 'مكية'),
  SurahInfo(114, 'الناس', 6, 604, 'مكية'),
];

SurahInfo surahByNumber(int number) =>
    kSurahs.firstWhere((s) => s.number == number, orElse: () => kSurahs.first);

/// السورة التي تبدأ فيها الصفحة، أو السورة التي تحتويها.
SurahInfo surahForPage(int page) {
  SurahInfo result = kSurahs.first;
  for (final s in kSurahs) {
    if (s.startPage <= page) {
      result = s;
    } else {
      break;
    }
  }
  return result;
}

/// كل السور التي تبدأ في هذه الصفحة.
List<SurahInfo> surahsStartingOnPage(int page) =>
    kSurahs.where((s) => s.startPage == page).toList();

class JuzInfo {
  const JuzInfo(this.number, this.startPage, this.startSurah, this.startAyah);

  final int number;
  final int startPage;
  final int startSurah;
  final int startAyah;
}

const List<JuzInfo> kJuz = [
  JuzInfo(1, 1, 1, 1),
  JuzInfo(2, 22, 2, 142),
  JuzInfo(3, 42, 2, 253),
  JuzInfo(4, 62, 3, 93),
  JuzInfo(5, 82, 4, 24),
  JuzInfo(6, 102, 4, 148),
  JuzInfo(7, 122, 5, 82),
  JuzInfo(8, 142, 6, 111),
  JuzInfo(9, 162, 7, 88),
  JuzInfo(10, 182, 8, 41),
  JuzInfo(11, 202, 9, 93),
  JuzInfo(12, 222, 11, 6),
  JuzInfo(13, 242, 12, 53),
  JuzInfo(14, 262, 15, 1),
  JuzInfo(15, 282, 17, 1),
  JuzInfo(16, 302, 18, 75),
  JuzInfo(17, 322, 21, 1),
  JuzInfo(18, 342, 23, 1),
  JuzInfo(19, 362, 25, 21),
  JuzInfo(20, 382, 27, 56),
  JuzInfo(21, 402, 29, 46),
  JuzInfo(22, 422, 33, 31),
  JuzInfo(23, 442, 36, 28),
  JuzInfo(24, 462, 39, 32),
  JuzInfo(25, 482, 41, 47),
  JuzInfo(26, 502, 46, 1),
  JuzInfo(27, 522, 51, 31),
  JuzInfo(28, 542, 58, 1),
  JuzInfo(29, 562, 67, 1),
  JuzInfo(30, 582, 78, 1),
];

int juzForPage(int page) {
  var result = 1;
  for (final j in kJuz) {
    if (j.startPage <= page) {
      result = j.number;
    } else {
      break;
    }
  }
  return result;
}

int juzStartPage(int juz) => kJuz[juz - 1].startPage;

int juzEndPage(int juz) =>
    juz >= 30 ? 604 : kJuz[juz].startPage - 1;

/// نصوص مضمّنة أوفلاين: الفاتحة والسور القصيرة من العصر إلى الناس.
/// باقي الصفحات تُحمَّل من AlQuran Cloud أول مرة وتُحفظ في الذاكرة.
const Map<int, List<String>> kBundledSurahText = {
  1: [
    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    'الرَّحْمَٰنِ الرَّحِيمِ',
    'مَالِكِ يَوْمِ الدِّينِ',
    'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
  ],
  103: [
    'وَالْعَصْرِ',
    'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ',
    'إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ',
  ],
  104: [
    'وَيْلٌ لِّكُلِّ هُمَزَةٍ لُّمَزَةٍ',
    'الَّذِي جَمَعَ مَالًا وَعَدَّدَهُ',
    'يَحْسَبُ أَنَّ مَالَهُ أَخْلَدَهُ',
    'كَلَّا ۖ لَيُنبَذَنَّ فِي الْحُطَمَةِ',
    'وَمَا أَدْرَاكَ مَا الْحُطَمَةُ',
    'نَارُ اللَّهِ الْمُوقَدَةُ',
    'الَّتِي تَطَّلِعُ عَلَى الْأَفْئِدَةِ',
    'إِنَّهَا عَلَيْهِم مُّؤْصَدَةٌ',
    'فِي عَمَدٍ مُّمَدَّدَةٍ',
  ],
  105: [
    'أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِأَصْحَابِ الْفِيلِ',
    'أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ',
    'وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ',
    'تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ',
    'فَجَعَلَهُمْ كَعَصْفٍ مَّأْكُولٍ',
  ],
  106: [
    'لِإِيلَافِ قُرَيْشٍ',
    'إِيلَافِهِمْ رِحْلَةَ الشِّتَاءِ وَالصَّيْفِ',
    'فَلْيَعْبُدُوا رَبَّ هَٰذَا الْبَيْتِ',
    'الَّذِي أَطْعَمَهُم مِّن جُوعٍ وَآمَنَهُم مِّنْ خَوْفٍ',
  ],
  107: [
    'أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ',
    'فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ',
    'وَلَا يَحُضُّ عَلَىٰ طَعَامِ الْمِسْكِينِ',
    'فَوَيْلٌ لِّلْمُصَلِّينَ',
    'الَّذِينَ هُمْ عَن صَلَاتِهِمْ سَاهُونَ',
    'الَّذِينَ هُمْ يُرَاءُونَ',
    'وَيَمْنَعُونَ الْمَاعُونَ',
  ],
  108: [
    'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
    'فَصَلِّ لِرَبِّكَ وَانْحَرْ',
    'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ',
  ],
  109: [
    'قُلْ يَا أَيُّهَا الْكَافِرُونَ',
    'لَا أَعْبُدُ مَا تَعْبُدُونَ',
    'وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ',
    'وَلَا أَنَا عَابِدٌ مَّا عَبَدتُّمْ',
    'وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ',
    'لَكُمْ دِينُكُمْ وَلِيَ دِينِ',
  ],
  110: [
    'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ',
    'وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا',
    'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ ۚ إِنَّهُ كَانَ تَوَّابًا',
  ],
  111: [
    'تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ',
    'مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ',
    'سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ',
    'وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ',
    'فِي جِيدِهَا حَبْلٌ مِّن مَّسَدٍ',
  ],
  112: [
    'قُلْ هُوَ اللَّهُ أَحَدٌ',
    'اللَّهُ الصَّمَدُ',
    'لَمْ يَلِدْ وَلَمْ يُولَدْ',
    'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
  ],
  113: [
    'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
    'مِن شَرِّ مَا خَلَقَ',
    'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ',
    'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',
    'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
  ],
  114: [
    'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
    'مَلِكِ النَّاسِ',
    'إِلَٰهِ النَّاسِ',
    'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
    'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',
    'مِنَ الْجِنَّةِ وَالنَّاسِ',
  ],
};

/// السور المضمّنة في كل صفحة من الصفحات الأوفلاين.
const Map<int, List<int>> kBundledPages = {
  1: [1],
  601: [103, 104, 105],
  602: [106, 107, 108],
  603: [109, 110, 111],
  604: [112, 113, 114],
};

/// سطر آية من صفحة.
class AyahLine {
  const AyahLine({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.text,
  });

  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String text;
}

/// يجلب نص صفحة من AlQuran Cloud ويحفظه في الذاكرة.
/// الصفحات المضمّنة (1 و601–604) تعمل بدون إنترنت أبدًا.
class QuranPageService {
  QuranPageService._();

  static final Map<int, List<AyahLine>> _cache = {};

  static List<AyahLine>? bundledPage(int page) {
    final surahs = kBundledPages[page];
    if (surahs == null) return null;
    final lines = <AyahLine>[];
    for (final n in surahs) {
      final info = surahByNumber(n);
      final texts = kBundledSurahText[n] ?? const <String>[];
      for (var i = 0; i < texts.length; i++) {
        lines.add(
          AyahLine(
            surahNumber: n,
            surahName: info.name,
            ayahNumber: i + 1,
            text: texts[i],
          ),
        );
      }
    }
    return lines;
  }

  static Future<List<AyahLine>> fetchPage(int page) async {
    if (_cache.containsKey(page)) return _cache[page]!;
    final bundled = bundledPage(page);
    if (bundled != null) {
      _cache[page] = bundled;
      return bundled;
    }
    final uri = Uri.parse(
      'https://api.alquran.cloud/v1/page/$page/quran-uthmani',
    );
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('تعذّر تحميل الصفحة $page');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final ayahs = (data['data'] as Map<String, dynamic>)['ayahs'] as List;
    final lines = <AyahLine>[];
    for (final raw in ayahs) {
      final item = raw as Map<String, dynamic>;
      final surah = item['surah'] as Map<String, dynamic>;
      lines.add(
        AyahLine(
          surahNumber: surah['number'] as int,
          surahName: surah['name'] as String,
          ayahNumber: item['numberInSurah'] as int,
          text: item['text'] as String,
        ),
      );
    }
    _cache[page] = lines;
    return lines;
  }
}
