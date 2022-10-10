import 'package:flutter/material.dart';
import '../widget/chart_bar.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactios;
  Chart(this.recentTransactios);

  List<Map<String, Object>> get groupedTxValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactios.length; i++) {
        if (recentTransactios[i].date.day == weekDay.day &&
            recentTransactios[i].date.month == weekDay.month &&
            recentTransactios[i].date.year == weekDay.year) {
          totalSum += recentTransactios[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTxValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height*0*4,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTxValues.map((data) {
              return Flexible(
                fit:FlexFit.tight,
                child: ChartBar(
                    (data['day'] as String),
                    (data['amount'] as double),
                    totalSpending == 0.0
                        ? 0.0
                        : (data['amount'] as double) / totalSpending),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
