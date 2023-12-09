part of 'subscribe_alchemy_bloc.dart';

sealed class SubscribeAlchemyState extends Equatable {
  const SubscribeAlchemyState([List<Transaction>? transactions])
      : transactions = transactions ?? const [];

  final List<Transaction> transactions;

  @override
  List<Object> get props => [transactions];
}

final class AlchemyInitial extends SubscribeAlchemyState {}

final class AlchemyLoading extends SubscribeAlchemyState {
  const AlchemyLoading([super.transactions]);

  @override
  String toString() {
    return 'AlchemyLoaded: ${transactions.length}';
  }
}

final class AlchemyLoaded extends SubscribeAlchemyState {
  const AlchemyLoaded([super.transactions]);

  @override
  String toString() {
    return 'AlchemyLoaded: ${transactions.length}';
  }
}
