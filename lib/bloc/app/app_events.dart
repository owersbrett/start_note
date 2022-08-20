abstract class AppEvent {
  const AppEvent();
}
class TabBarTapped extends AppEvent {
  const TabBarTapped(this.newIndex);
  final int newIndex;
}
