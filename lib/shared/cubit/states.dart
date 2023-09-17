abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppLoadingState extends AppStates {}

class AppSuccessState extends AppStates {}

class AppErrorState extends AppStates {
  final String error;
  AppErrorState(this.error);
}