import 'package:budget_tracker_ui/pages/root_app.dart';
import 'package:flutter/material.dart';

import 'google_sheet_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RootApp(),
  ));
}
