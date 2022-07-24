import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  //final Product product;
  //const ProductItem(this.product) ;

  @override
  Widget build(BuildContext context) {
    final Product product=Provider.of<Product>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: GridTile(
          child: Image.network(product.imageUrl,fit: BoxFit.cover,),
          footer: GridTileBar(
            backgroundColor:Colors.black54,
            leading:Consumer<Product>(
              builder: (ctx,product, child) => IconButton( onPressed: product.toggleFavourite, icon:product.isFavourite?Icon(Icons.favorite):Icon(Icons.favorite_border),color: Theme.of(context).accentColor,) ,
            ),
            title: Text(product.title),
            trailing:IconButton(onPressed:null, icon:Icon(Icons.add_shopping_cart_outlined),color: Theme.of(context).accentColor,),

          ),

      ),
    );
  }
}
