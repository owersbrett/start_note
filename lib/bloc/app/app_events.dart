abstract class AppEvent {
  const AppEvent();
}

class FetchApp extends AppEvent {}

class TabBarTapped extends AppEvent {
  const TabBarTapped(this.newIndex);
  final int newIndex;
}
