import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'app.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial(0)) {
    on(_onEvent);
  }
  void _onEvent(AppEvent event, Emitter<AppState> emit) async {
    if (event is FetchApp) await _fetchApp(event, emit);
    if (event is TabBarTapped) await _tabBarTapped(event, emit);
  }

  Future<void> _fetchApp(FetchApp event, Emitter<AppState> emit) async {}
  Future<void> _tabBarTapped(TabBarTapped event, Emitter<AppState> emit) async {
    emit(AppLoaded(event.newIndex));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) => AppState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AppState state) => state.toMap();
}
