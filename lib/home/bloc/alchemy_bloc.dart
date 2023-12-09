import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:websocket_alchemy_demo/home/models/transaction.dart';

part 'alchemy_event.dart';
part 'alchemy_state.dart';

class AlchemyBloc extends Bloc<AlchemyEvent, AlchemyState> {
  AlchemyBloc() : super(AlchemyInitial()) {
    on<AddTransaction>(_onAddTransaction);
  }

  int counter = 0;

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

  @override
  void onChange(Change<AlchemyState> change) {
    super.onChange(change);
    // ignore: avoid_print
    print(change);
  }
}
