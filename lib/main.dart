import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/product_cache_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'pages/login_page.dart';
import 'presentation/viewmodel/product_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final remote = ProductRemoteDatasource(dio);
    final cache = ProductCacheDatasource();
    final repository = ProductRepositoryImpl(remote, cache);

    return ChangeNotifierProvider(
      create: (_) => ProductViewModel(repository),
      child: MaterialApp(
        title: 'Projeto Produtos com Autenticação',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
