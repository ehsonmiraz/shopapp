
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopapp/screens/auth_screen.dart';
import './providers/orders.dart';
import './screens/edit_product.dart';
import './screens/my_products.dart';
import './screens/order_screen.dart';
import './screens/product_detail.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './screens/overview_screen.dart';


import 'providers/cart.dart';
import 'services/auth.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

       ChangeNotifierProvider( create: (ctx) => Cart(),),
       ChangeNotifierProvider(create: (ctx)=> Auth()),
       ChangeNotifierProxyProvider<Auth,Products>(
           create: (ctx)=> Products("",""),
           update: (BuildContext ctx,Auth auth,  Products? products)=> Products(auth.token, auth.userId )
       ),

       ChangeNotifierProxyProvider<Auth,Order>(
            create: (ctx)=> Order("",""),
            update: (BuildContext ctx,Auth auth,  Order? order)=> Order(auth.token,auth.userId)
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx,auth,_){

          return MaterialApp(
            title: 'Shop App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              accentColor: Colors.yellow,
              primarySwatch: Colors.cyan,
              textTheme: ThemeData.light().textTheme.copyWith(
                headlineSmall:GoogleFonts.montserrat(textStyle:TextStyle(fontSize: 17,color: Color.fromRGBO(30, 30, 30, 0.6),fontWeight: FontWeight.w600)),
                headlineMedium:GoogleFonts.montserrat(textStyle:TextStyle(fontSize: 20, color: Colors.cyan)),
                headlineLarge:GoogleFonts.montserrat(textStyle:TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.w400)),
                displaySmall: GoogleFonts.montserrat(textStyle:TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300)),

                displayMedium: GoogleFonts.montserrat(textStyle:TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w400)),
              ),
            ),
            home: auth.isAuthenticated?OverviewScreen():AuthScreen(),
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              OverviewScreen.routeName: (ctx) => OverviewScreen(),
              CartScreen.routeName : (ctx) => CartScreen(),
              ProductDetail.routeName: (ctx) => ProductDetail(),
              OrderScreen.routeName: (ctx) =>  OrderScreen(),
              MyProducts.routeName: (ctx) => MyProducts(),
              EditProductScreen.routeName : (ctx) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}

