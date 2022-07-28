import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/order_screen.dart';
import 'package:shopapp/widgets/cart_item.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName='/Cart';
  @override
  Widget build(BuildContext context) {
    Cart cart= Provider.of<Cart>(context);

    List<CartItem> cartItems= cart.items.values.toList() ;
    return Scaffold(
       appBar: AppBar(
         title:Text("Your cart",style:Theme.of(context).textTheme.headlineSmall),
       ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children:<Widget>[
                Text("Total : ",style:Theme.of(context).textTheme.headlineSmall),
                SizedBox(width:10),
                Chip(
                  label: Text("${cart.totalAmount}"),
                  backgroundColor: Colors.cyan,
                ),
                Spacer(),
                FlatButton(
                    onPressed: (){
                  if(!cartItems.isEmpty)
                  Provider.of<Order>(context,listen: false).addItem(cart.totalAmount, cart.items.values.toList());
                  cart.clear();
                  }, child: Text("ORDER NOW",style:Theme.of(context).textTheme.headlineMedium)
                ),
                ]
              ),
            )
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx,index){
                 return CartItemWidget(cartItem: cartItems[index], delete:cart.removeItem);
                },
                itemCount: cart.itemCount,
                ),
          )
    
        ],
      ),
    ) ;
  }
}
