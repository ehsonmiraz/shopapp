import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/product_detail.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class ProductItem extends StatelessWidget {
  //final Product product;
  //const ProductItem(this.product) ;

  @override
  Widget build(BuildContext context) {
    final Product product=Provider.of<Product>(context,listen: false);
    final Cart cart=Provider.of<Cart>(context);
    final authData=Provider.of<Auth>(context,listen: false);
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(
            ProductDetail.routeName,
            arguments: product,
        );
        },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: GridTile(
            child: Hero(
              tag:product.id,
              child: FadeInImage(
                  placeholder: AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imgUrl),
                  fit: BoxFit.cover
              ),
            ),
            footer: GridTileBar(
              backgroundColor:Colors.black54,
              leading:Consumer<Product>(
                builder: (ctx,product, child) => IconButton( onPressed: (){product.toggleFavourite(authData.token!,authData.userId!);}, icon:product.isFavourite?Icon(Icons.favorite):Icon(Icons.favorite_border),color: Theme.of(context).accentColor,) ,
              ),
              title: Text(product.title,style:Theme.of(context).textTheme.displaySmall),
              trailing:IconButton(
                splashColor: Color.fromRGBO(200,18, 230, 0.7),
                onPressed:(){
                  cart.addItem(product.id, product.title, product.price);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Item added to cart"),
                        duration: Duration(seconds: 2),
                        action:SnackBarAction(label: "Undo", onPressed: (){ cart.removeItem(product.id); }),

                    )
                  );
                  },
                icon:Icon(Icons.add_shopping_cart_outlined),color: Theme.of(context).accentColor,
              ),

            ),

        ),
      ),
    );
  }
}
