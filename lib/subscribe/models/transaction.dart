import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction extends Equatable {
  const Transaction({
    this.blockHash,
    this.blockNumber,
    this.from,
    this.gas,
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.hash,
    this.input,
    this.nonce,
    this.to,
    this.value,
    this.type,
    this.accessList,
    this.chainId,
    this.v,
    this.r,
    this.s,
    this.yParity,
  });

  final String? blockHash;
  final String? blockNumber;
  final String? from;
  final String? gas;
  final String? gasPrice;
  final String? maxFeePerGas;
  final String? maxPriorityFeePerGas;
  final String? hash;
  final String? input;
  final String? nonce;
  final String? to;
  final String? value;
  final String? type;
  final List<dynamic>? accessList;
  final String? chainId;
  final String? v;
  final String? r;
  final String? s;
  final String? yParity;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  List<Object?> get props => [hash];
}
