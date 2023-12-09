part of 'alchemy_bloc.dart';

sealed class AlchemyEvent extends Equatable {
  const AlchemyEvent();

  @override
  List<Object> get props => [];
}

final class AddTransaction extends AlchemyEvent {}

final class DeleteTransaction extends AlchemyEvent {}
