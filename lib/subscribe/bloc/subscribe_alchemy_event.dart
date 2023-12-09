part of 'subscribe_alchemy_bloc.dart';

sealed class SubscribeAlchemyEvent extends Equatable {
  const SubscribeAlchemyEvent();

  @override
  List<Object> get props => [];
}

final class AddTransaction extends SubscribeAlchemyEvent {}

final class DeleteTransaction extends SubscribeAlchemyEvent {}
