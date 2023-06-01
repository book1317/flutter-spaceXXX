part of 'bloc.dart';

abstract class DetailState extends Equatable {}

class DetailLoadingState extends DetailState {
  @override
  List<Object?> get props => [];
}

class DetailLoadedState extends DetailState {
  final Rocket rocket;
  final Launchpad launchpad;

  DetailLoadedState(this.rocket, this.launchpad);

  @override
  List<Object?> get props => [rocket, launchpad];
}

class DetailErrorState extends DetailState {
  final String error;
  DetailErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
