import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/presentation/pages/product_page.dart';
import 'package:product_app/presentation/viewmodel/product_viewmodel.dart';

void main() {
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
      ),
      home: ChangeNotifierProvider(
        create: (context) => ProductViewModel(
          ProductRepositoryImpl(
            ProductRemoteDatasource(Dio()),
            ProductCacheDatasource(),
          ),
        ),
        child: const ProductPage(),
      ),
    );
  }
}
