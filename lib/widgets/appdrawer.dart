import 'package:flutter/material.dart';

import '../screens/my_products.dart';
import '../screens/order_screen.dart';
import '../screens/overview_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Card(
        child:Column(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                      Colors.cyan,
                      Color.fromRGBO(10, 120, 240, 0.8),
                    ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                ),
                child: Text("Welcome to my Shop",style: Theme.of(context).textTheme.headlineLarge),

            ),
            ListTile(
              leading: Icon(Icons.cabin),
              title: Text("Shop"),
              onTap: (){Navigator.pushReplacementNamed(context, OverviewScreen.routeName);},
            ),
            Divider(),
            SizedBox(height: 5,),
            ListTile(
              leading: Icon(Icons.badge_outlined),
              title: Text("Orders"),
              onTap: (){Navigator.pushReplacementNamed(context, OrderScreen.routeName);},

            ),
            Divider(),
            SizedBox(height: 5,),
            ListTile(
              leading: Icon(Icons.card_travel_rounded),
              title: Text("My Products"),
              onTap: (){Navigator.pushReplacementNamed(context, MyProducts.routeName);},
            ),
            Divider(),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
