import 'dart:async';

import 'package:budget_tracker_ui/json/create_budget_json.dart';
import 'package:budget_tracker_ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../google_sheet_api.dart';

class CreatBudgetPage extends StatefulWidget {
  @override
  _CreatBudgetPageState createState() => _CreatBudgetPageState();
}

class _CreatBudgetPageState extends State<CreatBudgetPage> {
  int activeCategory = 0;
  TextEditingController _textcontrollerAMOUNT = TextEditingController();
  TextEditingController _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
    );
    setState(() {});
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create budget",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      Row(
                        children: [Icon(AntDesign.search1)],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Text(
              "Choose category",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: black.withOpacity(0.5)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(categories.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeCategory = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    width: 150,
                    height: 170,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(
                            width: 2,
                            color: activeCategory == index
                                ? primary
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.01),
                            spreadRadius: 10,
                            blurRadius: 3,
                            // changes position of shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: grey.withOpacity(0.15)),
                              child: Center(
                                child: Image.asset(
                                  categories[index]['icon'],
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              )),
                          Text(
                            categories[index]['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Expense'),
                    Switch(
                      value: _isIncome,
                      onChanged: (newValue) {
                        setState(() {
                          _isIncome = newValue;
                        });
                      },
                    ),
                    Text('Income'),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Expense/Income",
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: black),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textcontrollerITEM,
                        cursorColor: black,
                        style: TextStyle(fontSize: 15, color: black),
                        decoration: InputDecoration(
                            hintText: "For What?", border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Amount",
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (size.width - 140),
                      child: Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    hintText: 'Enter Amount',
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.black54),
                                    border: InputBorder.none),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _enterTransaction();
                          _formKey.currentState!.reset();
                          // showDialog(context: context, builder: BuildContext(context));
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          Icons.arrow_forward,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
