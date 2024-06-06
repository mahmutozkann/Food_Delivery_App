import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_done/entities/cart.dart';
import 'package:to_do_done/entities/food.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  final String _title = 'My Cart';
  final String _completeOrderLabel = 'Complete Order';
  final CartRepository _cartRepository = CartRepository();
  final FoodRepository _foodRepository = FoodRepository();
  List<Cart> _cartItems = [];
  List<Food> _foodItems = [];
  int? _userId;
  bool _isLoading = true; // Sayfa yüklendiğinde yükleme durumunu göstermek için

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });
    if (_userId != null) {
      await _fetchCartItems();
    }
    setState(() {
      _isLoading = false; // Yükleme tamamlandığında false olarak güncelle
    });
  }

  Future<void> _fetchCartItems() async {
    try {
      final cartItems = await _cartRepository.getCarts(_userId!);
      List<Food> foodItems = [];
      for (var cartItem in cartItems) {
        var foodItem = await _foodRepository.getFoodById(cartItem.foodId);
        if (foodItem != null) {
          foodItems.add(foodItem);
        }
      }
      setState(() {
        _cartItems = cartItems;
        _foodItems = foodItems;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _completeOrder() async {
    await _cartRepository.clearCart(_userId!);
    setState(() {
      _cartItems = [];
      _foodItems = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Siparişiniz alındı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
        title: Text(_title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _cartItems.isNotEmpty
                        ? CustomListView(cartItems: _cartItems, foodItems: _foodItems)
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: Text('Your cart is empty')),
                          ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CompleteOrderButton(
              label: _completeOrderLabel,
              onPressed: _cartItems.isNotEmpty ? _completeOrder : null, // Sepet boşsa butonu devre dışı bırak
            ),
          )
        ],
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  const CustomListView({super.key, required this.cartItems, required this.foodItems});

  final List<Cart> cartItems;
  final List<Food> foodItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartItems[index];
        final foodItem = foodItems.firstWhere(
          (food) => food.foodId == cartItem.foodId,
          orElse: () => Food(foodId: -1, foodName: 'Unknown', imagePath: '', price: 0),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: CartListTileWidget(
            listileTitle: foodItem.foodName,
            imageUrl: foodItem.imagePath,
            quantity: cartItem.quantity,
          ),
        );
      },
    );
  }
}

class CompleteOrderButton extends StatelessWidget {
  const CompleteOrderButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 360,
        child: ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.purple),
              overlayColor: MaterialStatePropertyAll(Color.fromRGBO(247, 240, 249, 100))),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, color: Color.fromRGBO(247, 240, 249, 100)),
          ),
        ),
      ),
    );
  }
}

class CartListTileWidget extends StatelessWidget {
  const CartListTileWidget({
    super.key,
    required this.listileTitle,
    required this.imageUrl,
    required this.quantity,
  });

  final String listileTitle;
  final String imageUrl;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.grey[500],
        leading: Image.network(imageUrl),
        title: Text(
          listileTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
        subtitle: Text(
          'Piece: $quantity',
          style: TextStyle(color: Colors.amber[300]),
        ),
        contentPadding: const EdgeInsets.all(8),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.remove_circle_outline),
          color: Colors.amber[300],
        ),
      ),
    );
  }
}
