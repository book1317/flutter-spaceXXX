import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:space_xxx/data/models/launchpad_model.dart';
import 'package:space_xxx/data/models/rocket_model.dart';
import 'package:space_xxx/data/repositories/launchpad_repository.dart';
import 'package:space_xxx/data/repositories/rocket_repository.dart';

part 'event.dart';
part 'state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final RocketRepository _rocketRepository;
  final LaunchpadRepository _launchpadRepository;

  DetailBloc(this._rocketRepository, this._launchpadRepository)
      : super(DetailLoadingState()) {
    on<InitialDetail>(_onFetchRocket);
  }
  _onFetchRocket(
    InitialDetail event,
    Emitter<DetailState> emit,
  ) async {
    emit(DetailLoadingState());
    try {
      final rocket = await _rocketRepository.getRocketById(event.rocketId);
      final launchpad =
          await _launchpadRepository.getLaunchpadById(event.launchpadId);
      emit(DetailLoadedState(rocket, launchpad));
    } catch (e) {
      emit(DetailErrorState(e.toString()));
    }
  }
}
