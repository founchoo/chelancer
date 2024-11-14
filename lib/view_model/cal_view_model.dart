import 'package:chelancer/constant.dart';
import 'package:chelancer/util/equation.dart';
import 'package:flutter/widgets.dart';
import 'package:pmvvm/pmvvm.dart';

class CalculationViewModel extends ViewModel {
  final String pageName = calPageName;

  TextEditingController eqController = TextEditingController();

  void balancify() {
    String raw = eqController.text;
    Equation eq = Equation(raw);
    eqController.text = eq.raw;
  }
}
