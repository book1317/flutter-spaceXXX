part of 'bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class InitialDetail extends DetailEvent {
  final String rocketId;
  final String launchpadId;

  const InitialDetail(this.rocketId, this.launchpadId);
}
