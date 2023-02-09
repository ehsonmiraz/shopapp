import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopapp/services/auth.dart';
import 'package:provider/provider.dart';

 enum Authchoice{
   login,
   signup,
 }
class AuthScreen extends StatelessWidget{
  static final routeName ='/auth';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple, Colors.blueAccent, Colors.blue]
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Center(child: Text("Welcome to Munna Shop",style: Theme.of(context).textTheme.headlineLarge,)),
                      ),
                      Flexible(
                        flex:3,
                        child: LayoutBuilder(builder: (BuildContext context,BoxConstraints cons ){
                          return Center(child: AuthCard(dimensions: cons));
                        }),
                      ),
                    ]
                ),
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  final BoxConstraints dimensions;
  const AuthCard({Key? key, required this.dimensions}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
      var _loginForm =GlobalKey<FormState>();
      var _signupForm =GlobalKey<FormState>();
      Map<String,String>  _authData={
        'email':"",
        'password':""
      };
      Authchoice authchoice= Authchoice.login;
      var tabIndex = 0;
      late TabController _tabController;
      var _passcontroller=TextEditingController();
      late AnimationController _animationController;
      late Animation<Size> _heightAnimation;
      bool isLoading=false;

      Future<void> openErrorDialog(BuildContext context,String message){
        return showDialog(context: context, builder: (ctx){
          return AlertDialog(
            title: Text("Error!"),
            content: Text(message),
            actions: [
              OutlinedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],);
        }).then((value) {
            if(authchoice==Authchoice.login){//_loginForm.currentState!.reset();
            }
            else {
              //_signupForm.currentState!.reset();
              //_passcontroller.clear();
            }
        });
      }

      @override
      void initState(){
        

        _tabController=TabController(length: 2, vsync: this);
        super.initState();
        print(" goodfellas ");
      }
      void submit() async{
         setState((){
           isLoading=true;
         });
         try{
         switch(authchoice){
           case Authchoice.login :{
               if (_loginForm.currentState!.validate()) {
                 _loginForm.currentState!.save();
                 await Provider.of<Auth>(context, listen: false).login(
                     _authData['email']!, _authData['password']!);

               }
               break;
             }
           case Authchoice.signup :{
               if (_signupForm.currentState!.validate()) {
                 _signupForm.currentState!.save();
                 await Provider.of<Auth>(context, listen: false).signup(
                     _authData['email']!, _authData['password']!);
               }
               break;
             }
         }
         }
         on HttpException catch(error){
            if(error.message.contains("EMAIL_EXIST")){
              openErrorDialog(context,"Email already registered ");
            }
            else if(error.message.contains("INVALID_EMAIL")){
              openErrorDialog(context,"Invalid email ");
            }
            else if(error.message.contains("WEAK_PASSWORD")){
              openErrorDialog(context,"Please enter a strong password ");
            }
         }
         catch(error){
              print(error.toString());
         }
         setState((){
           isLoading=false;
         });

       }

      @override
      Widget build(BuildContext context) {

        Widget _buildSubmitButton(String title){
          return Container(
            width: widget.dimensions.maxWidth*0.6,
            height: widget.dimensions.maxHeight*0.09,
            //padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.blueAccent, Colors.blue],
                  )
              ),
            child: TextButton(

              //splashColor: Colors.transparent,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              onPressed: submit,
              child: Center(child: Text(title ,style: Theme.of(context).textTheme.headlineLarge,)),
            ),
          ) ;
        }
        Widget _loginWidget= Container(

          width: widget.dimensions.maxWidth*0.9,
          height:widget.dimensions.maxHeight*0.65,
          child : Form(
            key: _loginForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                    SizedBox(height:widget.dimensions.maxHeight*0.09 ,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined,),
                            labelText: "Email",
                            border :OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                      ),
                        validator:(value){
                          if(value==null || !value.contains("@"))
                            return "Invalid Email" ;
                        },
                        onSaved: (value){_authData['email']=value!;},
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height:widget.dimensions.maxHeight*0.05 ,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password_outlined,),
                          labelText: "Password",
                          border :OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        validator:(value){
                          if(value==null )
                            return "Please enter a password";
                          if(value.length<6)
                            return "Password too short";
                        },
                        onSaved: (value){_authData['password']=value!;},
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_){submit();},

                      ),
                    ),
                    SizedBox(height:widget.dimensions.maxHeight*0.05 ,),
                    _buildSubmitButton("Log in"),
                ],
              ),
            ),
          ),
        );
        Widget _signUpWidget= Container(

          width: widget.dimensions.maxWidth*0.9,
          height:widget.dimensions.maxHeight*0.65,
          child : Form(
            key: _signupForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height:widget.dimensions.maxHeight*0.09,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined,),
                        labelText: "Email",
                        border :OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator:(value){
                        if(value==null || !value.contains("@"))
                          return "Invalid Email" ;
                      },
                      onSaved: (value){
                        _authData['email']=value!;
                        },
                    ),
                  ),//email
                  SizedBox(height:widget.dimensions.maxHeight*0.05 ,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(

                        prefixIcon: Icon(Icons.password_outlined,),
                        labelText: "Password",
                        border :OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      controller: _passcontroller,
                      validator:(value){
                        if(value!.length <6 )
                          return "Password too short";
                      },
                      onSaved: (value){
                        _authData['password']=value!;
                        },
                      textInputAction: TextInputAction.next,
                    ),
                  ),//password
                  SizedBox(height:widget.dimensions.maxHeight*0.05 ,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(

                        prefixIcon: Icon(Icons.password_outlined,),
                        labelText: "Confirm Password",
                        border :OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      validator:(value){
                        if(value!=_passcontroller.text )
                          return "Password did not match";
                      },
                      onSaved: (value){_authData['password']=value!;},
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_){submit();},
                    ),
                  ),//Confirm password
                  SizedBox(height:widget.dimensions.maxHeight*0.05 ,),
                  _buildSubmitButton("Sign Up"),
                ],
              ),
            ),
          ),
        );

        _tabController.addListener(() {
          authchoice=_tabController.index==0?Authchoice.login:Authchoice.signup;
          print(authchoice.toString());
        });
        return  Stack(
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: widget.dimensions.maxWidth*0.02),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              elevation: 7,
              child: DefaultTabController(
                  length: 2, // length of tabs
                  initialIndex: 0,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                    Container(
                      child:  TabBar(
                        controller: _tabController,
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(child: Text("Login",style: Theme.of(context).textTheme.headlineMedium,)),
                          Tab(child: Text('Sign Up',style: Theme.of(context).textTheme.headlineMedium,)),
                        ],
                      ),
                    ),
                    Container(
                        height: widget.dimensions.maxHeight*0.8, //height of TabBarView
                        decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                        ),

                        child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                                _loginWidget,
                                _signUpWidget,
                        ])
                    )
                  ])
              ),
            ),
            if(isLoading)Container(
              height: widget.dimensions.maxHeight,
              width: widget.dimensions.maxWidth,
              color: Color.fromRGBO(120, 120, 170, 0.5),
              child: Center(child: CircularProgressIndicator(),),
            )
          ],
        );
    }
}

/*

* child:DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Text("data"),
                AppBar(bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.directions_car)),
                    Tab(icon: Icon(Icons.directions_transit)),
                  ],
                ),
                ),
                TabBarView(
                  children: [
                    Icon(Icons.directions_car),
                    Icon(Icons.directions_transit),
                  ],
                ),
              ],
            ),
          ),*/