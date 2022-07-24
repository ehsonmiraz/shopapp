import 'package:flutter/material.dart';
import 'package:shopapp/widgets/product-item.dart';
import 'package:shopapp/widgets/product_grid.dart';
import '../providers/product.dart';

class OverviewScreen extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("Overview"),actions: [
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
      )
    ],),
    body:ProductGrid(_showFav),
    );
  }
}
//<PopupMenuEntry<dynamic>>