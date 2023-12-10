part of 'subscribe_alchemy_bloc.dart';

sealed class SubscribeAlchemyEvent extends Equatable {
  const SubscribeAlchemyEvent();

  @override
  List<Object> get props => [];
}

final class StartSubscribe extends SubscribeAlchemyEvent {}

final class CloseSubscribe extends SubscribeAlchemyEvent {}

final class ResetState extends SubscribeAlchemyEvent {}
