import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/appdrawer.dart';
import '../widgets/cart_item.dart';
import '../widgets/order_item_widget.dart';
import '../providers/cart.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName='/orders';
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;
  Future fetchOrderFuture(){
    return Provider.of<Order>(context,listen: false).fetchAndSetItems();
  }
  void initState(){
    _ordersFuture=fetchOrderFuture();
    super.initState();
  }
  Future<void> openErrorDialog(BuildContext context){
    return showDialog(context: context, builder: (ctx){
      return AlertDialog(
        title: Text("Something went wrong"),
        content: Text("Unable to place order at the moment"),
        actions: [
          FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("OK"))
        ],);
    }).then((value) {Navigator.of(context).pop();});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Orders",style:Theme.of(context).textTheme.headlineSmall),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if(snapshot.hasError) {
            openErrorDialog(context);
            return  Text("No orders yet !",style:Theme.of(context).textTheme.displayMedium);
          }
          else
            return Column(
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

                Consumer<Order>(
                  builder: (ctx, order,_){
                    List <OrderItem> orderItems=order.items.values.toList();
                    return order.itemCount<=0? Text("No orders yet !",style:Theme.of(context).textTheme.displayMedium):Expanded(
                      child: ListView.builder(
                        itemBuilder: (ctx,index){
                          return OrderItemWidget(orderItem:orderItems[index]);
                        },
                        itemCount: order.itemCount,
                      ),
                    );
                  },

                )

              ],
            );
        },
      )
    ) ;
  }
}
