import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem orderItem;

  const OrderItemWidget({Key? key,required this.orderItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(orderItem.id),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete,color: Colors.white,),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_){
        Provider.of<Order>(context,listen: false).removeItem(orderItem.id);

        },
      confirmDismiss: (DismissDirection d){
        return showDialog(context: context, builder: (ctx) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Delete this order"),
            actions: [
              FlatButton(onPressed: ()=> Navigator.of(context).pop(true), child: Text("Yes")),
              FlatButton(onPressed: ()=> Navigator.of(context).pop(false), child: Text("No")),
            ],
          ));
        },

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
                  trailing: IconButton(onPressed:null, icon: Icon(Icons.radio_button_off_rounded)),
                )

            ),
          ],
        ),
      ),
    );
  }
}
