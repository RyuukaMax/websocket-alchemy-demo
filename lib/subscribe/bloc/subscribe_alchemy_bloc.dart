import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websocket_alchemy_demo/subscribe/models/models.dart';

part 'subscribe_alchemy_event.dart';
part 'subscribe_alchemy_state.dart';

class SubscribeAlchemyBloc
    extends Bloc<SubscribeAlchemyEvent, SubscribeAlchemyState> {
  SubscribeAlchemyBloc() : super(AlchemyInitial()) {
    on<AddTransaction>(_onAddTransaction);
  }

  int counter = 0;
  late final WebSocketChannel channel;

  _onAddTransaction(event, emit) async {
    emit(AlchemyLoading(
      state.transactions,
    ));

    counter++;
    Transaction newTransaction =
        Transaction(name: "Test", transactionIndex: counter);

    await Future.delayed(const Duration(seconds: 2), () {
      emit(
        AlchemyLoaded(
          [
            ...state.transactions,
            newTransaction,
          ],
        ),
      );
    });
  }

  _onSubscribe() {
    emit(AlchemyLoading(
      state.transactions,
    ));
  }

  @override
  void onChange(Change<SubscribeAlchemyState> change) {
    super.onChange(change);
    // ignore: avoid_print
    print(change);
  }
}
