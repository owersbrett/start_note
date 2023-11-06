class FrequencyWindow {
  final int windowIndex;
  final List<double> magnitudes;
  final List<double> phases;
  final List<double> frequencies;
  final double startTime; // Time in seconds at which this window starts

  FrequencyWindow({
    required this.windowIndex,
    required this.magnitudes,
    required this.phases,
    required this.frequencies,
    required this.startTime,
  });

  // You might want to add methods here to help with analysis, such as a method
  // to get the average magnitude within a certain frequency range.
  double averageMagnitudeInRange(double startFreq, double endFreq) {
    // Calculate the index range for the desired frequency range
    int startIndex = (startFreq / (frequencies[1] - frequencies[0])).round();
    int endIndex = (endFreq / (frequencies[1] - frequencies[0])).round();

    // Sum and average the magnitudes in the range
    double sum = 0.0;
    for (int i = startIndex; i <= endIndex; i++) {
      sum += magnitudes[i];
    }
    return sum / (endIndex - startIndex + 1);
  }
}
