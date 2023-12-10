import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:websocket_alchemy_demo/subscribe/cubit/cubit.dart';

class SubscribeView extends StatelessWidget {
  const SubscribeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscribeAlchemyCubit(),
      child: const _SubscribeView(),
    );
  }
}

class _SubscribeView extends HookWidget {
  const _SubscribeView();

  @override
  Widget build(BuildContext context) {
    final bloc = useBloc<SubscribeAlchemyCubit>();
    final state = useBlocBuilder(bloc);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: switch (state) {
              DataInit() => _placeholder(context),
              DataLoading() => _spinner(),
              DataLoaded() => _buildTransactionView(state),
            },
          ),
          ElevatedButton.icon(
            onPressed: () => bloc.attemptSubscribe(),
            icon: const Icon(Icons.earbuds),
            label: const Text('Subscribe Alchemy'),
          ),
        ],
      ),
    );
  }

  Widget _spinner() => const CircularProgressIndicator();

  Widget _placeholder(BuildContext context) => Center(
        child: Text('No data available!',
            style: Theme.of(context).textTheme.headlineMedium),
      );

  Widget _buildTransactionView(DataLoaded state) => ListView(
        children: [
          _buildCards(state.transaction?.blockHash ?? ''),
          _buildCards(state.transaction?.blockNumber ?? ''),
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
}
