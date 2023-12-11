import 'package:flutter/material.dart';
import 'package:quick_cache_flutter/quick_cache_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  QuickCacheFlutter.instance.init();
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
                QuickCacheFlutter.instance.setCache(
                    key: 'testDuration',
                    value: textEditingController.text,
                    expiryDuration: const Duration(seconds: 20));
              },
              child: const Text('Add cache')),
          ElevatedButton(
              onPressed: () async {
                var value = await QuickCacheFlutter.instance
                    .readCache(key: 'testDuration');
                cachedString.value = value;
              },
              child: const Text('get cache')),
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
