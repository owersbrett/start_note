import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class Uploader {
  

  static Future<File?> pickAndCopyAudioFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    ;
    if (result != null) {
      File originalFile = File(result.files.single.path!);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final copiedFilePath = "$appDocPath/${result.files.single.name}";
      File copiedFile = originalFile.copySync(copiedFilePath);
      return copiedFile;
    }
    return null;
  }

}