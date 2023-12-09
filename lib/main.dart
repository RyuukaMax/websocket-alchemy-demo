import 'package:flutter/material.dart';
import 'package:websocket_alchemy_demo/subscribe/subscribe.dart';

void main() async {
  runApp(const WebSocketAlchemyDemo());
}

class WebSocketAlchemyDemo extends StatelessWidget {
  const WebSocketAlchemyDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Alchemy Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SubscribeView(),
    );
  }
}
