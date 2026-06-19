import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _thumbnailController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.product?.title ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _categoryController =
        TextEditingController(text: widget.product?.category ?? '');
    _thumbnailController =
        TextEditingController(text: widget.product?.thumbnail ?? '');
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _thumbnailController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<ProductViewModel>();

      final product = Product(
        id: widget.product?.id ?? 0,
        title: _titleController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descriptionController.text,
        category: _categoryController.text,
        thumbnail: _thumbnailController.text,
        stock: int.tryParse(_stockController.text) ?? 0,
        rating: widget.product?.rating ?? 0.0,
      );

      if (widget.product == null) {
        viewModel.addProduct(product).then((_) {
          if (mounted) Navigator.pop(context); // Navigator.pop explícito
        });
      } else {
        viewModel.updateProduct(product).then((_) {
          if (mounted) Navigator.pop(context); // Navigator.pop explícito
        });
      }
    }
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha o campo $label';
              }
              return null;
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Adicionar Produto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigator.pop explícito
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField('Título', _titleController),
              _buildField(
                'Preço',
                _priceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o preço';
                  if (double.tryParse(value) == null) {
                    return 'Número inválido';
                  }
                  return null;
                },
              ),
              _buildField('Descrição', _descriptionController, maxLines: 3),
              _buildField('Categoria', _categoryController),
              _buildField('URL da imagem (thumbnail)', _thumbnailController),
              _buildField(
                'Estoque',
                _stockController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o estoque';
                  }
                  if (int.tryParse(value) == null) return 'Número inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(context), // Navigator.pop explícito
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: Text(isEditing ? 'Atualizar' : 'Criar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
