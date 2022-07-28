import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';
class OrderItemWidget extends StatelessWidget {
  final OrderItem orderItem;
  final Function delete;
  const OrderItemWidget({Key? key,required this.orderItem,required this.delete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(orderItem.id),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete,color: Colors.white,),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_){delete(orderItem.id);},
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 19),
        elevation: 7,
        child: Column(
          children: [
            Container(
              padding:EdgeInsets.all(5),
              width: double.infinity,
                child: Text("Order Id: #${orderItem.id}",style:Theme.of(context).textTheme.headlineSmall)
            ),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Column(
                    children: orderItem.cartItems.map((ct) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: Row(

                            children: [
                              Container( width:130, child: Text(ct.title,style:Theme.of(context).textTheme.headlineSmall )),
                              SizedBox(width:40),
                              Container(

                              decoration:BoxDecoration(border: Border(),),
                              child: FittedBox(child: Text(" X${ct.quantity} ",style:Theme.of(context).textTheme.headlineSmall ))
                              ),
                              SizedBox(width: 6,),
                              Text("  ${ct.quantity*ct.price}",style:Theme.of(context).textTheme.headlineSmall ),
                            ],
                          ),
                        ) ;
                      }).toList(),

                  ),
                  subtitle: Text("Time: ${DateFormat("dd-MM-yyyy hh:mm").format(orderItem.dateTime)}"),
                  trailing: IconButton(onPressed: (){delete(orderItem.id);}, icon: Icon(Icons.cancel)),
                )

            ),
          ],
        ),
      ),
    );
  }
}
