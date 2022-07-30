import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/appdrawer.dart';
import '../widgets/cart_item.dart';
import '../widgets/order_item_widget.dart';
import '../providers/cart.dart';
class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName='/orders';
  @override
  Widget build(BuildContext context) {
    //Cart cart= Provider.of<Cart>(context);
    Order order=Provider.of<Order>(context);
    List <OrderItem> orderItems=order.items.values.toList();
    //List<CartItem> cartItems= cart.items.values.toList() ;
    return Scaffold(
      appBar: AppBar(
        title:Text("Orders",style:Theme.of(context).textTheme.headlineSmall),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
              margin: EdgeInsets.all(10),
              color: Theme.of(context).primaryColorLight,
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    children:<Widget>[
                      Text("Orders Placed : ",style:Theme.of(context).textTheme.headlineSmall),
                      SizedBox(width:10),
                ]
              ),
              )
          ),

          order.itemCount<=0? Text("No orders yet !",style:Theme.of(context).textTheme.displayMedium):Expanded(
            child: ListView.builder(
              itemBuilder: (ctx,index){
                return OrderItemWidget(orderItem:orderItems[index]);
              },
              itemCount: order.itemCount,
            ),
          )

        ],
      ),
    ) ;
  }
}