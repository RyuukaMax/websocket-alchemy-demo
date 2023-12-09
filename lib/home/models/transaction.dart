import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  const Transaction({required this.name, required this.transactionIndex});

  final String name;
  final int transactionIndex;

  @override
  List<Object?> get props => [name, transactionIndex];
}
