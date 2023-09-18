part of 'bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchLaunches extends HomeEvent {
  final FetchDetail fetchDetail;

  const FetchLaunches(
    this.fetchDetail,
  );
}

class FetchLaunchesMore extends HomeEvent {
  final List<Launch> launches;
  final FetchDetail fetchDetail;

  const FetchLaunchesMore(this.launches, this.fetchDetail);
}

class ToggleSortOrder extends HomeEvent {
  final String key;

  const ToggleSortOrder(
    this.key,
  );
}
