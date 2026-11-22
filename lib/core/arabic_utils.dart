/// أدوات الأرقام العربية.
///
/// الافتراضي في التطبيق كله — حسب طلب محمد — هو الأرقام المشرقية
/// ٠١٢٣٤٥٦٧٨٩، وكل رقم يظهر في أي شاشة لازم يمرّ من هنا.

const List<String> _easternDigits = [
  '٠',
  '١',
  '٢',
  '٣',
  '٤',
  '٥',
  '٦',
  '٧',
  '٨',
  '٩',
];

/// يحوّل الأرقام الإنجليزية في النص إلى أرقام مشرقية ٠١٢٣٤٥٦٧٨٩
/// عندما تكون [eastern] صحيحة، وإلا يعيد النص كما هو.
String formatDigits(String input, bool eastern) {
  if (!eastern) return input;
  final buf = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    final ch = input[i];
    final code = ch.codeUnitAt(0);
    if (code >= 48 && code <= 57) {
      buf.write(_easternDigits[code - 48]);
    } else {
      buf.write(ch);
    }
  }
  return buf.toString();
}

/// يحوّل عددًا صحيحًا إلى نص بالأرقام المشرقية أو الإنجليزية حسب [eastern].
String formatNumber(int value, bool eastern) =>
    formatDigits(value.toString(), eastern);

/// نسبة مئوية كنص، مثل "٢٠٪" أو "20%".
String formatPercent(double value, bool eastern) {
  final rounded = value.toStringAsFixed(0);
  return formatDigits('$rounded٪', eastern);
}
