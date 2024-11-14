import 'dart:io';

import 'package:chelancer/api/data_storage_service.dart';
import 'package:chelancer/constant.dart';
import 'package:chelancer/main_view_model.dart';
import 'package:chelancer/ui/cal_view.dart';
import 'package:chelancer/ui/settings_view.dart';
import 'package:chelancer/view_model/cal_view_model.dart';
import 'package:chelancer/view_model/settings_view_model.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmvvm/mvvm_builder.widget.dart';
import 'package:pmvvm/views/hook.view.dart';
import 'package:window_manager/window_manager.dart';

class Destination {
  const Destination(this.title, this.icon, this.selectedIcon);

  final String title;
  final IconData icon;
  final IconData selectedIcon;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataStorage.initSharedPrefs();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await mainViewModel.detectLargeScreenMode();
    });
  }

  runApp(MainPage(mainViewModel));
}

const _brandBlue = Color(0xFF1848AF);
MainViewModel mainViewModel = MainViewModel();

class MainPage extends StatelessWidget {
  final MainViewModel viewModel;

  const MainPage(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM<MainViewModel>(
      view: () => _MainView(),
      viewModel: viewModel,
    );
  }
}

class _MainView extends HookView<MainViewModel> {
  List<Destination> _getDestinations(
      BuildContext context, MainViewModel viewModel) {
    return <Destination>[
      const Destination(calPageName, Icons.calculate_outlined, Icons.calculate),
      const Destination(setPageName, Icons.settings_outlined, Icons.settings),
    ];
  }

  List<Widget> _getNavDrawerChildren(
      BuildContext context, MainViewModel viewModel) {
    return _getDestinations(context, viewModel).map((Destination destination) {
      return NavigationDrawerDestination(
        icon: Icon(destination.icon),
        selectedIcon: Icon(destination.selectedIcon),
        label: Text(destination.title),
      );
    }).toList();
  }

  AppBar _buildWindowsAppBar(BuildContext context, MainViewModel viewModel) {
    return AppBar(
      forceMaterialTransparency: true,
      title: DragToMoveArea(
        child: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.isLargeScreenMode)
                  Text(
                    appName,
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 14),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            windowManager.minimize();
          },
          icon: const Icon(Icons.remove_outlined),
        ),
        IconButton(
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              await windowManager.unmaximize();
            } else {
              await windowManager.maximize();
            }
          },
          icon: const Icon(Icons.crop_square_outlined),
        ),
        IconButton(
          onPressed: () {
            windowManager.close();
          },
          icon: const Icon(Icons.close_outlined),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _switchSelectedPage(MainViewModel viewModel) {
    switch (viewModel.selectedIndex) {
      case 0:
        return CalculationPage(CalculationViewModel());
      case 1:
        return SettingsPage(SettingsViewModel());
      default:
        throw Exception('Invalid index');
    }
  }

  @override
  Widget render(BuildContext context, MainViewModel viewModel) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null &&
            darkDynamic != null &&
            viewModel.isSysColor) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: _brandBlue,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: _brandBlue,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          themeMode: [
            if (viewModel.darkMode == 'Follow system')
              ThemeMode.system
            else if (viewModel.darkMode == 'On')
              ThemeMode.dark
            else
              ThemeMode.light
          ][0],
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).scaffoldBackgroundColor,
              systemNavigationBarColor:
                  Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Scaffold(
              appBar: [
                if (Platform.isWindows)
                  _buildWindowsAppBar(context, viewModel)
                else
                  null
              ][0],
              body: Row(
                children: [
                  if (viewModel.isLargeScreenMode)
                    NavigationDrawer(
                      elevation: 0,
                      selectedIndex: viewModel.selectedIndex,
                      onDestinationSelected: (int index) {
                        viewModel.setSelectedIndex(index);
                      },
                      children: _getNavDrawerChildren(context, viewModel),
                    ),
                  Flexible(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1000,
                        ),
                        child: _switchSelectedPage(viewModel),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: [
                if (viewModel.isLargeScreenMode)
                  null
                else
                  BottomNavigationBar(
                    currentIndex: viewModel.selectedIndex,
                    onTap: (int index) {
                      viewModel.setSelectedIndex(index);
                    },
                    items: _getDestinations(context, viewModel).map(
                      (Destination destination) {
                        return BottomNavigationBarItem(
                          icon: Icon(destination.icon),
                          activeIcon: Icon(destination.selectedIcon),
                          label: destination.title,
                        );
                      },
                    ).toList(),
                  )
              ][0],
            ),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
