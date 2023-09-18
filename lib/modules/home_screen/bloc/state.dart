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
  final bool isLoadingMore;
  final bool hasNextPage;

  HomeLoadedState({
    required this.launches,
    required this.isLoadingMore,
    required this.hasNextPage,
  });

  HomeLoadedState copyWith({
    List<Launch>? launches,
    bool? isLoadingMore,
    bool? hasNextPage,
  }) {
    return HomeLoadedState(
      launches: launches ?? this.launches,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  @override
  List<Object?> get props => [
        launches,
        isLoadingMore,
        hasNextPage,
      ];

  @override
  String toString() => 'HomeLoadedState(launches.length: ${launches.length})';
}

class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
