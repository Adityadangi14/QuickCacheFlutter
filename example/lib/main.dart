import 'package:flutter/material.dart';
import 'package:quick_cache_flutter/quick_cache_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  QuickCacheFlutter.init(
      globalCacheSettingParams: GlobalCacheSettingParams(
          activeCleaning: true,
          globalExpiryDuration: const Duration(minutes: 5),
          maxCacheSize: 5000));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  ValueNotifier<dynamic> cachedString = ValueNotifier('');
  String key = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: textEditingController,
          ),
          ElevatedButton(
              onPressed: () async {
                key = DateTime.now().millisecondsSinceEpoch.toString();
                QuickCacheFlutter.instance.setCache(
                    key: key,
                    value: "value",
                    expiryDuration: const Duration(minutes: 20));
              },
              child: const Text('Add cache')),
          ElevatedButton(
              onPressed: () async {
                var value =
                    await QuickCacheFlutter.instance.readCache(key: key);
                cachedString.value = value;
              },
              child: const Text('get cache')),
          ElevatedButton(
              onPressed: () async {
                QuickCacheFlutter.instance.deleteValue(key: key);
              },
              child: const Text('Delete cache')),
          ValueListenableBuilder(
            valueListenable: cachedString,
            builder: (context, value, child) {
              return Text('$value');
            },
          ),
        ],
      ),
    );
  }
}
