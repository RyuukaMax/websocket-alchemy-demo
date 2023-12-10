import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

const String alchemyDemoUrl = 'wss://eth-mainnet.ws.alchemyapi.io/ws/demo';

class TransactionRepository {
  late WebSocketChannel _channel;

  Future<Stream<dynamic>> subscribeTransactions() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(alchemyDemoUrl),
      );
      print('Connecting to the socket...');

      // Future.any([]);
      await _channel.ready;
      print('Connection ready!');

      Map<String, dynamic> request = {
        'jsonrpc': '2.0',
        'id': 0,
        'method': 'eth_subscribe',
        'params': ['alchemy_newFullPendingTransactions']
      };
      _channel.sink.add(json.encode(request));
      print('Subscribed!');

      return _channel.stream;
    } catch (error) {
      print('Error! ${error.toString()}');
      throw Error();
    }
  }

  close() {
    _channel.sink.close();
  }
}
