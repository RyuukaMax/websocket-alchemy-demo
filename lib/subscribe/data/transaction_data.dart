import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:web_socket_channel/web_socket_channel.dart';

const String alchemyDemoUrl = 'wss://eth-mainnet.ws.alchemyapi.io/ws/demo';
const String requestMethod = 'eth_subscribe';
const String subscribeType = 'alchemy_newFullPendingTransactions';

class TransactionData {
  WebSocketChannel? _channel;

  Future<void> wsConnect() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(alchemyDemoUrl),
      );
      debugPrint('Connecting to the socket...');

      await _channel!.ready.timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw (
          TimeoutException(
            'Connection taking too long...',
          ),
        ),
      );
      debugPrint('Connection ready!');
    } on SocketException catch (error) {
      debugPrint('Socket Exception Error! ${error.toString()}');
      throw 'Fail to connect to server! Please ensure you have internet connection...';
    } on WebSocketException catch (error) {
      debugPrint('Websocket Exception Error! ${error.toString()}');
      throw error.toString();
    } on TimeoutException catch (error) {
      debugPrint('Timeout Exception Error! ${error.toString()}');
      throw error.toString();
    } catch (error, stacktrace) {
      debugPrint('Error! ${error.toString()}');
      debugPrint('Stacktrace: $stacktrace');
      throw error.toString();
    }
  }

  Stream<dynamic> wsSubscribe() {
    try {
      if (_channel?.sink == null) {
        throw 'WebSocket is not yet connected';
      }

      Map<String, dynamic> request = {
        'jsonrpc': '2.0',
        'id': 0,
        'method': requestMethod,
        'params': [subscribeType],
      };
      _channel!.sink.add(json.encode(request));
      debugPrint('Subscribed!');

      return _channel!.stream;
    } catch (error, stacktrace) {
      debugPrint('Error! ${error.toString()}');
      debugPrint('Stacktrace: $stacktrace');
      throw error.toString();
    }
  }

  Future<void> wsClose() async {
    try {
      if (_channel?.sink == null) {
        throw 'WebSocket is not yet connected';
      }
      await _channel!.sink.close();
    } catch (error, stacktrace) {
      debugPrint('Error! ${error.toString()}');
      debugPrint('Stacktrace: $stacktrace');
      throw error.toString();
    }
  }
}
