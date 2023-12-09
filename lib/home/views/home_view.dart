import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:websocket_alchemy_demo/home/bloc/alchemy_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlchemyBloc(),
      child: const _Home(),
    );
  }
}

class _Home extends HookWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    final bloc = useBloc<AlchemyBloc>();
    final state = useBlocBuilder(
      bloc,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: switch (state) {
              AlchemyInitial() => _placeholder(context),
              AlchemyLoading() => _spinner(),
              AlchemyLoaded() => _buildList(state),
            },
          ),
          ElevatedButton.icon(
            onPressed: () => bloc.add(AddTransaction()),
            icon: const Icon(Icons.add),
            label: const Text('Add Transactions'),
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

  Widget _buildList(AlchemyLoaded state) => ListView.builder(
        itemCount: state.transactions.length,
        itemBuilder: (_, int index) => Card(
          child: ListTile(
            title: Text(
              state.transactions[index].transactionIndex.toString(),
            ),
            subtitle: Text(
              state.transactions[index].name,
            ),
          ),
        ),
      );
}
