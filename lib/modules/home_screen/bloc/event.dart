part of 'bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchLaunches extends HomeEvent {
  final Filter filter;
  final Sorter sorter;

  const FetchLaunches(
    this.filter,
    this.sorter,
  );
}

class FetchLaunchesMore extends HomeEvent {
  final List<Launch> launches;
  final Filter filter;
  final Sorter sorter;

  const FetchLaunchesMore(this.launches, this.filter, this.sorter);
}

class ToggleSortOrder extends HomeEvent {
  final String key;

  const ToggleSortOrder(
    this.key,
  );
}
