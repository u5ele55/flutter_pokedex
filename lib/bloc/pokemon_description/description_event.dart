part of 'description_bloc.dart';

abstract class DescriptionEvent extends Equatable {
  @override
  List get props => [];
}

class LoadDescriptionOnlineData extends DescriptionEvent {
  final int id;
  LoadDescriptionOnlineData(this.id);
}
