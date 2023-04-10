import 'package:flutter/material.dart';
import 'chartbar.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class chart extends StatelessWidget {
  @override
  final List<transaction> recenttransactions;

  chart(this.recenttransactions);

  List<Map> get groupedtrtansactionvalues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalsum = 0.0;

      for (var i = 0; i < recenttransactions.length; i++) {
        if (recenttransactions[i].date.day == weekday.day &&
            recenttransactions[i].date.month == weekday.month &&
            recenttransactions[i].date.year == weekday.year) {
          totalsum += recenttransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalsum
      };
    }).reversed.toList();
  }

  double get totalspend {
    return groupedtrtansactionvalues.fold(0.0, (sum, ele) {
      return sum + (ele['amount'] as double);
    });
  }

  Widget build(BuildContext context) {
    print(groupedtrtansactionvalues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedtrtansactionvalues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: chartbar(
                data['day'],
                data['amount'],
                totalspend == 0.0 ? 0.0 : data['amount'] / totalspend,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
