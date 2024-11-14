import 'package:chelancer/constant.dart';
import 'package:chelancer/view_model/cal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';

class CalculationPage extends StatelessWidget {
  final CalculationViewModel viewModel;

  const CalculationPage(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM<CalculationViewModel>(
      view: () => _GradeView(),
      viewModel: viewModel,
    );
  }
}

class _GradeView extends HookView<CalculationViewModel> {
  @override
  Widget render(BuildContext context, CalculationViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.pageName),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Input chemical equation',
                border: OutlineInputBorder(),
              ),
              controller: viewModel.eqController,
            ),
            const SizedBox(
              height: defaultMargin,
            ),
            Row(
              children: [
                FilledButton(
                    onPressed: () {
                      viewModel.eqController.text = 'C6H5COOH + O2 = CO2 + H2O';
                    },
                    child: const Text('Input test case')),
                const SizedBox(
                  width: defaultMargin,
                ),
                FilledButton(
                    onPressed: () {
                      viewModel.balancify();
                    },
                    child: const Text('Balance'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
