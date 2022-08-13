import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';

class BlocService {
  static final BlocService _blocService = BlocService._internal();

  factory BlocService() {
    return _blocService;
  }
  BlocService._internal();
  static Future<HydratedStorage> initialize() async {
    Directory hydratedBlocStore = Directory.systemTemp;
    return HydratedStorage.build(storageDirectory: hydratedBlocStore);
  }
}

