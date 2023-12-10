part of 'subscribe_alchemy_cubit.dart';

sealed class SubscribeAlchemyState extends Equatable {
  const SubscribeAlchemyState([this.transaction]);

  final Transaction? transaction;

  @override
  List<Object> get props => [transaction?.hash ?? ''];
}

final class DataInit extends SubscribeAlchemyState {}

final class DataLoading extends SubscribeAlchemyState {
  const DataLoading([super.transaction]);
}

final class DataLoaded extends SubscribeAlchemyState {
  const DataLoaded([super.transaction]);
}
