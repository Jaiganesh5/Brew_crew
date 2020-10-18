
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constant.dart';
import 'package:brew_crew/modals/user.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

final _formkey = GlobalKey<FormState>();
final List<String> sugars = ['0','1','2','3','4'];


// form values
String _currentName;
String _currentSugars;
int _currentStrength;

  @override
  Widget build(BuildContext context) {
 final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data ;
           return Form(
          key: _formkey,
            child: Column(
              children: <Widget> [
                Text(
                  'Update  your settings',
                  style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,
                  ),
                  
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    initialValue: userData.name,style: TextStyle(fontWeight: FontWeight.bold),
                    decoration: textInputDecoration.copyWith(hintText: 'Name',hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                    validator: (val)=> val.isEmpty ? 'please enter a name' : null,
                    onChanged: (val)=> setState(()=>  _currentName = val),


                  ),
                  SizedBox(height: 20.0,),
                  //dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData.sugars,
                    hint: new Text('sugars',style: TextStyle(fontWeight:FontWeight.bold),),
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars',style: TextStyle(fontWeight: FontWeight.bold),),
                      );

                    }).toList(),
                     onChanged: (val)=> setState(() =>  _currentSugars = val),
                  
                   
                    ),
                  //slider
                  Slider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    activeColor: Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                     onChanged: (val)=> setState(()=> _currentStrength = val.round()),
                     ),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'update',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      
                    ),
                    onPressed: () async {
                     if(_formkey.currentState.validate()) {
                       await DatabaseService(uid: user.uid).updateUserData(
                         _currentSugars ?? userData.sugars,
                        _currentName ?? userData.name,
                        _currentStrength ??  userData.strength
                        );
                     Navigator.pop(context);
                     }
                       
                    },
                  ),
              ],
            ),
          
          
        );
        }else{
          return Loading();

        }
       
      }
    );
  }
}