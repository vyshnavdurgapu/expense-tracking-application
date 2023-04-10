import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './adaptivebutton.dart';

class newtransaction extends StatefulWidget {
  final Function addtx;

  newtransaction(this.addtx);

  @override
  State<newtransaction> createState() => _newtransactionState();
}

class _newtransactionState extends State<newtransaction> {
  final titlecontroller = TextEditingController();

  final amountcontroller = TextEditingController();

  DateTime selecteddate;

  void submitdata() {
    if (amountcontroller.text.isEmpty) {
      return;
    }

    print('eppurra');
    final enteredtitle = titlecontroller.text;
    final enteredamount = double.parse(amountcontroller.text);

    if (enteredtitle.isEmpty || enteredamount <= 0 || selecteddate == null) {
      return;
    }

    widget.addtx(titlecontroller.text, double.parse(amountcontroller.text),
        selecteddate);

    Navigator.of(context).pop();
  }

  void presentdatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2009),
      lastDate: DateTime.now(),
    ).then((pickeddate) {
      if (pickeddate == null) {
        return;
      }
      setState(() {
        selecteddate = pickeddate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // CupertinoTextField(placeholder: ,),
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                // onChanged: (value) => titleinput = value,
                controller: titlecontroller,
                onSubmitted: (_) => submitdata(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                // onChanged: (value) => amountinput = value,
                controller: amountcontroller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitdata(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(selecteddate == null
                          ? 'No Date chosem!'
                          : 'Picked Date:' +
                              DateFormat.yMd().format(selecteddate)),
                    ),
                    adaptiveflatbutton('choose Date', presentdatepicker)
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      onPressed: () {
                        print('rey');
                        submitdata();
                      },
                      child: Text('Add Expense'),
                      color: Theme.of(context).primaryColor,
                    )
                  : RaisedButton(
                      onPressed: () {
                        print('rey');
                        submitdata();
                      },
                      child: Text('Add Expense'),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
