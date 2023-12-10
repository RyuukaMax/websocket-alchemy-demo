// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      blockHash: json['blockHash'] as String?,
      blockNumber: json['blockNumber'] as String?,
      from: json['from'] as String?,
      gas: json['gas'] as String?,
      gasPrice: json['gasPrice'] as String?,
      maxFeePerGas: json['maxFeePerGas'] as String?,
      maxPriorityFeePerGas: json['maxPriorityFeePerGas'] as String?,
      hash: json['hash'] as String?,
      input: json['input'] as String?,
      nonce: json['nonce'] as String?,
      to: json['to'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      accessList: json['accessList'] as List<dynamic>?,
      chainId: json['chainId'] as String?,
      v: json['v'] as String?,
      r: json['r'] as String?,
      s: json['s'] as String?,
      yParity: json['yParity'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'blockHash': instance.blockHash,
      'blockNumber': instance.blockNumber,
      'from': instance.from,
      'gas': instance.gas,
      'gasPrice': instance.gasPrice,
      'maxFeePerGas': instance.maxFeePerGas,
      'maxPriorityFeePerGas': instance.maxPriorityFeePerGas,
      'hash': instance.hash,
      'input': instance.input,
      'nonce': instance.nonce,
      'to': instance.to,
      'value': instance.value,
      'type': instance.type,
      'accessList': instance.accessList,
      'chainId': instance.chainId,
      'v': instance.v,
      'r': instance.r,
      's': instance.s,
      'yParity': instance.yParity,
    };
