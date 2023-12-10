part of 'subscribe_alchemy_bloc.dart';

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

final class DataStreaming extends SubscribeAlchemyState {
  const DataStreaming([super.transaction]);
}

final class DataError extends SubscribeAlchemyState {
  const DataError(this.errMsg, [super.transaction]);

  final String errMsg;
}
