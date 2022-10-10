import 'package:flutter/material.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteItem;
  TransactionList(this.transaction, this.deleteItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height *0.6,
      child: transaction.isEmpty
          ? LayoutBuilder(builder: (ctx,  Constraint) {
              return Column(
                children: [
                  Text(
                    'No transaction added yet.!',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: Constraint.maxHeight * 0.6,
                      child: Image.asset(
                        'images/www.png',
                        fit: BoxFit.contain,
                      )),
                ],
              );
            })
          : ListView.builder(
              itemCount: transaction.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                            '\$${transaction[index].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transaction[index].title,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      DateFormat.yMd().format(transaction[index].date),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    trailing: MediaQuery.of(context).size.width > 360
                        ? OutlinedButton.icon(
                            onPressed: () => deleteItem(transaction[index].id),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            label: Text('Delete'))
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteItem(transaction[index].id),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
