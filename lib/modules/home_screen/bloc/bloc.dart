import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spaceXXX/data/models/launch_model.dart';
import 'package:spaceXXX/data/repositories/launch_repository.dart';

part 'event.dart';
part 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LaunchRepository _launchRepository;

  HomeBloc(this._launchRepository) : super(HomeState()) {
    on<FetchLaunches>(_onFetchLaunches);
    on<FetchLaunchesMore>(_onFetchMoreLaunches);
    // on<ToggleSortOrder>(_onToggleSortOrder);
  }
  _onFetchLaunches(
    FetchLaunches event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    try {
      final launchDetail =
          await _launchRepository.getlaunchesList(event.filter, event.sorter);

      emit(HomeLoadedState(
        isLoadingMore: false,
        launches: launchDetail.launchs,
        hasNextPage: launchDetail.pageDetail.hasNextPage,
        filter: event.filter,
      ));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  _onFetchMoreLaunches(
    FetchLaunchesMore event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoadedState) {
        emit((state as HomeLoadedState).copyWith(isLoadingMore: true));

        final launchDetail =
            await _launchRepository.getlaunchesList(event.filter, event.sorter);

        emit((state as HomeLoadedState).copyWith(
          isLoadingMore: false,
          launches: launchDetail.launchs,
          hasNextPage: launchDetail.pageDetail.hasNextPage,
          filter: event.filter,
        ));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  // _onToggleSortOrder(
  //   ToggleSortOrder event,
  //   Emitter<HomeState> emit,
  // ) async {
  //   try {
  //     if (state is HomeLoadedState) {
  //       Map<String, dynamic> mapSorter =
  //           (state as HomeLoadedState).sorter.toMap();
  //       mapSorter[event.key] = mapSorter[event.key] == SorterOrder.asc
  //           ? SorterOrder.desc
  //           : SorterOrder.asc;
  //       Sorter newSort = Sorter.fromJson(mapSorter);

  //       emit((state as HomeLoadedState).copyWith(
  //         sorter: newSort,
  //       ));
  //     }
  //   } catch (e) {
  //     emit(HomeErrorState(e.toString()));
  //   }
  // }
}
