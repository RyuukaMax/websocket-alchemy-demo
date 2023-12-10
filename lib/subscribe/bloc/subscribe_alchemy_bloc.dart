import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:websocket_alchemy_demo/subscribe/data/data.dart';
import 'package:websocket_alchemy_demo/subscribe/models/models.dart';

part 'subscribe_alchemy_event.dart';
part 'subscribe_alchemy_state.dart';

class SubscribeAlchemyBloc
    extends Bloc<SubscribeAlchemyEvent, SubscribeAlchemyState> {
  SubscribeAlchemyBloc()
      : _repository = TransactionRepository(),
        super(DataInit()) {
    on<StartSubscribe>(_startSubscription);
    on<ProcessTransaction>(_processNewTransaction);
    on<ProcessError>(_onSubscriptionError);
    on<ReconnectSubscription>(
        (event, emit) => emit(DataStreaming(state.transaction, event.msg)));
    on<CloseSubscribe>(_closeSubscription);
    on<ResetState>(_resetState);
  }

  int counter = 0;
  final TransactionRepository _repository;
  late StreamSubscription<Transaction?> _transactionSubscription;

  _startSubscription(event, emit) async {
    emit(const DataLoading());

    try {
      _listenSubscription(await _repository.attemptSubscribe());
    } catch (error) {
      add(ProcessError(errMsg: error.toString()));
    }
  }

  _listenSubscription(Stream<Transaction?> transactionStream) {
    try {
      _transactionSubscription = transactionStream.listen(
        (transaction) => add(ProcessTransaction(transaction: transaction)),
        onDone: _attemptReconnection,
        onError: (_) => debugPrint('ERROR'),
      );
    } catch (error) {
      rethrow;
    }
  }

  _processNewTransaction(event, emit) {
    if (event is ProcessTransaction) {
      emit(DataStreaming(event.transaction));
    }
  }

  _attemptReconnection() async {
    int attempt = 1;
    bool isConnectionAlive = false;
    late Stream<Transaction?> getStream;
    while (attempt <= 5 && !isConnectionAlive) {
      debugPrint('Connection lost! Reconnecting - Attempt $attempt');
      add(ReconnectSubscription(
          msg: 'Connection lost! Reconnecting - Attempt $attempt'));
      try {
        getStream = await _repository.attemptSubscribe();
        isConnectionAlive = true;
      } catch (_) {
        await Future.delayed(const Duration(seconds: 3));
        attempt++;
      }
    }

    if (isConnectionAlive) {
      _listenSubscription(getStream);
    } else {
      add(const ProcessError(errMsg: 'Reconnection failed within 5 attempts.'));
    }
  }

  _onSubscriptionError(event, emit) {
    if (event is ProcessError) {
      emit(DataError(event.errMsg));
    }
  }

  _resetState(event, emit) {
    emit(DataInit());
  }

  _closeSubscription(event, emit) async {
    await _closeConnection(emit);
    _resetState(event, emit);
  }

  _closeConnection([emit]) async {
    try {
      await _transactionSubscription.cancel();
      await _repository.closeConnection();
    } catch (error) {
      add(ProcessError(errMsg: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _closeConnection();
    return super.close();
  }

  @override
  void onChange(Change<SubscribeAlchemyState> change) {
    super.onChange(change);
    debugPrint(change.toString());
  }
}
