// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
      print('Connecting to the socket...');

      await _channel!.ready.timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw (
          TimeoutException(
            'Connection taking too long...',
          ),
        ),
      );
      print('Connection ready!');
    } on WebSocketException catch (error) {
      print('Websocket Exception Error! ${error.toString()}');
      throw Error();
    } on TimeoutException catch (error) {
      print('Timeout Exception Error! ${error.toString()}');
      throw Error();
    } catch (error, stacktrace) {
      print('Error! ${error.toString()}');
      print('Stacktrace: $stacktrace');
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
      print('Subscribed!');

      return _channel!.stream;
    } catch (error, stacktrace) {
      print('Error! ${error.toString()}');
      print('Stacktrace: $stacktrace');
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
      print('Error! ${error.toString()}');
      print('Stacktrace: $stacktrace');
      throw error.toString();
    }
  }
}
