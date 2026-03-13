import 'package:flutter/material.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/pages/product_list_page.dart';
import 'presentation/viewmodels/product_viewmodel.dart';

void main() {
  final repository = ProductRepositoryImpl();
  final viewModel = ProductViewModel(repository);
  runApp(MaterialApp(home: ProductListPage(viewModel: viewModel)));
}