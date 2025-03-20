import 'package:flutter/cupertino.dart';
import 'package:t2305m_app/model/cart_item.dart';

class Bloc extends ChangeNotifier{
  List<CartItem> _cartItems = [];
  String? _jwt;

  List<CartItem> get getCartItems => _cartItems;

  void addToCart(CartItem item){
    _cartItems.add(item);
    notifyListeners();
  }

  void removeCart(int itemId){
    _cartItems.removeWhere((e) => e.id == itemId);
    notifyListeners();
  }

  void loadToken(String token){
    _jwt = token;
    notifyListeners();
  }
}