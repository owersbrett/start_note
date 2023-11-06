import 'dart:math' as Math;
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:fftea/fftea.dart';

import 'package:path_provider/path_provider.dart';
import 'package:start_note/services/sound/frequency_bin.dart';
import 'package:start_note/services/sound/frequency_window.dart';

class AudioAnalysisService {
  FrequencyBin? frequencyBin;
  static int sampleRate = 44100;
  AudioAnalysisService();
  static Future<int> getBpm(File file, String uuid) async {
    int bpm = 120;
    List<FrequencyWindow> frequencyWindows =
        await getFrequencyWindowsOfFile(file, uuid);
    // await FFmpegKit.execute('-i "${file.path}" "$outputWavPath" -y');

    return bpm;
  }

  static Future<List<FrequencyWindow>> getFrequencyWindowsOfFile(
      File file, String uuid) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String outputWavPath = dir.path + "/$uuid.wav";
    String outputPcmPath = dir.path + "/$uuid.pcm";

    await FFmpegKit.execute(
        'ffmpeg -i ${file.path} -acodec pcm_s16le -ar 44100 $outputWavPath -y');
    await FFmpegKit.execute(
        'ffmpeg -i $outputWavPath -f s16le -acodec pcm_s16le $outputPcmPath -y');
    // File wavFile = File(outputWavPath);
    File pcmFile = File(outputPcmPath);
    Uint8List pcmBytes = await pcmFile.readAsBytes();
    return processPCMData(pcmBytes, sampleRate);
  }

  static List<FrequencyWindow> processPCMData(
      Uint8List pcmData, int sampleRate) {
    int windowSize = (sampleRate * .5).round();
    int hopSize = windowSize ~/ 2;
    List<FrequencyWindow> frequencyWindows = [];

    for (int start = 0;
        start + windowSize <= pcmData.length;
        start += hopSize) {
      Uint8List segment = pcmData.sublist(start, start + windowSize);
      List<double> segmentDouble =
          applyHanningWindow(uint8ListToDoubleList(segment), sampleRate);
      Float64x2List fftResult = performFFT(segmentDouble, segmentDouble.length);
      FrequencyWindow frequencyWindow =
          analyzeFft(fftResult, segment.length, sampleRate, start, windowSize);
      frequencyWindows.add(frequencyWindow);
    }
    return frequencyWindows;
  }

  static List<double> uint8ListToDoubleList(Uint8List uint8List) {
    // Assuming 16-bit PCM data, little endian
    int length = uint8List.length ~/ 2;
    List<double> doubleList = List<double>.filled(length, 0.0);

    for (int i = 0; i < length; i++) {
      // Combine two bytes to form one 16-bit sample, taking endianness into account
      int sample = (uint8List[i * 2 + 1] << 8) | uint8List[i * 2];
      // Convert to signed value
      sample = (sample & 0x8000) != 0 ? sample - 0x10000 : sample;
      // Normalize to range -1.0 to 1.0
      doubleList[i] = sample / 32768.0;
    }

    return doubleList;
  }

  static FrequencyWindow analyzeFft(Float64x2List fftResult, int fftSize,
      int sampleRate, int windowIndex, int windowDuration) {
    int fftLength = fftResult.length;
    List<double> magnitudes = [];
    List<double> phases = [];
    List<double> frequencies = [];

    for (int i = 0; i < fftLength; i++) {
      // Calculate magnitude
      double magnitude = Math.sqrt(
          fftResult[i].x * fftResult[i].x + fftResult[i].y * fftResult[i].y);
      magnitudes.add(magnitude);

      // Calculate phase
      double phase = Math.atan2(fftResult[i].y, fftResult[i].x);
      phases.add(phase);

      // Calculate frequency for this bin
      double frequency = (sampleRate / fftLength) * i;
      frequencies.add(frequency);
    }
    double startTime = (windowIndex / sampleRate)
        .toDouble(); // Calculate the start time based on the hop size

    FrequencyWindow frequencyWindow = FrequencyWindow(
      windowIndex: windowIndex,
      magnitudes: magnitudes,
      phases: phases,
      frequencies: frequencies,
      startTime: startTime,
    );
    return frequencyWindow;

    // Now you have the magnitudes, phases, and frequencies
    // You can process these further depending on what you need to do
    // For example, you might want to find the peak frequencies, or filter out noise
  }

  static List<double> convertPcmToDouble(Uint8List pcmData) {
    Int16List int16List = Int16List.view(pcmData.buffer);
    List<double> floatList = int16List.map((val) => val / 32768.0).toList();
    return floatList;
  }

  static int nearestPowerOfTwo(int size) {
    return Math.pow(2, (Math.log(size) / Math.log(2)).ceil()).toInt();
  }

  static Float64x2List performFFT(List<double> pcmData, int fftLength) {
    // Ensure the pcmData length is a power of two for the FFT
    pcmData = pcmData.take(fftLength).toList();

    // Pad the rest with zeros if necessary
    if (pcmData.length < fftLength) {
      pcmData.addAll(List<double>.filled(fftLength - pcmData.length, 0.0));
    }

    // Create a Float64x2List from the PCM data

    final fft = FFT(fftLength);
    return fft.realFft(pcmData);
  }

  static List<double> applyHanningWindow(List<double> pcmData, int sampleRate) {
    // Calculate the number of samples for a 500ms window
    int windowLength = (sampleRate * 0.5).round();

    // Generate the Hanning window coefficients
    List<double> windowCoefficients = List.generate(windowLength, (i) {
      return 0.5 * (1 - Math.cos((2 * Math.pi * i) / (windowLength - 1)));
    });

    // Apply the window coefficients to the PCM data
    List<double> windowedData = List<double>.filled(windowLength, 0.0);
    for (int i = 0; i < windowLength; i++) {
      windowedData[i] = pcmData[i] * windowCoefficients[i];
    }

    return windowedData;
  }
}
