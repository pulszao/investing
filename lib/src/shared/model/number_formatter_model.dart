class NumberFormatter {
  /// number to be formatted
  final double number;

  /// current value separator
  final String separator;

  /// decimal string separator
  final String decimalSeparator;

  /// thousand string separator
  final String thousandSeparator;

  /// thousand string separator
  final String coinName;

  /// number of decimal places
  final int decimalPlaces;

  /// e.g. in case of 'int' do not display decimal digits
  final bool displayDecimal;

  NumberFormatter({
    required this.number,
    this.separator = '.',
    this.decimalSeparator = ',',
    this.thousandSeparator = '.',
    this.coinName = '\$',
    this.decimalPlaces = 2,
    this.displayDecimal = true,
  });

  String formatNumber() {
    List number = this.number.toString().split(separator);
    String decimalNumbers = number.last;
    List auxDecimalNumbers = [];

    String hole = number.first;
    List holeNumbers = hole.split('');
    List auxHoleNumbers = List.from(holeNumbers.reversed);

    for (int i = 3; auxHoleNumbers.length > i; i += 4) {
      auxHoleNumbers.insert(i, thousandSeparator);
    }

    for (int i = 0; decimalPlaces > i; i++) {
      try {
        auxDecimalNumbers.add(decimalNumbers.split('')[i]);
      } catch (e) {
        auxDecimalNumbers.add(0);
      }
    }

    holeNumbers = List.from(auxHoleNumbers.reversed);
    hole = holeNumbers.join();

    decimalNumbers = auxDecimalNumbers.join();

    if (displayDecimal) {
      hole = '$hole$decimalSeparator$decimalNumbers';
    }

    return '$coinName $hole';
  }
}
