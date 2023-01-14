import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import './bmi_body.dart';

class BmiResult extends StatefulWidget {
  static const routeName = '/bmi_result';
  BmiResult({super.key});

  @override
  State<BmiResult> createState() => _BmiResultState();
}

class _BmiResultState extends State<BmiResult> {
  bool _isInit = false;
  late String _situation;
  late double _bmiScore;
  late String _description;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final bmiResult = ModalRoute.of(context)!.settings.arguments as double;
      if (bmiResult < 18.5) {
        _situation = 'Underweight';
        _description =
            'You\'re on the low end of what\'s considered healthy, but you may or may not be at a healthy weight';
      }
      if (bmiResult < 25 && bmiResult >= 18.5) {
        _situation = 'Normal';
        _description = 'You\'re in good health, keep it up !';
      }
      if (bmiResult < 30 && bmiResult >= 25) {
        _situation = 'Overweight';
        _description =
            'You\'re in overweight, you might consider taking actions';
      }
      if (bmiResult >= 30) {
        _situation = 'Obese';
        _description =
            'You\'re in the Obese category, you must take actions for your healthcare';
      }
      _bmiScore = bmiResult;
    }
    _isInit = true;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Color chosenColor() {
    if (_situation == 'Underweight') {
      return Colors.blue;
    }
    if (_situation == 'Normal') {
      return Colors.green;
    }
    if (_situation == 'Overweight') {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final double sheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              child: Text(
                'Your Result',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).accentColor),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _situation,
                          style: TextStyle(color: chosenColor(), fontSize: 35),
                        ),
                        Text(
                          _bmiScore.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).accentColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: AutoSizeText(_description,
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Theme.of(context).accentColor)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                height: sheight / 12,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text(
                    'Calculate Again',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
