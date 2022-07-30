import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/my_product_item_widget.dart';

import '../providers/products.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({Key? key}) : super(key: key);
  static const routeName = "/my-products";
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final productList =productData.items;
    final itemCount=productData.itemsCount;
    return Scaffold(
      appBar: AppBar(
        title:Text("My Products",style:Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(onPressed: (){print("object");}, icon: Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (ctx, index){
            return MyProductItemWidget( key:ValueKey(productList[index].id), product: productList[index],);//Text("data : ${productList[index].title}");//
          }
      ),
    );
  }
}
