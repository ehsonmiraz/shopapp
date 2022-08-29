import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product.dart';
import '../widgets/appdrawer.dart';
import '../widgets/my_product_item_widget.dart';

import '../providers/products.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({Key? key}) : super(key: key);
  static const routeName = "/my-products";

 Future<void> _refreshProducts(BuildContext context) async{
   await Provider.of<Products>(context, listen:false).fetchAndSetProducts(true);
 }
  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title:Text("My Products",style:Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(
              EditProductScreen.routeName,
            );
            }, icon: Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx,snapshot) => snapshot.connectionState==ConnectionState.waiting
            ?Center(child: CircularProgressIndicator(),)
            :RefreshIndicator(
            onRefresh:()=> _refreshProducts(context),
            child: Consumer<Products>(
              builder: (context,productData ,_) {
                final productList =productData.items;
                final itemCount=productData.itemsCount;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (ctx, index) {
                        return MyProductItemWidget(key: ValueKey(
                            productList[index].id),
                          product: productList[index],); //Text("data : ${productList[index].title}");//
                      }
                  ),
                );
              }
            ),
          )
      ),
    );
  }
}
