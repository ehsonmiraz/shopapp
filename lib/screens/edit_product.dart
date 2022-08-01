import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
 class EditProductScreen extends StatefulWidget {
  static const routeName='/edit-product-screen';

  const  EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}


class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode= FocusNode();
  final descriptionFocusNode= FocusNode();
  final urlNode=FocusNode();
  bool _init=false, isEditing=true;
  bool isLoading=false;
  Map <String,dynamic> formValues = {
    "id" : "",
   "title":"",
   "price":0,
   "description":"",
   "imgUrl":""
  };
  var imgUrlController = TextEditingController();
  var _form =GlobalKey<FormState>();

  @override
  void didChangeDependencies(){
   if(!_init) {
    final Product? arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as Product?;
    if (arguments == null)
     isEditing = false;
    else {
     formValues["id"] = arguments.id;
     formValues["title"] = arguments.title;
     formValues["price"] = arguments.price;
     formValues["description"] = arguments.description;
     formValues["imgUrl"] = "";
     imgUrlController.text = arguments.imageUrl;
    }
   }

   _init=true;
   super.didChangeDependencies();
   print("till here");
  }
  @override
  void dispose(){
   priceFocusNode.dispose();
   descriptionFocusNode.dispose();
   urlNode.dispose();
   super.dispose();
  }



  void _submit(){
  if( !_form.currentState!.validate()){
    print("validate nhi hua");
    return ;
  }
    _form.currentState!.save();
    var products =Provider.of<Products>(context,listen: false);
    if(isEditing) {
     Product product = Product(id: formValues['id'],
         title: formValues["title"],
         description: formValues['description'],
         price: formValues['price'],
         imageUrl: formValues['imgUrl'],
         isFavourite :false,
     );
     products.updateProduct(product);
    }
    else{
      setState((){isLoading=true;});
     products.addProduct(
         title: formValues["title"],
         description:formValues['description'],
         price: formValues['price'],
         imgUrl: formValues['imgUrl'],
     ).then((_){
       Navigator.of(context).pop();
     }).catchError((error){
       print("error in alert");
       setState((){isLoading=false;});
       showDialog(context: context, builder: (ctx){
        return AlertDialog(
            title: Text("Something went wrong"),
            content: Text("Unable to add product at the moment"),
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],);
         }).then((value) {Navigator.of(context).pop();});

     });


    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     appBar: AppBar(title: Text("Edit product",style:Theme.of(context).textTheme.headlineSmall),),
     body: isLoading? Center(child: CircularProgressIndicator()):Column(
      children: [
       Container(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
         child: Form(
          key: _form,
             child: Column(
              children: [
               TextFormField(
                decoration: InputDecoration(
                 border: OutlineInputBorder(), //Border.all(),
                 labelText: "Title",
                ),
                initialValue: formValues["title"],
                onSaved: (value){
                 formValues['title']=value;
                },
                validator: (value){
                 if(value==null || value.isEmpty)
                  return "Title cannot be empty";
                 return null;
                },
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
                initialValue: formValues["price"].toString(),
                validator: (value){
                 if(value==null || value.isEmpty)
                  return "Price cannot be empty";
                 if(double.tryParse(value)==null)
                  return "Price should be numberic";

                 return null;
                },
                onSaved: (value){
                 formValues['price']=double.parse(value!);
                },
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
                initialValue: formValues["description"],
                onSaved: (value){
                 formValues['description']=value;
                },
                validator: (value){
                 if(value==null || value.isEmpty)
                  return "Description cannot be empty";
                 return null;
                },
                focusNode: descriptionFocusNode,
                maxLines: 3,
               ),
               SizedBox(height: 15,),
               Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                 Container(
                  height: 100,
                  width:100,
                  decoration: BoxDecoration(
                   border: Border.all(),
                   borderRadius: BorderRadius.circular(3)
                  ),
                  margin: EdgeInsets.only(top: 4,right: 5),
                  child: imgUrlController.text.isEmpty
                      ?Text("Enter URL")
                      : FittedBox(
                   fit: BoxFit.fill,
                      child: Image.network(imgUrlController.text),
                  ),
                 ),
                 Expanded(
                   child: TextFormField(
                    decoration: InputDecoration(
                     border: OutlineInputBorder(),
                     labelText: "Image Url",
                    ),

                    onSaved: (value){
                     formValues['imgUrl']=value;
                    },
                    validator: (value){
                     if(value==null || value.isEmpty)
                      return "Image URL cannot be empty";
                     return null;
                    },
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    focusNode: urlNode,
                    controller: imgUrlController,
                    onEditingComplete: (){setState((){

                    });},
                   ),
                 ),
                ],
               ),
               ElevatedButton(onPressed: _submit,
                child: Container(
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
