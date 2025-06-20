import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/layouts/home.dart';
import 'package:flutter_expense_traker/provider/trrasaction_provider.dart';
import 'package:provider/provider.dart';

class TransactionListWidget extends StatefulWidget {
  const TransactionListWidget({super.key});

  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture =
        Provider.of<TransactionProvider>(
          context,
          listen: false,
        ).loadTransactionsForCurrentMonth();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<TransactionProvider>();
    return FutureBuilder(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        return Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            final txList = provider.transactions;

            return AnimatedList(
              key: _listKey,
              initialItemCount: txList.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: TransactionListTile(transactions: txList[index]),
                );
              },
            );
          },
        );
      },
    );
  }
}
