import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function delete;
  const CartItemWidget({Key? key,required this.cartItem,required this.delete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete,color: Colors.white,),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_){delete(cartItem.id);},
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 9),
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(

            leading: CircleAvatar(child: FittedBox(child: Text("\$ ${cartItem.price}",style:Theme.of(context).textTheme.headlineSmall )),),
            title: Text(cartItem.title,style:Theme.of(context).textTheme.headlineSmall ),
            subtitle: Text("X${cartItem.quantity}"),
            trailing: IconButton(onPressed: (){delete(cartItem.id);}, icon: Icon(Icons.delete)),
          )

        ),
      ),
    );
  }
}
