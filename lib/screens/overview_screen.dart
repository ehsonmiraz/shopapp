import 'package:flutter/material.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/appdrawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/product-item.dart';
import '../providers/products.dart';
import '../widgets/product_grid.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatefulWidget {
  static final routeName='/overview-screen';
  OverviewScreen({Key? key}) : super(key: key);
  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}
enum FilterOption {
  Favourites,
  All,
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool _showFav=false;
  bool _isLoading=true;
  @override
  void initState(){
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text("Overview",style:Theme.of(context).textTheme.headlineSmall),
        actions: [
        PopupMenuButton(
          icon: Icon(Icons.opacity_rounded),
          itemBuilder:(_) => [
              PopupMenuItem(child: Text("Show all"),value:FilterOption.All ,),
              PopupMenuItem(child: Text("Favourites"),value: FilterOption.Favourites,),
            ],
          onSelected:(value) {
            if(value==FilterOption.Favourites)
              setState((){
                _showFav=true;
              });
            else
              setState((){
                _showFav=false;
              });
          }
      ),
      Consumer<Cart>(
        builder: (_,cart,ch) => Badge(
            child:ch!, value: cart.itemCount.toString(), color: Colors.pinkAccent
        ),
        child: IconButton(onPressed: (){
          Navigator.of(context).pushNamed(CartScreen.routeName);
        }, icon: Icon(Icons.shopping_bag_outlined)),
      ),
    ],
    ),
    drawer: AppDrawer(),
    body:_isLoading?Center(child: CircularProgressIndicator(),):ProductGrid(_showFav),

    );
  }
}
//<PopupMenuEntry<dynamic>>