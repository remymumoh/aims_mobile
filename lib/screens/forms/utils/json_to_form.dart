import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class CoreForm extends StatefulWidget {
  final String form;
  final dynamic formMap;
  final EdgeInsets padding;
  final String labelText;
  final ValueChanged<dynamic> onChanged;
  final OutlineInputBorder enabledBorder;
  final OutlineInputBorder errorBorder;
  final OutlineInputBorder disabledBorder;
  final OutlineInputBorder focusedErrorBorder;
  final OutlineInputBorder focusedBorder;

  const CoreForm({
    @required this.form,
    @required this.onChanged,
    this.labelText,
    this.padding,
    this.formMap,
    this.enabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.focusedBorder,
    this.disabledBorder,
  });

  @override
  _CoreFormState createState() =>
      new _CoreFormState(formMap ?? json.decode(form));
}

class _CoreFormState extends State<CoreForm> {
  final dynamic formItems;

  int radioValue;
  String _selectedDate = "Tap on the button to select a date";
  String _selectedTime = "Tap on the button to select time";
  TimeOfDay _timeOfDay = TimeOfDay.now();
  TimeOfDay picked;
  int count = 0;
  // validators

  List<Widget> jsonToForm() {
    List<Widget> listWidget = new List<Widget>();

    for (var item in formItems) {
      if (item['type'] == "Input" ||
          item['type'] == "Password" ||
          item['type'] == "Email" ||
          item['type'] == "TareaText") {
        listWidget.add(new Container(
            padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(
              item['title'],
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )));
        listWidget.add(new TextField(
          controller: null,
          inputFormatters: item['validator'] != null && item['validator'] != ''
              ? [
            item['validator'] == 'digitsOnly'
                ? WhitelistingTextInputFormatter(RegExp('[0-9]'))
                : null,
            item['validator'] == 'textOnly'
                ? WhitelistingTextInputFormatter(RegExp('[a-zA-Z]'))
                : null,
          ]
              : null,
          decoration: new InputDecoration(
            labelText: widget.labelText,
            enabledBorder: widget.enabledBorder ?? null,
            errorBorder: widget.errorBorder ?? null,
            focusedErrorBorder: widget.focusedErrorBorder ?? null,
            focusedBorder: widget.focusedBorder ?? null,
            disabledBorder: widget.disabledBorder ?? null,
            hintText: item['placeholder'] ?? "",
          ),
          maxLines: item['type'] == "TareaText" ? 10 : 1,
          onChanged: (String value) {
            item['response'] = value;
            _handleChanged();
          },
          obscureText: item['type'] == "Password" ? true : false,
        ));
      }

      if (item['type'] == "TimePicker") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(
              item['label'],
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )));
        listWidget.add(new GestureDetector(
          child: Container(
            height: 60.0,
            child: Row(
              children: <Widget>[
                Container(width: 10.0),
                Icon(Icons.timer),
                Container(width: 10.0),
                Text(
                  _selectedTime,
                  style: TextStyle(fontSize: 20.0, height: 1.25),
                )
              ],
            ),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey
                ),
                borderRadius: BorderRadius.circular(5.0)
            ),
          ),

          onTap: () {
            _openTimePicker(context);
          },
        ));
      }

      if (item['type'] == "DatePicker") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(
              item['label'],
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )));
        listWidget.add(new GestureDetector(
          child: Container(
            height: 60.0,
            child: Row(
              children: <Widget>[
                Container(width: 10.0),
                Icon(Icons.calendar_today),
                Container(width: 10.0),
                Text(
                  _selectedDate,
                  style: TextStyle(fontSize: 20.0, height: 1.25),
                )
              ],
            ),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey
                ),
                borderRadius: BorderRadius.circular(5.0)
            ),
          ),

          onTap: () {
            _openDatePicker(context);
          },
        ));
      }



      if (item['type'] == "RadioButton") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));
        radioValue = item['value'];
        for (var i = 0; i < item['list'].length; i++) {
          listWidget.add(
            new Row(
              children: <Widget>[
                new Expanded(child: new Text(item['list'][i]['title'])),
                new Radio<int>(
                    value: item['list'][i]['value'],
                    groupValue: radioValue,
                    onChanged: (int value) {
                      this.setState(() {
                        radioValue = value;
                        item['value'] = value;
                        _handleChanged();
                      });
                    })
              ],
            ),
          );
        }
      }

      if (item['type'] == "Switch") {
        listWidget.add(
          new Row(children: <Widget>[
            new Expanded(child: new Text(item['title'])),
            new Switch(
                value: item['switchValue'],
                onChanged: (bool value) {
                  this.setState(() {
                    item['switchValue'] = value;
                    _handleChanged();
                  });
                })
          ]),
        );
      }

      if (item['type'] == "Checkbox") {
        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: new Text(item['title'],
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0))));
        for (var i = 0; i < item['list'].length; i++) {
          listWidget.add(
            new Row(
              children: <Widget>[
                new Expanded(child: new Text(item['list'][i]['title'])),
                new Checkbox(
                    value: item['list'][i]['value'],
                    onChanged: (bool value) {
                      this.setState(() {
                        item['list'][i]['value'] = value;
                        _handleChanged();
                      });
                    })
              ],
            ),
          );
        }
      }

      if (item['type'] == "Summary" || item["type"] == "summary") {
        listWidget.add(new Container(
          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Text(item['label'] + item['value'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),)
        ));
      }
      count++;
    }
    return listWidget;
  }

  Future<void>_openDatePicker(BuildContext context) async {
    final DateTime d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: new DateTime(2018), lastDate: new DateTime(2025));
    if (d != null) {
      setState(() {
        _selectedDate = new DateFormat.yMMMd("en_US").format(d).toString();
      });
    }
  }


  Future<Null> _openTimePicker(BuildContext context) async {
    picked = await showTimePicker(
      context: context,
      initialTime: _timeOfDay,
    );
    setState(() {
      _timeOfDay = picked;
    });
  }

  _CoreFormState(this.formItems);

  void _handleChanged() {
    widget.onChanged(formItems);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: widget.padding ?? EdgeInsets.all(8),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: jsonToForm(),
      ),
    );
  }
}
