import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:websocket_alchemy_demo/subscribe/data/transaction_repository.dart';
import 'package:websocket_alchemy_demo/subscribe/models/models.dart';

part 'subscribe_alchemy_state.dart';

const String alchemyDemoUrl = 'wss://eth-mainnet.ws.alchemyapi.io/ws/demo';

class SubscribeAlchemyCubit extends Cubit<SubscribeAlchemyState> {
  SubscribeAlchemyCubit()
      : _repository = TransactionRepository(),
        super(DataInit());

  int counter = 0;
  final TransactionRepository _repository;
  late final StreamSubscription<dynamic> _transactionSubscription;

  attemptSubscribe() async {
    Stream<dynamic> stream = await _repository.subscribeTransactions();
    _transactionSubscription = stream.listen(_onDataReceived);
  }

  _onDataReceived(data) async {
    print(data);
    Map<String, dynamic> decodedData = jsonDecode(data);

    Transaction newTransaction =
        Transaction.fromJson(decodedData['params']['result']);

    emit(DataLoaded(newTransaction));
  }

  @override
  Future<void> close() {
    _transactionSubscription.cancel();
    _repository.close();
    return super.close();
  }

  @override
  void onChange(Change<SubscribeAlchemyState> change) {
    super.onChange(change);
    print(change);
  }
}
