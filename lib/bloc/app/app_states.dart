import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  AppState(this.mostRecentNotePageTabIndex);
  static final String mostRecentNotePageTabIndexKey = "mostRecentNotePageTableIndex";
  final int mostRecentNotePageTabIndex;

  Map<String, String> toMap() {
    Map<String, String> map = {};
    map[mostRecentNotePageTabIndexKey] = mostRecentNotePageTabIndex.toString();
    return map;
  }

  static AppState fromJson(Map<String, dynamic> json){
    int mostRecentNotePageTabIndex = json[mostRecentNotePageTabIndexKey];
    return AppLoaded(mostRecentNotePageTabIndex);
  }

  @override
  List<Object> get props => [mostRecentNotePageTabIndex];
}

class AppInitial extends AppState {
  AppInitial(super.mostRecentNotePageTabIndex);
}

class AppLoaded extends AppState {
  AppLoaded(super.mostRecentNotePageTabIndex);
}
