import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/bloc/auth_bloc.dart';
import 'package:plantie/bloc/user_profile_bloc.dart';
import 'package:plantie/services/firestore_services.dart';
import 'package:plantie/shared/custome_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProfilePage> {
  String _selectedLanguage = 'English';
  final TextEditingController _nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName!);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var state = BlocProvider.of<UserProfileBloc>(context).state;
    if (state is UserProfileLoaded) {
      if(state.userProfile.language =='en') {
        _selectedLanguage  = "English";
 
      } else{
        _selectedLanguage  =  "Arabic";
     
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection:_selectedLanguage == "English" ?  TextDirection.ltr:TextDirection.rtl,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 176.0,
                    width: 176.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87.withOpacity(0.4),
                          spreadRadius: 0.1,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        FirebaseAuth.instance.currentUser!.photoURL!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 80.0,
              ),
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 16.0),
              ),
              DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  if(newValue == 'English') {
                    BlocProvider.of<UserProfileBloc>(context).add(const UpdateLanguage(langauge: 'en'));
                  } else{
                    BlocProvider.of<UserProfileBloc>(context).add(const UpdateLanguage(langauge: 'ar'));
                  }
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                items: <String>['English', 'Arabic']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 30.0,
              ),
               Text(
                _selectedLanguage == 'English'?   'Name':"الاسم",
                style: TextStyle(fontSize: 16.0),
              ),
              Container(
                height: 35.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
               Text(
                
                _selectedLanguage == "English" ?
                'Email': "البريدالالكتروني",
                textDirection:_selectedLanguage == "English" ?  TextDirection.ltr:TextDirection.rtl ,
                style: TextStyle(fontSize: 16.0),
              ),
              Container(
                height: 35.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    // : FirebaseAuth.instance.currentUser!.email!,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                // width: MediaQuery.of(context).size.width * 0.8,
                child: Button(
                  text:_selectedLanguage=='English'? 'Save':  'حفظ',
                  width: MediaQuery.of(context).size.width * 0.8,
                  onPressed: () {
                    updateUserInfo(
                      FirebaseAuth.instance.currentUser!.email!,
                      _nameController.text,
                    );
                    FirebaseAuth.instance.currentUser!
                        .updateDisplayName(_nameController.text);
                  },
                ),
              ),
              const SizedBox(height: 30.0),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 50),
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(
                        color: Colors.redAccent,
                      )),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                  },
                  child:  Text(_selectedLanguage == "English" ?  'Logout':"تسجيل الخروج"),
                ),
              )
            ],
          ),
        ));
  }
}
