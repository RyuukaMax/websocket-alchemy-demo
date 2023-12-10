import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:websocket_alchemy_demo/subscribe/bloc/bloc.dart';

class SubscribeView extends StatelessWidget {
  const SubscribeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscribeAlchemyBloc(),
      child: const _SubscribeView(),
    );
  }
}

class _SubscribeView extends HookWidget {
  const _SubscribeView();

  @override
  Widget build(BuildContext context) {
    final bloc = useBloc<SubscribeAlchemyBloc>();
    final state = useBlocBuilder(bloc);

    useBlocListener<SubscribeAlchemyBloc, SubscribeAlchemyState>(bloc,
        (bloc, state, context) {
      const duration = Duration(seconds: 3);

      if (state is DataError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errMsg),
            backgroundColor: Colors.red,
            duration: duration,
          ),
        );
        Future.delayed(duration, () => bloc.add(ResetState()));
      }
    }, listenWhen: (state) => state is DataError);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: switch (state) {
                DataInit() =>
                  _stateButtons(context, () => bloc.add(StartSubscribe())),
                DataStreaming() => _stateButtons(
                    context,
                    () => bloc.add(CloseSubscribe()),
                    Icons.stop_circle_outlined,
                    'CLOSE',
                    Colors.redAccent),
                DataLoading() || DataError() => _stateButtons(context, null),
              },
            ),
            Expanded(
              child: switch (state) {
                DataInit() || DataError() => _placeholder(context),
                DataLoading() => _spinner(),
                DataStreaming() => _buildTransactionView(state),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _spinner() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _placeholder(BuildContext context) => Center(
        child: Text('No live data available!',
            style: Theme.of(context).textTheme.headlineMedium),
      );

  Widget _buildTransactionView(DataStreaming state) => ListView(
        children: [
          _buildCards(state.transaction?.from ?? ''),
          _buildCards(state.transaction?.gas ?? ''),
          _buildCards(state.transaction?.gasPrice ?? ''),
          _buildCards(state.transaction?.maxFeePerGas ?? ''),
          _buildCards(state.transaction?.maxPriorityFeePerGas ?? ''),
          _buildCards(state.transaction?.hash ?? ''),
          _buildCards(state.transaction?.input ?? ''),
          _buildCards(state.transaction?.nonce ?? ''),
          _buildCards(state.transaction?.to ?? ''),
          _buildCards(state.transaction?.value ?? ''),
          _buildCards(state.transaction?.type ?? ''),
          _buildCards(state.transaction?.accessList?.length.toString() ?? ''),
          _buildCards(state.transaction?.chainId ?? ''),
          _buildCards(state.transaction?.v ?? ''),
          _buildCards(state.transaction?.r ?? ''),
          _buildCards(state.transaction?.s ?? ''),
          _buildCards(state.transaction?.yParity ?? ''),
        ],
      );

  Widget _buildCards(String text) => Card(
        child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
      );

  Widget _stateButtons(BuildContext context, Function()? func,
          [IconData? icon, String? text, Color? bgColor]) =>
      ElevatedButton.icon(
        onPressed: func,
        icon: Icon(icon ?? Icons.earbuds),
        label: Text(text ?? 'SUBSCRIBE'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).secondaryHeaderColor,
          backgroundColor: bgColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );
}
