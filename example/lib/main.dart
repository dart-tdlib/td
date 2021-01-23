import 'package:flutter/material.dart';
import 'package:td/td_api.dart' as TdApi;
import 'package:td/td_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _tdlibVersion = "Unknown";
  TelegramService _telegramService;

  @override
  void initState() {
    super.initState();
    _initClient();
  }

  Future<void> _initClient() async {
    _telegramService = TelegramService();
    await _telegramService.initClient();
    _telegramService.events.stream.listen((update) {
      if (update is TdApi.UpdateOption) {
        if (update.name == "version")
          setState(() =>
              _tdlibVersion = (update.value as TdApi.OptionValueString).value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('TdLib version: $_tdlibVersion'),
      ),
    );
  }

  @override
  void dispose() {
    _telegramService.dispose();
    super.dispose();
  }
}
