import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import './widgets/transactionlist.dart';
import './models/transaction.dart';
import './widgets/chart.dart';
import 'dart:io';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);//dot allow the app to  be in landscape
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'expentrac',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.indigo,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline1: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String titleinput;
  final List<transaction> _usertransactions = [
    // transaction(id: 't1', title: 'fanta', amount: 15, date: DateTime.now()),
    // transaction(id: 't2', title: 'cococola', amount: 20, date: DateTime.now()),
  ];

  bool showchart = false;
  List<transaction> get recenttransactions {
    return _usertransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addtransaction(String txtitle, double txamount, DateTime txdate) {
    final tx = transaction(
      id: DateTime.now().toString(),
      title: txtitle,
      amount: txamount,
      date: txdate,
    );
    setState(() {
      _usertransactions.add(tx);
    });
  }

  void _startaddnewtransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: newtransaction(_addtransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void deletetransaction(String id) {
    setState(() {
      _usertransactions.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final islandscape = mediaquery.orientation == Orientation.landscape;
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'ExpenTrac',
              style: Theme.of(context).textTheme.headline1,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _startaddnewtransaction(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          ).preferredSize
        : AppBar(
            title: Text(
              'ExpenTrac',
              style: Theme.of(context).appBarTheme.textTheme.headline1,
            ),
            actions: [
              IconButton(
                onPressed: () => _startaddnewtransaction(context),
                icon: Icon(Icons.add),
              )
            ],
          );

    final txlistwidget = Container(
      child: transactionlist(_usertransactions, deletetransaction),
      height: (mediaquery.size.height -
              appbar.preferredSize.height -
              mediaquery.padding.top) *
          0.7,
    );
    final pagebody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (islandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('show chart'),
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: showchart,
                  onChanged: (val) {
                    setState(() {
                      showchart = val;
                    });
                  },
                )
              ],
            ),
          if (!islandscape)
            Container(
              child: chart(recenttransactions),
              height: (mediaquery.size.height -
                      appbar.preferredSize.height -
                      mediaquery.padding.top) *
                  0.3,
            ),
          if (!islandscape) txlistwidget,
          if (islandscape)
            showchart
                ? Container(
                    child: chart(recenttransactions),
                    height: (mediaquery.size.height -
                            appbar.preferredSize.height -
                            mediaquery.padding.top) *
                        0.7,
                  )
                : txlistwidget,
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(child: pagebody, navigationBar: appbar)
        : Scaffold(
            appBar: appbar,
            body: pagebody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _startaddnewtransaction(context);
                    },
                  ),
          );
  }
}
