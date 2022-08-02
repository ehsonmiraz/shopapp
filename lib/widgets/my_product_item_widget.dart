import 'package:flutter/material.dart';
import 'package:shopapp/screens/edit_product.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class MyProductItemWidget extends StatelessWidget {
  final Product product;
  const MyProductItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold =ScaffoldMessenger.of(context);
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(backgroundImage:NetworkImage(product.imgUrl),),
          title: Text(product.title, style: Theme.of(context).textTheme.displayMedium,),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                      arguments: product,
                  );
                }, icon: Icon(Icons.edit,color:Colors.cyan)),
                SizedBox(width: 8,),
                IconButton(
                    onPressed: ()async{
                        Provider.of<Products>(context,listen: false).deleteProduct(product.id).catchError((error){
                        scaffold.showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 2),));
                    });
                }, icon: Icon(Icons.delete,color:Colors.red,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
