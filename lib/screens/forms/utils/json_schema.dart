import 'dart:convert';
import 'dart:developer';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class JsonSchema extends StatefulWidget {
  const JsonSchema({
    @required this.form,
    @required this.onChanged,
    this.padding,
    this.formMap,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.buttonSave,
    this.actionSave, this.isValid, this.ptsPoss, this.currentPts, this.isSupervisor, this.supervisorAction,
    this.sectionIndex, this.exists
  });

  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final String form;
  final Map formMap;
  final double padding;
  final Widget buttonSave;
  final Function actionSave;
  final ValueChanged<dynamic> onChanged;
  final ValueChanged<bool> isValid;
  final TotalPtsPossCallback ptsPoss;
  final CurrentPtsCallback currentPts;
  final bool isSupervisor;
  final Function supervisorAction;
  final int sectionIndex;
  final bool exists;

  static bool sectionIsSupervisorOnly(String formStr) {
    var decodedForm = json.decode(formStr);
    bool supervisorOnly = decodedForm['supervisorOnly'] ?? false;
    return supervisorOnly;
  }

  @override
  _CoreFormState createState() =>
      new _CoreFormState(formMap ?? json.decode(form), isSupervisor, exists);
}

class _CoreFormState extends State<JsonSchema> {
  final dynamic formGeneral;
  bool isValid;

  int radioValue;
  String _selectedDate = "Enter date here...";
  String _selectedTime = "Enter time here...";
  TimeOfDay picked;
  // int numOfQs = 0;
  // int numValidQs = 0;
  List<bool> validQs = <bool>[];
  bool runInit = true;
  bool isSupervisor;
  final bool exists;
  bool supervisorOnly = false;
  Function superVisorAction;
  num sectionPts = 0;
  num sectionTotal = 0;
  String scoreStr = "N/A";
  bool includeScore = false;
  bool requiresValidation = false;
  Map<String, bool> chosenCheckboxes = new Map<String, bool>();
  List<String> chosenAnswers = <String>[];

  String isRequired(item, value, count) {
    if (value.isEmpty) {
      // numValidQs--;
      validQs[count] = false;
      _isValid();
      return widget.errorMessages[item['key']] ?? 'Please enter some text';
    }
    return null;
  }

  String validateEmail(item, String value) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  bool labelHidden(item) {
    if (item.containsKey('hiddenLabel')) {
      if (item['hiddenLabel'] is bool) {
        return !item['hiddenLabel'];
      }
    } else {
      return true;
    }
    return false;
  }
  // Return widgets

  List<Widget> jsonToForm() {
    List<Widget> listWidget = new List<Widget>();
    if (formGeneral['title'] != null) {
      listWidget.add(Text(
        formGeneral['title'],
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ));
    }
    if (formGeneral['description'] != null) {
      listWidget.add(Text(
        "$supervisorOnly, ${formGeneral['description']}",
        style: new TextStyle(fontSize: 14.0,fontStyle: FontStyle.italic),
      ));
    }

    for (var count = 0; count < formGeneral['fields'].length; count++) {
      Map item = formGeneral['fields'][count];
      bool supervisorRestricted = item['supervisorOnly'] ?? false;
      if (supervisorRestricted && isSupervisor != true) {
        continue;
      }

      if (item['type'] == "Input" ||
          item['type'] == "Password" ||
          item['type'] == "Email" ||
          item['type'] == "TextArea" ||
          item['type'] == "TextInput" ||
          item['type'] == "Numeric" ||
          item['type'] == "Header") {
        Widget label = SizedBox.shrink();
        if (labelHidden(item)) {
          label = new Container(
            child: new Text(
              // "$supervisorOnly, ${item['label']}",
              item['label'],
              style: item['type'] == "Header" ? TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)
              : TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          );
          // if (item['type'] == "Header") {
          //   continue;
          // }
        }

        listWidget.add(new Container(
          margin: new EdgeInsets.only(top: 5.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              label,
              if (item['type'] != "Header") new TextFormField(
                controller: null,
                keyboardType: item['type'] == "Numeric" ? TextInputType.number :
                TextInputType.text,
                initialValue: formGeneral['fields'][count]['value']??"",
                decoration: item['decoration'] ??
                    widget.decorations[item['key']] ??
                    new InputDecoration(
                      hintText: item['placeholder'] ?? "",
                      helperText: item['helpText'] ?? "",
                      hintStyle: TextStyle(color: Colors.grey)
                    ),
                maxLines: item['type'] == "TextArea" ? 10 : 1,
                onChanged: (String value) {
                  formGeneral['fields'][count]['value'] = value;
                  _handleChanged();
                  // an input is valid if it's not empty, or if no input is required (usually elaboration for 'other' answers)
                  validQs[count] = ((value != null/* && value.length > 0*/) || (item['required'] == null || !item['required']));
                  _isValid();
                },
                obscureText: item['type'] == "Password" ? true : false,
                validator: (value) {
                  if (widget.validations.containsKey(item['key'])) {
                    return widget.validations[item['key']](item, value);
                  }
                  if (item.containsKey('validator')) {
                    if (item['validator'] != null) {
                      if (item['validator'] is Function) {
                        return item['validator'](item, value);
                      }
                    }
                  }
                  if (item['type'] == "Email") {
                    return validateEmail(item, value);
                  }

                  if (item.containsKey('required')) {
                    if (item['required'] == true ||
                        item['required'] == 'True' ||
                        item['required'] == 'true') {
                      return isRequired(item, value, count);
                    }
                  }

                  return null;
                },
              ),
            ],
          ),
        ));
      }

      if (item['type'] == "DatePicker") {
        if (formGeneral['fields'][count]['value'] == null) {
          formGeneral['fields'][count]['value'] = DateTime.now().toString();
        } else {
          _selectedDate = DateFormat.yMMMd("en_US").format(DateTime.parse(formGeneral['fields'][count]['value'])).toString();
        }
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
            _openDatePicker(context, count);
          },
        ));
      }
      if (item['type'] == "TimePicker") {
        var now = new DateTime.now();
        if (formGeneral['fields'][count]['value'] == null) {
          formGeneral['fields'][count]['value'] = DateFormat('kk:mm:a').format(now);
        } else {
          _selectedTime = formGeneral['fields'][count]['value'];
        }
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
            _openTimePicker(context, count);
          },
        ));
      }


      if (item['type'] == "RadioButton") {
        List<Widget> radios = [];
        // validQs[count] = (!formGeneral['required'] || formGeneral['fields'][count]['value'] != null);

        if (labelHidden(item) && item['label'].length > 0) {
          radios.add(new Text(item['label'],
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)));
        }
        if (item['isDisabled'] == true) {
          radios.add(new Text(
              "\nNote: This question's score is calculated based off your answers to the following subquestions.",
              style: new TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic)));
        }
        radioValue = item['value'];
        for (var i = 0; i < item['items'].length; i++) {
          radios.add(
            new Row(
              children: <Widget>[
                new Radio<int>(
                    value: formGeneral['fields'][count]['items'][i]['value'],
                    groupValue: radioValue,
                    onChanged: (int value) {
                      if (formGeneral['fields'][count]['isDisabled'] != true) {
                        this.setState(() {
                          radioValue = value;
                          int oldValue = formGeneral['fields'][count]['value'];
                          formGeneral['fields'][count]['value'] = value;
                          // if question is a yes/no/partial question and counts towards total (no followups), use switch case
                          if (formGeneral['fields'][count]['ynpQuestion'] == true) {
                            switch (value) {
                              case 4: // if N/A is chosen AND the rest of the associated subquestions are marked as N/A,
                                // reduce total points possible to not count this question towards the total score
                                // else, count as yes and continue as normal
                                // TODO: add logic for N/A answers
                                formGeneral['fields'][count]['ignore'] =
                                true;
                                // if question switches from yes to N/A, subtract points for this question
                                if (oldValue == 1) {
                                  sectionPts -= formGeneral['fields'][count]['totals'];
                                } else if (oldValue == 3) { // else if question switches from partial to N/A, subtract 1 point
                                  sectionPts -= 1;
                                }
                                sectionTotal -= formGeneral['fields'][count]['totals'];
                                formGeneral['fields'][count]['points'] = 0;
                                widget.ptsPoss(-formGeneral['fields'][count]['totals'], widget.sectionIndex);
                                changeScore();
                                break;
                              case 1: // yes or N/A (if something's not applicable, then it shouldn't count against survey score)
                              // if question is marked as "ignore" (N/A was previously chosen) then
                              // remove "ignore" and count points towards total
                                if (formGeneral['fields'][count]['ignore'] == true) {
                                  sectionTotal +=
                                  formGeneral['fields'][count]['totals'];
                                  formGeneral['fields'][count]['ignore'] =
                                  false;
                                  widget.ptsPoss(formGeneral['fields'][count]['totals'], widget.sectionIndex);
                                }
                                // if the question is not a yes/no/partial or subquestion (subquestion or ynpQuestion), parse as normal
                                if (formGeneral['fields'][count]['subquestion'] != true && formGeneral['fields'][count]['ynpQuestion'] == true && formGeneral['fields'][count]['totals'] != null) {
                                  num diff = formGeneral['fields'][count]['totals'] - (formGeneral['fields'][count]['points'] == null ? 0 : formGeneral['fields'][count]['points']);
                                  log("totals is: ${formGeneral['fields'][count]['totals']}");
                                  log("2nd half is: ${(formGeneral['fields'][count]['points'] == null ? 0 : formGeneral['fields'][count]['points'])}");
                                  log("selected yes, diff is $diff");
                                  sectionPts += diff;
                                  log("selected yes, is integer: ${sectionPts == sectionPts.roundToDouble()}");
                                  if (sectionPts == sectionPts.roundToDouble()) {
                                    sectionPts = sectionPts.truncate();
                                  }
                                  formGeneral['fields'][count]['points'] = formGeneral['fields'][count]['totals'];
                                } else if (formGeneral['fields'][count]['subquestion'] == true && formGeneral['fields'][count]['ynpQuestion'] == true) {  // else, calculate subquestion answer into parent question score
                                  // get other subquestions with corresponding parent key
                                  List<dynamic> myList = formGeneral['fields'];
                                  var parentQ = myList.where((item) => item['key'] == formGeneral['fields'][count]['parent']).elementAt(0); // locate parent question in form
                                  Iterable<dynamic> newList = myList.where((item) => item['subquestion'] == true && item['parent'] == parentQ['key']);  // locate other subquestions
                                  int indexOfParent = formGeneral['fields'].indexOf(parentQ);
                                  int newScore = calculateSubquestionScore(newList, parentQ['totals']); // calculate new score from subquestions

                                  int oldScore = formGeneral['fields'][indexOfParent]['points'] != null ? formGeneral['fields'][indexOfParent]['points'] : 0;
                                  sectionPts = sectionPts - oldScore + newScore;
                                  changeScore();  // update UI to show new score
                                  formGeneral['fields'][indexOfParent]['points'] = newScore;
                                  formGeneral['fields'][indexOfParent]['value'] = pointsToValue(newScore);
                                }
                                break;
                              case 2: // no
                              // if question is marked as "ignore" (N/A was previously chosen) then
                              // remove "ignore" and count points towards total
                                if (formGeneral['fields'][count]['ignore'] == true) {
                                  sectionTotal += formGeneral['fields'][count]['totals'];
                                  formGeneral['fields'][count]['ignore'] = false;
                                  widget.ptsPoss(formGeneral['fields'][count]['totals'], widget.sectionIndex);
                                }
                                // if the question is not a yes/no/partial subquestion (subquestion and ynpQuestion), parse as normal
                                if (formGeneral['fields'][count]['subquestion'] != true && formGeneral['fields'][count]['ynpQuestion'] == true) {
                                  num diff = 0 - (formGeneral['fields'][count]['points'] == null ? 0 : formGeneral['fields'][count]['points']);
                                  sectionPts += diff;
                                  if (sectionPts == sectionPts.roundToDouble()) {
                                    sectionPts = sectionPts.truncate();
                                  }
                                  formGeneral['fields'][count]['points'] = 0;
                                } else if (formGeneral['fields'][count]['subquestion'] == true && formGeneral['fields'][count]['ynpQuestion'] == true)  {  // else, calculate subquestion answer into parent question score
                                  // get other subquestions with corresponding parent key
                                  List<dynamic> myList = formGeneral['fields'];
                                  var parentQ = myList.where((item) => item['key'] == formGeneral['fields'][count]['parent']).elementAt(0);
                                  Iterable<dynamic> newList = myList.where((item) => item['subquestion'] == true && item['parent'] == parentQ['key']);
                                  int indexOfParent = formGeneral['fields'].indexOf(parentQ);

                                  // get other subquestions with corresponding parent key
                                  num newScore = calculateSubquestionScore(newList, parentQ['totals']); // calculate new score from subquestions

                                  num oldScore = formGeneral['fields'][indexOfParent]['points'] != null ? formGeneral['fields'][indexOfParent]['points'] : 0;
                                  log("newScore: $newScore");
                                  log("oldScore: $oldScore");
                                  sectionPts = sectionPts - oldScore + newScore;
                                  if (sectionPts == sectionPts.roundToDouble()) {
                                    sectionPts.truncate();
                                  }
                                  changeScore();  // update UI to show new score
                                  formGeneral['fields'][indexOfParent]['points'] = newScore;
                                  formGeneral['fields'][indexOfParent]['value'] = pointsToValue(newScore);
                                }
                                break;
                              case 3: // partial
                                if (formGeneral['fields'][count]['ignore'] == true) {
                                  sectionTotal += formGeneral['fields'][count]['totals'];
                                  formGeneral['fields'][count]['ignore'] = false;
                                  widget.ptsPoss(formGeneral['fields'][count]['totals'], widget.sectionIndex);
                                }
                                // if the question is not a yes/no/partial subquestion (subquestion and ynpQuestion), parse as normal
                                if (formGeneral['fields'][count]['subquestion'] != true && formGeneral['fields'][count]['ynpQuestion'] == true) {
                                  num partialValue = formGeneral['fields'][count]['totals'] == 1 ? 0.5 : 1;
                                  num diff = partialValue - (formGeneral['fields'][count]['points'] == null ? 0 : formGeneral['fields'][count]['points']);
                                  sectionPts += diff;
                                  if (sectionPts == sectionPts.roundToDouble()) {
                                    sectionPts = sectionPts.truncate();
                                  }
                                  formGeneral['fields'][count]['points'] = formGeneral['fields'][count]['totals'] == 1 ? 0.5 : 1;
                                } else if (formGeneral['fields'][count]['subquestion'] == true && formGeneral['fields'][count]['ynpQuestion'] == true) {  // else, calculate subquestion answer into parent question score
                                  // get other subquestions with corresponding parent key
                                  List<dynamic> myList = formGeneral['fields'];
                                  var parentQ = myList.where((item) => item['key'] == formGeneral['fields'][count]['parent']).elementAt(0);
                                  Iterable<dynamic> newList = myList.where((item) => item['subquestion'] == true && item['parent'] == parentQ['key']);
                                  int indexOfParent = formGeneral['fields'].indexOf(parentQ);

                                  // get other subquestions with corresponding parent key
                                  int newScore = calculateSubquestionScore(newList, parentQ['totals']); // calculate new score from subquestions

                                  int oldScore = formGeneral['fields'][indexOfParent]['points'] != null ? formGeneral['fields'][indexOfParent]['points'] : 0;

                                  // log("newScore: $newScore");
                                  // log("oldScore: $oldScore");
                                  sectionPts = sectionPts - oldScore + newScore;
                                  changeScore();  // update UI to show new score
                                  formGeneral['fields'][indexOfParent]['points'] = newScore;
                                  formGeneral['fields'][indexOfParent]['value'] = pointsToValue(newScore);
                                }
                                break;
                            }
                            changeScore();
                            validQs[count] = ((value != null) || (!formGeneral['fields'][count]['required']));
                            _isValid();
                            _handleChanged();
                            _currentPtsChanged();
                          } else {
                            changeScore();
                            validQs[count] = ((value != null) || (!formGeneral['fields'][count]['required']));
                            _isValid();
                            _handleChanged();
                            formGeneral['fields'][count]['value'] = value;
                          }
                        });
                      }
                    }),
                new Expanded(
                    child: new Text(
                        formGeneral['fields'][count]['items'][i]['label'])),
              ],
            ),
          );

          // if there's a description attached to the radio button choice, add it here
          if (item['items'][i]['description'] != null)
            radios.add(Padding(child: Text(formGeneral['fields'][count]['items'][i]['description'] + "\n\n",
                style: new TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic)), padding: EdgeInsets.only(left: 20.0, right: 10.0),));

        }

        listWidget.add(Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: radios,
            )));
      }


      if (item['type'] == "Switch") {
        if (item['value'] == null) {
          formGeneral['fields'][count]['value'] = false;
        }
        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Row(children: <Widget>[
              new Expanded(child: new Text(item['label'])),
              new Switch(
                value: item['value'] ?? false,
                onChanged: (bool value) {
                  this.setState(() {
                    formGeneral['fields'][count]['value'] = value;
                    _handleChanged();
                  });
                },
              ),
            ]),
          ),
        );
      }

      if (item['type'] == "Checkbox") {
        List<Widget> checkboxes = [];
        if (labelHidden(item)) {
          checkboxes.add(new Text(item['label'],
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)));

        }
        for (var i = 0; i < item['items'].length; i++) {
          checkboxes.add(
            new Row(
              children: <Widget>[
                new Checkbox(
                  value: formGeneral['fields'][count]['items'][i]['value'],
                  onChanged: (bool value) {
                    this.setState(() {
                      formGeneral['fields'][count]['items'][i]['value'] = value;
                      // chosenCheckboxes[i.toString()] = value;
                      // log("chosenCheckboxes: $chosenCheckboxes");
                      // log("chosenCheckboxes[$i]: ${chosenCheckboxes[i]}");
                      // log("chosen answers:");
                      // chosenCheckboxes.forEach((key, value) {
                      //   if (value == true) {
                      //     log("${formGeneral['fields'][count]['items'][int.parse(key)]['label']}");
                      //   }
                      // });
                      // var arr = [1,2,3];
                      // formGeneral['fields'][count]['value'] = jsonEncode(arr);
                      // log("${formGeneral['fields'][count]['value']}");
                      // formGeneral['fields'][count]['value'] = jsonEncode(chosenCheckboxes);
                      // log("${formGeneral['fields'][count]['value']}");
                      String str = formGeneral['fields'][count]['items'][i]['label'];
                      if (!chosenAnswers.contains(str) && value == true) {
                        chosenAnswers.add(str);
                        log("chosenAnswers: $chosenAnswers}");
                        formGeneral['fields'][count]['value'] = jsonEncode(chosenAnswers);
                      }
                      if (chosenAnswers.contains(str) && value == false) {
                        chosenAnswers.remove(str);
                        log("chosenAnswers: $chosenAnswers}");
                        formGeneral['fields'][count]['value'] = jsonEncode(chosenAnswers);
                      }
                      _handleChanged();
                    });
                  },
                ),
                new Expanded(
                    child: new Text(
                        formGeneral['fields'][count]['items'][i]['label'])),
              ],
            ),
          );

          // if there's a description attached to the radio button choice, add it here
          if (item['items'][i]['description'] != null)
            checkboxes.add(Padding(child: Text(formGeneral['fields'][count]['items'][i]['description'] + "\n\n",
                style: new TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic)), padding: EdgeInsets.only(left: 20.0, right: 10.0),));
        }

        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: checkboxes,
            ),
          ),
        );
      }

      if (item['type'] == "Select") {
        Widget label = SizedBox.shrink();
        if (labelHidden(item)) {
          label = new Text(item['label'],
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0));
        }
        listWidget.add(new Container(
          margin: new EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              label,
              new DropdownButton<String>(
                hint: new Text(item['placeholder'] != null ? item['placeholder'] : "Select a laboratory"),
                value: formGeneral['fields'][count]['value'],
                onChanged: (String newValue) {
                  setState(() {
                    formGeneral['fields'][count]['value'] = newValue;
                    _handleChanged();
                  });
                },
                items:
                item['items'].map<DropdownMenuItem<String>>((dynamic data) {
                  return DropdownMenuItem<String>(
                    value: data['value'],
                    child: new Text(
                      data['label'],
                      style: new TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ));
      }

      if (item['type'] == "Summary" || item["type"] == "summary") {
        listWidget.add(new Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                Divider(color: Colors.black),
                Container(
                  child: Text(
                      item['label'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.only(left: 5.0, right: 5.0)
                ),
                Expanded(child: Container()),
                Container(
                  child: Text(item['value'], textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
                  // width: MediaQuery.of(context).size.width * 0.2
                ),

              ],
            )
            // child: Text(item['label'] + item['value'],
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),)
        ));
      }

      // // add a description if specified
      // if (item['description'] != null) {
      //   listWidget.add(new Text(
      //       "\n${item['description']}",
      //       style: new TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic)));
      // }
    }

    _isValid();

    if (widget.buttonSave != null) {
      listWidget.add(new Container(
        margin: EdgeInsets.only(top: 10.0),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState.validate()) {
              widget.actionSave(formGeneral);
            }
          },
          child: widget.buttonSave,
        ),
      ));
    }
    return listWidget;
  }

  Future<void>_openDatePicker(BuildContext context, int count) async {
    final DateTime d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: new DateTime(2018), lastDate: new DateTime(2025));
    if (d != null) {
      setState(() {
        _selectedDate = DateFormat.yMMMd("en_US").format(d).toString();
        formGeneral['fields'][count]['value'] = d.toString();
        _handleChanged();
        validQs[count] = (d.toString() != null && d.toString().length > 0 || (!formGeneral['fields'][count]['required']));
        _isValid();
      });
    }
  }

  Future<void> _openTimePicker(BuildContext context, int count) async {
    final TimeOfDay time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        _selectedTime = time.format(context);
        formGeneral['fields'][count]['value'] = time.format(context);
        _handleChanged();
        // an input is valid if it's not empty, or if no input is required (usually elaboration for 'other' answers)
        validQs[count] = ((time.format(context) != null && time.format(context).length > 0) || (!formGeneral['fields'][count]['required']));
        _isValid();
      });
    }
  }

  int pointsToValue(int points) {
    if (points > 1) {
      return 1;
    } else if (points == 1) {
      return 3;
    } else {
      return 2;
    }
  }

  void changeScore() {
    if (includeScore) {
      debugPrint("changeScore() called");
      scoreStr = "$sectionPts / $sectionTotal";
      formGeneral['fields'][formGeneral['fields'].length - 1]['value'] = scoreStr;
    }
  }

  num calculateSubquestionScore(Iterable<dynamic> subquestions, int total) {
    debugPrint("calculateSubquestionScore(Iterable<dynamic>, int) called");
    int yesCount = 0, noCount = 0;
    // check list of subquestions for combo of answers
    // all partial answers, or 1 partial answer -> 1 point awarded
    // all yes answers -> full points awarded
    // all no answers -> no points awarded
    // some yes, some no, no partial answers -> 1 point awarded
    // N/A is chosen (for sub) -> don't count towards total
    // all N/A answers -> do not count parent question towards pt total
    // ex: if a 21 pt question has a 2 pt question marked as N/A, take total out of 19 pts instead of 21
    for (var sub in subquestions) {
      if (sub['value'] == 3) {  // if ans is partial, then parent question gets 1 pt
        if (total == 1) { // if total is worth 1 pt, partial credit is worth 0.5 pts
          // log("at end, returning 0.5");
          return 0.5;
        }
        return 1;
      } else if (sub['value'] == 1 || sub['value'] == 4) { // if ans is yes or N/A, add to yes count
        yesCount++;
      } else if (sub['value'] == 2) { // if ans is no, continue?
        noCount++;
      }
    }
    // if all questions are answered "yes" award full pts
    if (yesCount == subquestions.length) {
      return total;
    } else if (noCount == subquestions.length) {  // all "no"s, award 0 pts
      return 0;
    } else {  // if results are mixed, count as partial, award 1 pt or 0.5 pt if question is worth 1 pt
      if (total == 1) {
        // log("AT END, RETURNING 0.5");
        return 0.5;
      }
      return 1;
    }
  }

  _CoreFormState(this.formGeneral, this.isSupervisor, this.exists);

  @override
  void initState() {
    int tempTotal = 0;
    for (int i = 0; i < formGeneral['fields'].length; i++) {
      validQs.add(false);
      sectionTotal += formGeneral['fields'][i]['totals'] != null ? formGeneral['fields'][i]['totals'] : 0;
    }
    log("tempTotal: $tempTotal");
    includeScore = formGeneral['includeScore'] ?? false;
    requiresValidation = formGeneral['autoValidated'] ?? false;
    if (includeScore) {
      sectionPts = 0;
      getPtsPoss();
    }

    // set points earned and total points for saved forms
    // check if form has been saved or is new AND if last section is the summary
    int lastIndex = formGeneral['fields'].length - 1;
    if (exists && formGeneral['fields'][lastIndex]['type'].toString().toLowerCase() == "summary") {
      List<String> nums = formGeneral['fields'][lastIndex]['value'].toString().split(" ");
      try {
        sectionPts = int.parse(nums[0]); // if the numerator is a number, parse it. else, use default of 0
      } on Exception catch (_) {
        sectionPts = 0;
      } on RangeError catch (_) {
        sectionPts = 0;
      }
      try {
        sectionTotal = int.parse(nums[2]); // if the denominator is a number, parse it. else use value of tempTotal
      } on Exception catch (_) { } on RangeError catch (_) { }
    }

    super.initState();
  }

  void _handleChanged() {
    widget.onChanged(formGeneral);
  }

  void _currentPtsChanged() {
    widget.currentPts(sectionPts, widget.sectionIndex);
  }

  void _isValid() {
    requiresValidation = false;
    if (requiresValidation) {
      for (bool b in validQs) {
        if (!b) {
          widget.isValid(false);
          return;
        }
      }
      widget.isValid(true);
    }
  }

  void getPtsPoss() {
    widget.ptsPoss(sectionTotal, widget.sectionIndex);
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      autovalidate: formGeneral['autoValidated'] ?? false,
      key: _formKey,
      child: new Container(
        padding: new EdgeInsets.all(widget.padding ?? 8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: jsonToForm(),
        ),
      ),
    );
  }
}

typedef void TotalPtsPossCallback(num val, int index);
typedef void CurrentPtsCallback(num val, int index);
