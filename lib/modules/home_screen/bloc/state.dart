part of 'bloc.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLoadingState extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoadedState extends HomeState {
  final List<Launch> launches;
  final Filter filter;
  final bool isLoadingMore;
  final bool hasNextPage;

  HomeLoadedState({
    this.launches = const [],
    this.filter = const Filter(page: 1, limit: 10, name: ''),
    this.isLoadingMore = false,
    this.hasNextPage = false,
  });

  HomeLoadedState copyWith({
    List<Launch>? launches,
    Filter? filter,
    bool? isLoadingMore,
    bool? hasNextPage,
    Sorter? sorter,
  }) {
    return HomeLoadedState(
      launches: launches ?? this.launches,
      filter: filter ?? this.filter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  @override
  List<Object?> get props => [
        launches,
        filter,
        isLoadingMore,
        hasNextPage,
      ];

  @override
  String toString() =>
      'HomeLoadedState(launches.length: ${launches.length}, filter: $filter)';
}

class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
