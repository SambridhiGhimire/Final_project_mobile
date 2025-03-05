extension IntFormatting on int {
  // Converts an integer to two digits (e.g., 7 -> 07)
  String toTwoDigits() {
    return this < 10 ? '0$this' : '$this';
  }
}

extension DoubleFormatting on double {
  // Converts a double to a string with a fixed number of decimal places
  String toFormattedString({int decimalPlaces = 2}) {
    return toStringAsFixed(decimalPlaces); // e.g., 1.5 -> 1.50
  }
}

extension DoubleRounding on double {
  /// Rounds up the number to two decimal places
  double roundToTwoDecimals() {
    return (this * 100).ceilToDouble() / 100;
  }
}

extension TurnoverFormatter on double {
  String formatTurnOverNotation() {
    // Define the thresholds and corresponding suffixes
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(2)} Ar';
    } else if (this >= 10000000) {
      return '${(this / 10000000).toStringAsFixed(2)} Cr';
    } else if (this >= 100000) {
      return '${(this / 100000).toStringAsFixed(2)} L';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(2)} K';
    } else {
      return toStringAsFixed(2); // Return the original number if less than 1K
    }
  }
}
