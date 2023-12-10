part of 'subscribe_alchemy_bloc.dart';

sealed class SubscribeAlchemyEvent extends Equatable {
  const SubscribeAlchemyEvent();

  @override
  List<Object> get props => [];
}

final class StartSubscribe extends SubscribeAlchemyEvent {}

final class ProcessTransaction extends SubscribeAlchemyEvent {
  const ProcessTransaction({required this.transaction});
  final Transaction? transaction;

  @override
  List<Object> get props => [transaction?.hashCode ?? ''];
}

final class ProcessError extends SubscribeAlchemyEvent {
  const ProcessError({required this.errMsg});
  final String errMsg;

  @override
  List<Object> get props => [errMsg];
}

final class ReconnectSubscription extends SubscribeAlchemyEvent {
  const ReconnectSubscription({required this.msg});
  final String msg;

  @override
  List<Object> get props => [msg];
}

final class CloseSubscribe extends SubscribeAlchemyEvent {}

final class ResetState extends SubscribeAlchemyEvent {}
