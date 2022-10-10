import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:transactoion_keeper/widget/new_transaction.dart';
import './model/transaction.dart';
import './widget/transaction_list.dart';
import './widget/chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal expenses',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
        ),
        home: Scaffold(
          body: LayoutBuilder(builder: (context, constraints) {
            return HomePage();
          }),
        ));
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

// 9:27
class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     amount: 78.99, date: DateTime.now(), id: 't1', title: "New Shoes"),
    // Transaction(
    //     amount: 12545.99, date: DateTime.now(), id: 't2', title: "New Car"),
    // Transaction(
    //     amount: 38.99, date: DateTime.now(), id: 't3', title: "New Bag"),
    // Transaction(
    //     amount: 2328.99, date: DateTime.now(), id: 't4', title: "New House")
  ];
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString(),
        title: txTitle);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteItems(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction));
        });
  }

  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final  appbar = 
        AppBar(
            title: Text('Transaction App'),
            actions: [
              IconButton(
                  onPressed: () => _startNewTransaction(context),
                  icon: Icon(Icons.add))
            ],
          );
    final txList = Container(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteItems));
    final appBody =SafeArea(child:SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (isLandscape)
            Center(
              child: Row(
                children: [
                  Text(
                    'Show Chart',
                    style: TextStyle(fontSize: 30),
                  ),
                  Switch.adaptive(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            ),
          if (!isLandscape)
            Container(
              height: (mediaquery.size.height -
                      appbar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.3,
              child: Chart(_recentTransactions),
            ),
          if (!isLandscape) txList,
          if (isLandscape)
            _showChart
                ? Container(
                    height: (mediaquery.size.height -
                            appbar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_recentTransactions),
                  )
                : txList
        ],
      ),
    ) ); 

    return
         Scaffold(
            appBar: appbar,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startNewTransaction(context),
                    child: Icon(Icons.add)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: appBody,
          );
  }
}
