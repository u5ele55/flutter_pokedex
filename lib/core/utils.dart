List<int> convertToIntListFromString(String raw) {
  List<int> res = [];
  for (String item in raw.substring(1, raw.length - 1).split(', ')) {
    if (int.tryParse(item) != null) res.add(int.tryParse(item)!);
  }
  return res;
}

int? customIntParse(dynamic n) {
  return n is num ? n.toInt() : int.tryParse(n.toString());
}

String toRomanNumber(int n) {
  Map<int, String> table = {
    1000: 'M',
    900: 'CM',
    500: 'D',
    400: 'CD',
    100: 'C',
    50: 'L',
    40: 'XL',
    10: 'X',
    9: 'IX',
    5: 'V',
    4: 'IV',
    1: 'I',
  };

  String res = '';
  final numbers = table.keys.toList();

  for (int t = 0; t < numbers.length; t++) {
    int div = n ~/ numbers[t];
    n %= numbers[t];

    res += table[numbers[t]]! * div;
  }

  return res;
}
