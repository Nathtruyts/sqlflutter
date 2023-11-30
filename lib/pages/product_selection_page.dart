import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String codProduto;
  final String nome;
  final double preco;

  Product(this.codProduto, this.nome, this.preco);
}

class ShoppingCartItem {
  final Product product;
  int quantity;

  ShoppingCartItem(this.product, this.quantity);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compra de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductSelectionPage(),
    );
  }
}

class ProductSelectionPage extends StatefulWidget {
  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  List<Product> products = [
    Product("001", "Produto A", 20.0),
    Product("002", "Produto B", 30.0),
    Product("003", "Produto C", 15.0),
  ];

  List<ShoppingCartItem> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleção de Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${products[index].codProduto} - ${products[index].nome}'),
            subtitle: Text('Preço: ${products[index].preco}'),
            onTap: () => _showQuantityDialog(products[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSummaryScreen(),
        child: Icon(Icons.check),
      ),
    );
  }

  void _showQuantityDialog(Product product) async {
    int? quantity = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Selecione a quantidade'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Text('1'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 5);
              },
              child: Text('5'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 10);
              },
              child: Text('10'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 15);
              },
              child: Text('15'),
            ),
          ],
        );
      },
    );

    if (quantity != null && quantity > 0) {
      setState(() {
        selectedItems.add(ShoppingCartItem(product, quantity));
      });
    }
  }

  void _showSummaryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPage(selectedItems, _clearShoppingCart),
      ),
    );
  }

  void _clearShoppingCart() {
    setState(() {
      selectedItems.clear();
    });
  }
}

class SummaryPage extends StatelessWidget {
  final List<ShoppingCartItem> selectedItems;
  final Function clearShoppingCart;

  SummaryPage(this.selectedItems, this.clearShoppingCart);

  @override
  Widget build(BuildContext context) {
    double total = 0;

    // Somar o valor dos produtos sem desconto
    double totalWithoutDiscount = 0;
    for (var item in selectedItems) {
      totalWithoutDiscount += item.product.preco * item.quantity;
    }

    // Aplicar desconto de 5% se a quantidade for maior que 10
    double discount = selectedItems.length > 10 ? 0.05 : 0.0;
    total = totalWithoutDiscount - (totalWithoutDiscount * discount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo do Pedido'),
      ),
      body: ListView.builder(
        itemCount: selectedItems.length,
        itemBuilder: (context, index) {
          ShoppingCartItem item = selectedItems[index];
          return ListTile(
            title: Text('${item.product.codProduto} - ${item.product.nome}'),
            subtitle: Text('Quantidade: ${item.quantity} - Valor: ${item.product.preco * item.quantity}'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: $total'),
              ElevatedButton(
                onPressed: () {
                  _showOrderConfirmation(context);
                  clearShoppingCart(); // Limpar a lista ao enviar o pedido
                },
                child: Text('Enviar Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pedido Enviado'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
