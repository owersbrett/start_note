class FrequencyBin {
  final Map<String, List<int>> _frequencyBins = {
    'Strings': [],
    'Percussion': [],
    'Bass': [],
    'Kick': [],
    'Other': []
  };

  final int sampleRate;
  final int fftSize;

  FrequencyBin(this.sampleRate, this.fftSize);

  // Calculate the frequency for a given bin index
  double _frequencyForBin(int bin) {
    return (bin * sampleRate) / fftSize;
  }

  // Add a bin to a category
  void addBinToCategory(String category, int bin) {
    if (_frequencyBins.containsKey(category)) {
      _frequencyBins[category]!.add(bin);
    } else {
      throw ArgumentError('Invalid category: $category');
    }
  }

  // Get the bins for a category
  List<int> getBinsForCategory(String category) {
    if (_frequencyBins.containsKey(category)) {
      return _frequencyBins[category]!;
    } else {
      throw ArgumentError('Invalid category: $category');
    }
  }

  // Initialize the frequency bins for each category based on typical ranges
  void initializeFrequencyBins() {
    // Define the frequency ranges for each category
    Map<String, List<double>> frequencyRanges = {
      'Strings': [500.0, 2000.0], // Example range for strings
      'Percussion': [2000.0, 6000.0], // Example range for percussion
      'Bass': [20.0, 250.0], // Example range for bass
      'Kick': [40.0, 100.0], // Target range for kick drums
      'Other': [100.0, 500.0], // Example range for other instruments
    };

    // Calculate the bin indices for each range and add them to the map
    frequencyRanges.forEach((category, range) {
      int binMin = (range[0] / sampleRate * fftSize).floor();
      int binMax = (range[1] / sampleRate * fftSize).ceil();
      for (int bin = binMin; bin <= binMax; bin++) {
        addBinToCategory(category, bin);
      }
    });
  }
}
