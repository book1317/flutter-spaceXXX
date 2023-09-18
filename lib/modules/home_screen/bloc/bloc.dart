import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:space_xxx/data/models/launch_model.dart';
import 'package:space_xxx/data/repositories/launch_repository.dart';

part 'event.dart';
part 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LaunchRepository _launchRepository;

  HomeBloc(this._launchRepository) : super(HomeState()) {
    on<FetchLaunches>(_onFetchLaunches);
    on<FetchLaunchesMore>(_onFetchMoreLaunches);
  }
  _onFetchLaunches(
    FetchLaunches event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    try {
      final launchDetail =
          await _launchRepository.getlaunchesList(event.fetchDetail);

      emit(HomeLoadedState(
        isLoadingMore: false,
        launches: launchDetail.launchs,
        hasNextPage: launchDetail.pageDetail.hasNextPage,
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
        HomeLoadedState homeLoadedState = (state as HomeLoadedState);
        emit(homeLoadedState.copyWith(isLoadingMore: true));

        final launchDetail =
            await _launchRepository.getlaunchesList(event.fetchDetail);

        emit(homeLoadedState.copyWith(
          isLoadingMore: false,
          launches: homeLoadedState.launches..addAll(launchDetail.launchs),
          hasNextPage: launchDetail.pageDetail.hasNextPage,
        ));
      }
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
