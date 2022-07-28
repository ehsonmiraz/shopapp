import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../providers/product.dart';
class ProductDetail extends StatelessWidget {
   static final routeName='/product-detail';

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(title: Text("${product.title}",style:Theme.of(context).textTheme.headlineSmall)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(product.imageUrl,fit: BoxFit.cover,),
            ),
            SizedBox(height:10),
            Container(child: FittedBox(child: Text("\$ ${product.price}",style:Theme.of(context).textTheme.headlineSmall)),),
            SizedBox(height:10),
            Container(
              padding: EdgeInsets.all(7),
              child: Text(product.description,style:Theme.of(context).textTheme.displayMedium),
            ),


          ],
        ),
      ) ,
    );
  }
}
