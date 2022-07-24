import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product-item.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {
  bool _showFav;
  ProductGrid(this._showFav) ;

  @override
  Widget build(BuildContext context){
    Products productsData=Provider.of<Products>(context);
    List<Product> loadedProducts=_showFav? productsData.favItems :productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: loadedProducts.length,
        itemBuilder: (context,index){
          return ChangeNotifierProvider.value(
              value: loadedProducts[index],
              child: ProductItem(),
          );
        }

    );
  }
}
