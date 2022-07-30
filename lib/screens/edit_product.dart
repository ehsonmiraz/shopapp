import 'package:flutter/material.dart';
 class EditProductScreen extends StatelessWidget {
  static const routeName='/edit-product-screen';
  EditProductScreen({Key? key}) : super(key: key);
  final priceFocusNode= FocusNode();
  final descriptionFocusNode= FocusNode();
  @override
  void dispose(){
   priceFocusNode.dispose();
   descriptionFocusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
     appBar: AppBar(title: Text("Edit product",style:Theme.of(context).textTheme.headlineSmall),),
     body: Column(
      children: [
       Container(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
         child: Form(
             child: Column(
              children: [
               TextFormField(
                decoration: InputDecoration(
                 border: OutlineInputBorder(), //Border.all(),
                 labelText: "Title",
                ),
                onFieldSubmitted: (_){
                 FocusScope.of(context).requestFocus(priceFocusNode);
                },
               ),
               SizedBox(height: 15,),
               TextFormField(
                decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 labelText: "Price",
                ),
                onFieldSubmitted: (_){
                 FocusScope.of(context).requestFocus(descriptionFocusNode);
                },
                focusNode: priceFocusNode,
               ),
               SizedBox(height: 15,),
               TextFormField(
                decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 labelText: "Description",
                ),
                focusNode: descriptionFocusNode,
                maxLines: 3,
               ),
               SizedBox(height: 15,),
               ElevatedButton(onPressed: (){}, child: Container(
                   padding: EdgeInsets.symmetric(vertical: 8,horizontal: 29),
                   color: Theme.of(context).primaryColor,
                   child: Text("Submit",style:Theme.of(context).textTheme.headlineSmall)),
               ),
              ],
             )
         ),
       )
      ],
     ),
    );
  }
}
