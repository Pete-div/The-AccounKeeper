import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _textInputController = TextEditingController();

  final _amountInputController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if(_amountInputController.text.isEmpty){
      return;
    }
    final enteredTitle = _textInputController.text;
    final entertedAmount = double.parse(_amountInputController.text);
    if (enteredTitle.isEmpty || entertedAmount <= 0 || _selectedDate == null ) {
      return;
    }

    widget.addTx( enteredTitle,entertedAmount,_selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding:  EdgeInsets.only(top:10,left:10,right:10,bottom:MediaQuery.of(context).viewInsets.bottom + 10 ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _textInputController,
              onSubmitted: (_) => _submitData,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: _amountInputController,
              onSubmitted: (_) => _submitData,
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No Date Chosen'
                        : 'Picked Date ${(DateFormat.yMd().format(_selectedDate!))}',
                    style: TextStyle(color: Colors.pink),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:30.0),
                      child: ElevatedButton(
                        onPressed: _presentDatePicker,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitData
              // onPressed: ()=>widget.addTx(_amountInputController,_textInputController)
                // Navigator.of(context).pop()
              ,
              child: Text(
                'Add Transaction',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
