// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace
import 'dart:math';

import 'package:bmi/bmi_result.dart';
import 'package:flutter/material.dart';

import 'color.dart';

class BmiBody extends StatefulWidget with ChangeNotifier {
  BmiBody({super.key});

  @override
  State<BmiBody> createState() => _BmiBodyState();
}

class _BmiBodyState extends State<BmiBody> {
  int _height = 180;
  int _weight = 70;
  int _age = 20;
  bool _isMale = false;
  bool _isFemale = false;
  late double _bmiScore;
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _form = GlobalKey<FormState>();

  changeWeight(String sign) {
    setState(() {
      if (sign == '+' && _weight < 150) {
        _weight++;
      }
      if (sign == '-' && _weight > 39) {
        _weight--;
      }
    });
  }

  changeAge(String sign) {
    setState(() {
      if (sign == '+' && _age < 65 ) {
        _age++;
      }
      if (sign == '-' && _age > 14) {
        _age--;
      }
    });
  }

  void validateWeight(BuildContext ctx) {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    Navigator.of(ctx).pop();
    setState(() {
      _weight = int.parse(_weightController.text);
    });
    _weightController.clear();
  }

  void validateAge(BuildContext ctx) {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    Navigator.of(ctx).pop();
    setState(() {
      _age = int.parse(_ageController.text);
    });
    _ageController.clear();
  }

  changeWeightManual(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Weight"),
            actions: [
              TextButton(
                onPressed: () {
                  validateWeight(ctx);
                },
                child: Text('Done'),
              )
            ],
            content: Form(
              key: _form,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _weightController,
                decoration: InputDecoration(labelText: "Weight"),
                onEditingComplete: () {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (int.parse(value) < 40 || int.parse(value) > 150) {
                    return 'Please enter a weight between 40Kg and 150Kg';
                  }
                  return null;
                },
              ),
            ),
          );
        });
  }

  changeAgeManual(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Age"),
            actions: [
              TextButton(
                onPressed: () {
                  validateAge(ctx);
                },
                child: Text('Done'),
              )
            ],
            content: Form(
              key: _form,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _ageController,
                decoration: InputDecoration(labelText: "Age"),
                onEditingComplete: () {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (int.parse(value) < 14 || int.parse(value) > 65) {
                    return 'Please enter an age between 14 and 65';
                  }
                  return null;
                },
              ),
            ),
          );
        });
  }

  void calculateBmi(BuildContext ctx) {
    if (!_isMale && !_isFemale) {
      return;
    }
    _bmiScore = _weight / pow(2, (_height * 0.01));
    Navigator.pushNamed(ctx, BmiResult.routeName,arguments: _bmiScore);
  }

  @override
  Widget build(BuildContext context) {
    final double sheight = MediaQuery.of(context).size.height;
    final double swidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text('BMI'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              //Male and Female widgets
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMale = true;
                          _isFemale = false;
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          height: sheight / 5,
                          width: swidth / 2.5,
                          color: _isMale ? male : Colors.white,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(
                              Icons.male,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMale = false;
                          _isFemale = true;
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          height: sheight / 5,
                          width: swidth / 2.5,
                          color: _isFemale ? female : Colors.white,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(
                              Icons.female,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Height Widget
              Card(
                elevation: 5,
                margin: EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Text(
                        'Height',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${_height.toString()}cm',
                        style: TextStyle(fontSize: 35),
                      ),
                      Slider(
                          value: _height.toDouble(),
                          onChanged: (newValue) {
                            setState(() {
                              _height = newValue.round();
                            });
                          },
                          max: 230,
                          min: 140)
                    ],
                  ),
                ),
              ),
              //Weight and Age widgets
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      child: Container(
                        height: sheight / 5,
                        width: swidth / 2.5,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            Text(
                              'Weight',
                              style: TextStyle(fontSize: 15),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            GestureDetector(
                              onTap: () {
                                changeWeightManual(context);
                              },
                              child: Text(
                                '${_weight.toString()}kg',
                                style: TextStyle(fontSize: 35),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.grey,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      changeWeight('+');
                                    },
                                  ),
                                ),
                                Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.grey,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      changeWeight('-');
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      child: Container(
                        height: sheight / 5,
                        width: swidth / 2.5,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            Text(
                              'Age',
                              style: TextStyle(fontSize: 15),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            GestureDetector(
                              onTap: () {
                                changeAgeManual(context);
                              },
                              child: Text(
                                _age.toString(),
                                style: TextStyle(fontSize: 35),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.grey,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      changeAge('+');
                                    },
                                  ),
                                ),
                                Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.grey,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      changeAge('-');
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Container(
                  height: sheight / 12,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      calculateBmi(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      'Calculate',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
