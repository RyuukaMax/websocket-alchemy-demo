part of 'alchemy_bloc.dart';

sealed class AlchemyState extends Equatable {
  const AlchemyState([List<Transaction>? transactions])
      : transactions = transactions ?? const [];

  final List<Transaction> transactions;

  @override
  List<Object> get props => [transactions];
}

final class AlchemyInitial extends AlchemyState {}

final class AlchemyLoading extends AlchemyState {
  const AlchemyLoading([super.transactions]);

  @override
  String toString() {
    return 'AlchemyLoaded: ${super.transactions.length}';
  }
}

final class AlchemyLoaded extends AlchemyState {
  const AlchemyLoaded([super.transactions]);

  @override
  String toString() {
    return 'AlchemyLoaded: ${super.transactions.length}';
  }
}
