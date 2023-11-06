// import 'dart:math' as Math;

// import 'frequency_window.dart';

// class BpmDetector {
//   static double calculateBpm(List<FrequencyWindow> frequencyWindows, int sampleRate) {
//     // 1. Bandpass Filtering
//     // Assuming frequencyWindows contain the magnitudes for each frequency bin
//     List<double> beatMagnitudes = frequencyWindows
//         .map((window) => window.magnitudes
//             .where((magnitude, index) => window.frequencies[index] >= 40 && window.frequencies[index] <= 100)
//             .reduce(Math.max)) // Get the max magnitude in the beat range
//         .toList();

//     // 2. Onset Detection
//     // This is a simple peak detection algorithm, you might need something more sophisticated
//     List<int> onsets = [];
//     for (int i = 1; i < beatMagnitudes.length - 1; i++) {
//       if (beatMagnitudes[i] > beatMagnitudes[i - 1] && beatMagnitudes[i] > beatMagnitudes[i + 1]) {
//         onsets.add(i);
//       }
//     }

//     // 3. Tempo Estimation
//     // Calculate the intervals between onsets
//     List<int> intervals = [];
//     for (int i = 1; i < onsets.length; i++) {
//       intervals.add(onsets[i] - onsets[i - 1]);
//     }

//     // 4. Peak Picking
//     // This is a placeholder for a more complex peak picking algorithm
//     // You might want to consider a histogram or clustering approach

//     // 5. BPM Calculation
//     // Calculate the average interval in terms of samples
//     double averageInterval = intervals.reduce((a, b) => a + b) / intervals.length;
//     // Convert the average interval to time (seconds)
//     double averageTime = averageInterval / (sampleRate / 2); // divide by sampleRate/2 because of hopSize
//     // Calculate BPM
//     double bpm = 60 / averageTime;

//     return bpm;
//   }
// }
