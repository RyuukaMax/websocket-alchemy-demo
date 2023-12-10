import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:websocket_alchemy_demo/subscribe/data/data.dart';
import 'package:websocket_alchemy_demo/subscribe/models/models.dart';

part 'subscribe_alchemy_event.dart';
part 'subscribe_alchemy_state.dart';

class SubscribeAlchemyBloc
    extends Bloc<SubscribeAlchemyEvent, SubscribeAlchemyState> {
  SubscribeAlchemyBloc()
      : _repository = TransactionRepository(),
        super(DataInit()) {
    on<StartSubscribe>(_listenSubscription);
    on<CloseSubscribe>(_closeSubscription);
    on<ResetState>(_resetState);
  }

  int counter = 0;
  final TransactionRepository _repository;
  late StreamSubscription<Transaction?> _transactionSubscription;

  _listenSubscription(event, emit) async {
    emit(const DataLoading());

    try {
      var getStream = await _repository.attemptSubscribe();

      _transactionSubscription = getStream.listen(
        (transaction) => emit(DataStreaming(transaction)),
        onError: (error) {
          print('Stream output error! ${error.toString()}');
        },
        onDone: () {
          print('Stream is done!');
        },
      );

      // Keep event alive in order to continue emit new state changes
      // Will only stop once stream subscription returns a value
      await Future.wait([_transactionSubscription.asFuture()]);
    } catch (error) {
      _onSubscriptionError(error, emit);
    }
  }

  _closeSubscription(event, emit) async {
    await _closeConnection();
    _resetState(event, emit);
  }

  _closeConnection() async {
    await _transactionSubscription.cancel();
    await _repository.closeConnection();
  }

  _onSubscriptionError(error, emit) {
    emit(DataError(error.toString()));
  }

  _resetState(event, emit) {
    emit(DataInit());
  }

  @override
  Future<void> close() async {
    await _closeConnection();
    return super.close();
  }

  @override
  void onChange(Change<SubscribeAlchemyState> change) {
    super.onChange(change);
    print(change);
  }
}
