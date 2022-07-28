import 'package:flutter/material.dart';
import 'package:shopapp/screens/order_screen.dart';

import '../screens/overview_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Card(
        child:Column(
          children: [
            ListTile(
              title: Text("Shop"),
              onTap: (){Navigator.pushReplacementNamed(context, OverviewScreen.routeName);},
            ),
            Divider(),
            SizedBox(height: 9,),
            ListTile(
              title: Text("Orders"),
              onTap: (){Navigator.pushReplacementNamed(context, OrderScreen.routeName);},
            )
          ],
        ),
      ),
    );
  }
}
