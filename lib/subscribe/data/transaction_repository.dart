import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:websocket_alchemy_demo/subscribe/data/data.dart';
import 'package:websocket_alchemy_demo/subscribe/models/models.dart';

class TransactionRepository {
  TransactionRepository() : dataLayerWs = TransactionData();

  final TransactionData dataLayerWs;

  Future<Stream<Transaction?>> attemptSubscribe() async {
    try {
      await dataLayerWs.wsConnect();
      return dataLayerWs.wsSubscribe().map(_parseData);
    } catch (error) {
      rethrow;
    }
  }

  Transaction? _parseData(data) {
    try {
      // debugPrint('Unparsed Data: $data');
      Map<String, dynamic> decodedData = jsonDecode(data);
      if (decodedData.containsKey('error')) {
        String errMsg = decodedData['error']['message'];
        throw errMsg;
      } else {
        if (decodedData['params']?['result'] == null) {
          debugPrint('Skip data');
          return null; // Ignore broken data that does not reflect model
        }
        Transaction newTransaction = Transaction.fromJson(
          decodedData['params']?['result'],
        );

        return newTransaction;
      }
    } catch (error) {
      throw 'Error while parsing JSON:  ${error.toString()}';
    }
  }

  Future<void> closeConnection() async {
    try {
      await dataLayerWs.wsClose();
    } catch (error) {
      rethrow;
    }
  }
}
