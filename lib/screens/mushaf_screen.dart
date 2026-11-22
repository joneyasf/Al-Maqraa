import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/quran_data.dart';
import '../state/app_state.dart';
import '../widgets/app_card.dart';
import '../widgets/app_scope.dart';

/// قارئ المصحف: 604 صفحات، نص عثماني، أرقام الآيات والصفحات
/// مشرقية ٠١٢٣ افتراضيًا (من AppState).
/// الصفحات 1 و601–604 مضمّنة أوفلاين، وباقي الصفحات تُحمَّل أول مرة
/// من الإنترنت ثم تُحفظ في الذاكرة.
class MushafScreen extends StatefulWidget {
  const MushafScreen({super.key});

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  late int _page;
  Future<List<AyahLine>>? _future;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _page = AppScope.read(context).app.lastPage;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _loadPage(_page);
    }
  }

  void _loadPage(int page) {
    final clamped = page.clamp(1, 604);
    setState(() {
      _page = clamped;
      _future = QuranPageService.fetchPage(clamped);
    });
    AppScope.read(context).app.setLastPage(clamped);
  }

  void _openSurahPicker() {
    final app = AppScope.read(context).app;
    var query = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = kSurahs.where((s) {
              if (query.isEmpty) return true;
              return s.name.contains(query) ||
                  s.number.toString() == query.trim();
            }).toList();
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(sheetContext).size.height * 0.75,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'ابحث عن سورة',
                          prefixIcon: Icon(Icons.search_rounded),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) =>
                            setSheetState(() => query = v.trim()),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final s = filtered[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.gold,
                              child: Text(
                                app.fmt(s.number),
                                style: cairo(
                                  size: 15,
                                  weight: 800,
                                  color: AppColors.deepGreen,
                                ),
                              ),
                            ),
                            title: Text(
                              'سورة ${s.name}',
                              style: cairo(size: 17, weight: 700),
                            ),
                            subtitle: Text(
                              '${s.revelation} — ${app.fmt(s.ayahs)} آية — صفحة ${app.fmt(s.startPage)}',
                              style: cairo(size: 13),
                            ),
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              _loadPage(s.startPage);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openJuzPicker() {
    final app = AppScope.read(context).app;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            itemCount: 30,
            itemBuilder: (context, i) {
              final juz = i + 1;
              final active = juzForPage(_page) == juz;
              return InkWell(
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _loadPage(juzStartPage(juz));
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.gold
                        : AppColors.card(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'جزء ${app.fmt(juz)}',
                    style: cairo(
                      size: 14,
                      weight: 800,
                      color: active
                          ? AppColors.deepGreen
                          : AppColors.text(context),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _openGoToPage() {
    final app = AppScope.read(context).app;
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'اذهب إلى صفحة',
            style: cairo(size: 18, weight: 800),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'رقم الصفحة (${app.fmt(1)} – ${app.fmt(604)})',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final page = int.tryParse(controller.text.trim());
                Navigator.of(dialogContext).pop();
                if (page != null) _loadPage(page);
              },
              child: const Text('اذهب'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context).app;
    final surah = surahForPage(_page);
    final juz = juzForPage(_page);
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'المصحف',
              style: amiri(size: 24, bold: true),
            ),
            actions: [
              IconButton(
                tooltip: app.easternNumerals
                    ? 'الأرقام مشرقية ٠١٢٣'
                    : 'الأرقام إنجليزية 123',
                onPressed: app.toggleNumerals,
                icon: Text(
                  app.easternNumerals ? '٠١٢٣' : '123',
                  style: cairo(
                    size: 15,
                    weight: 800,
                    color: AppColors.gold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'ابحث عن سورة',
                onPressed: _openSurahPicker,
                icon: const Icon(Icons.search_rounded),
              ),
              IconButton(
                tooltip: 'إشارة مرجعية',
                onPressed: () {
                  app.toggleBookmark(_page);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        app.isBookmarked(_page)
                            ? 'تم حفظ الصفحة في الإشارات'
                            : 'تم حذف الصفحة من الإشارات',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  app.isBookmarked(_page)
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: AppCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'صفحة ${app.fmt(_page)} — الجزء ${app.fmt(juz)} — سورة ${surah.name}',
                          style: cairo(
                            size: 15,
                            weight: 700,
                            color: AppColors.text(context),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _openJuzPicker,
                        child: Text(
                          'الأجزاء',
                          style: cairo(
                            size: 14,
                            weight: 700,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<AyahLine>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.gold,
                        ),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: AppCard(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.wifi_off_rounded,
                                  size: 40,
                                  color: AppColors.gold,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'تعذّر تحميل نص هذه الصفحة',
                                  style: cairo(size: 17, weight: 800),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'الصفحات 1 و601–604 تعمل بدون إنترنت، وباقي الصفحات تُحمَّل أول مرة من الإنترنت ثم تُحفظ.',
                                  style: cairo(size: 14),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => _loadPage(_page),
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    final lines = snapshot.data!;
                    return _pageView(context, app, lines);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            _page > 1 ? () => _loadPage(_page - 1) : null,
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('السابقة'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _openGoToPage,
                      child: Text(
                        'صفحة ${app.fmt(_page)}',
                        style: cairo(size: 15, weight: 800),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _page < 604
                            ? () => _loadPage(_page + 1)
                            : null,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('التالية'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pageView(
    BuildContext context,
    AppState app,
    List<AyahLine> lines,
  ) {
    final fontSize = 22.0 * app.fontScale;
    final widgets = <Widget>[];
    var currentSurah = -1;
    for (final line in lines) {
      if (line.surahNumber != currentSurah) {
        currentSurah = line.surahNumber;
        final info = surahByNumber(line.surahNumber);
        widgets.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12, top: 8),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold),
            ),
            child: Text(
              'سورة ${info.name} — ${info.revelation} — ${app.fmt(info.ayahs)} آية',
              textAlign: TextAlign.center,
              style: amiri(size: 22, bold: true, color: AppColors.gold),
            ),
          ),
        );
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RichText(
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: amiri(
                size: fontSize,
                color: AppColors.text(context),
                height: 2.0,
              ),
              children: [
                TextSpan(text: line.text),
                TextSpan(
                  text: ' ﴿${app.fmt(line.ayahNumber)}﴾ ',
                  style: amiri(
                    size: fontSize - 2,
                    bold: true,
                    color: AppColors.gold,
                    height: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      children: widgets,
    );
  }
}
