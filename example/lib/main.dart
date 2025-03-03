import 'dart:convert';

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
                    value: json,
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

String json = jsonEncode({
  "company": {
    "name": "Tech Innovations Ltd.",
    "location": "Silicon Valley",
    "established": 2001,
    "departments": [
      {
        "name": "Engineering",
        "employees": [
          {
            "id": 101,
            "name": "Alice Johnson",
            "age": 30,
            "position": "Senior Software Engineer",
            "salary": 120000,
            "skills": ["Dart", "Flutter", "Firebase", "Go"],
            "lastLogin": "2025-02-25T14:30:00Z",
            "projects": [
              {"id": "P1001", "name": "Appflo", "status": "active"},
              {"id": "P1002", "name": "Cloud Sync", "status": "completed"}
            ]
          },
          {
            "id": 102,
            "name": "Bob Smith",
            "age": 28,
            "position": "DevOps Engineer",
            "salary": 110000,
            "skills": ["Docker", "Kubernetes", "AWS", "Terraform"],
            "lastLogin": "2025-02-26T08:45:00Z",
            "projects": [
              {"id": "P1003", "name": "Server Automation", "status": "active"}
            ]
          }
        ]
      },
      {
        "name": "Marketing",
        "employees": [
          {
            "id": 201,
            "name": "Emily Davis",
            "age": 35,
            "position": "Marketing Director",
            "salary": 95000,
            "skills": ["SEO", "Advertising", "Copywriting"],
            "lastLogin": "2025-02-26T10:15:00Z"
          }
        ]
      }
    ],
    "transactions": [
      {
        "transactionId": "TXN-001",
        "amount": 50000,
        "currency": "USD",
        "timestamp": "2025-02-20T12:00:00Z",
        "paymentMethod": "Credit Card"
      },
      {
        "transactionId": "TXN-002",
        "amount": 150000,
        "currency": "USD",
        "timestamp": "2025-02-21T15:45:00Z",
        "paymentMethod": "Bank Transfer"
      }
    ],
    "products": [
      {
        "productId": "PRD-1001",
        "name": "AI Chatbot",
        "category": "Software",
        "price": 49.99,
        "stock": 150,
        "ratings": [5, 4, 4, 5, 3]
      },
      {
        "productId": "PRD-1002",
        "name": "Cloud Storage",
        "category": "Subscription",
        "price": 9.99,
        "stock": "unlimited",
        "ratings": [5, 5, 5, 4, 4]
      }
    ]
  }
});
