import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../providers/product.dart';
class ProductDetail extends StatelessWidget {
   static final routeName='/product-detail';

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Image.network(product.imgUrl,fit: BoxFit.cover,),
            ),
            pinned: true,
            floating: false,
            expandedHeight: 300,
          ),
          SliverList(
              delegate: SliverChildListDelegate(
              [
              SizedBox(height:10),
              Container(child: FittedBox(child: Text("\$ ${product.price}",style:Theme.of(context).textTheme.headlineSmall)), height: 30,),
              SizedBox(height:10),
              Container(
                padding: EdgeInsets.all(7),
                child: Text(product.description,style:Theme.of(context).textTheme.displayMedium),
              ),
                SizedBox(height:800)
            ],
          )
          )
        ],
      )

    );
  }
}
