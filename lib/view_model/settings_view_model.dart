import 'package:chelancer/api/data_storage_service.dart';
import 'package:chelancer/constant.dart';
import 'package:chelancer/main.dart';
import 'package:pmvvm/pmvvm.dart';

class SettingsViewModel extends ViewModel {
  final String pageName = setPageName;

  String darkMode = DataStorage.defaultValueDarkMode;
  bool isSysColor = DataStorage.defaultValueIsSysColor;

  // Optional
  @override
  void init() {
    // It's called after the MVVM widget's initState is called
    _loadSettings();
  }

  // Optional
  @override
  void onBuild() {
    // A callback when the `build` method of the view is called.
  }

  _loadSettings() {
    darkMode = DataStorage.prefs!.getString(DataStorage.keyDarkMode) ??
        DataStorage.defaultValueDarkMode;
    isSysColor = DataStorage.prefs!.getBool(DataStorage.keyIsSysColor) ?? false;
    notifyListeners();
  }

  void setDarkMode(String value) {
    DataStorage.prefs!.setString(DataStorage.keyDarkMode, value);
    darkMode = value;
    notifyListeners();
    mainViewModel.setDarkMode(value);
  }

  void setIsSysColor(bool value) {
    DataStorage.prefs!.setBool(DataStorage.keyIsSysColor, value);
    isSysColor = value;
    notifyListeners();
    mainViewModel.setIsSysColor(value);
  }
}
