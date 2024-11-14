import 'package:advance_math/advance_math.dart';
import 'package:fraction/fraction.dart' as fc;

class Equation {
  String raw = '';
  int varCount = 0;

  // String (Chemical element) ->
  // List<int>
  // (counts of the element in every formulars
  // which also act as the coefficients in linear equation system)
  Map map = {};

  final String plus = '+';
  final String equal = '=';

  Equation(this.raw) {
    buildMap();
    List<String> coes = solve();
    apply(coes);
  }

  void buildMap() {
    // Index of formular in the equation
    int curIndex = 0;

    // Current chemical element
    String curEle = '';

    // Current sign of coefficient
    int curSign = 1;

    for (var i = 0; i < raw.length; i++) {
      String char = raw[i];

      if (char == plus) {
        curIndex += 1;
      } else if (char == equal) {
        curIndex += 1;

        // When come to the right hand side of the equation, sign = -1
        // which means we need to move coefficient to the left side to build
        // a linear equation system to be solved later on
        curSign = -1;
      } else if (char.isValidNumeric()) {
        int coe = Integer.parse(char).value;
        List<int> oldCoes = map[curEle];
        int newLastCoe = oldCoes.removeLast() + curSign * (coe - 1);
        map[curEle] = oldCoes + [newLastCoe];
      } else if (char.isAlpha()) {
        curEle = char;
        List<int> oldCoes = [];
        if (map.keys.contains(curEle)) {
          oldCoes = map[curEle];
        } else {
          map[curEle] = oldCoes;
        }

        int coesSize = oldCoes.length;

        // Indicate that same element appeared in the same chemical formular
        if (curIndex < coesSize) {
          int newLastCoe = oldCoes.removeLast() + curSign * 1;
          map[curEle] = oldCoes + [newLastCoe];
        } else {
          // To fill out the gaps where the element didn't appear on some successive formulars
          map[curEle] =
              map[curEle] + List.filled(curIndex - coesSize, 0) + [curSign * 1];
        }
      } else {
        Exception('Illegal input.');
      }

      varCount = curIndex + 1;
    }
  }

  List<String> solve() {
    List<List<int>> coes = map.values.toList().cast<List<int>>();
    for (var row in coes) {
      int rowSize = row.length;
      if (rowSize < varCount) {
        row.addAll(List.filled(varCount - rowSize, 0));
      }
    }

    Matrix leftMatrix = Matrix.fromList(coes).appendRows(Matrix.fromList([
      [1] + List.filled(varCount - 1, 0)
    ]));

    Matrix rightMatrix =
        Matrix.fromList(List.filled(leftMatrix.rowCount - 1, [0]) +
            [
              [1]
            ]);

    print(leftMatrix);
    print(rightMatrix);

    Matrix x = leftMatrix.linear
        .solve(rightMatrix, method: LinearSystemMethod.gramSchmidt);

    print(x);

    return x
        .transpose()
        .toList()[0]
        .cast<double>()
        .map<String>((ele) => fc.Fraction.fromDouble(ele).toString())
        .toList();
  }

  void apply(List<String> coes) {
    // Remove all spaces
    raw = raw.trim().replaceAll(RegExp(' '), '');
    int curIndex = 0;

    while (curIndex < raw.length) {
      String curChar = raw[curIndex];
      String replacement = "";

      if (curIndex == 0 || curChar == plus || curChar == equal) {
        String curCoe = coes.first.toString();
        coes = coes.sublist(1, coes.length);

        if (curIndex == 0) {
          replacement = '$curCoe ';
        } else if (curChar == plus || curChar == equal) {
          replacement = ' $curChar $curCoe ';
        }

        if (curIndex == 0) {
          raw = replacement + raw;
          curIndex += 1;
        } else {
          raw = raw.substring(0, curIndex) +
              replacement +
              raw.substring(curIndex + 1);

          // Due to space added before + or =, next index should +2
          curIndex += 2;
        }
      } else {
        curIndex += 1;
      }
    }
  }
}
