import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unigo/users_dashboard/presentation/views/dashboard_screen.dart';
import 'package:unigo/utils/form_validation/form_validation_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../commons/custom_form.dart';
import '../../../../../const/app_colors_const.dart';
import '../../../../../const/app_const.dart';
import '../../../../../const/app_dimension.dart';
import '../../../../../const/app_fonts.dart';
import '../../../../../core/api.dart';
import '../../../../../users_profile/presentation/views/user_profile.dart';
import '../../../../../utils/custom_navigation/app_nav.dart';



class VHome extends ConsumerStatefulWidget {
  const VHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<VHome> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginSignKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> userlist = [];
  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();

    super.dispose();
  }


  @override
  void initState() {
    Api.getInfo1().then((value) {
      if (value != null && value is List<Map<String, dynamic>>) {
        log(value.toString());
        setState(() {
          userlist = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   

    return Form(
      key: loginSignKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: AppDimensions.paddingSMALL),
                Row(
                  children: [
                    const SizedBox(width: AppDimensions.paddingLARGE),
                    Text(
                      AppConst.kphoneNumber,
                      style: TextStyle(
                          fontSize: AppDimensions.body_16,
                          letterSpacing: 0.06.dp,
                          fontFamily: AppFont.kProductsanfont,
                          fontWeight: AppDimensions.fontMedium,
                          color: AppColorConst.kappprimaryColorRed),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingEXTRASMALL),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: CustomAppForm(
                      keyboardType: TextInputType.phone,
                      isSuffixIconrequired: false,
                      readOnly: false,
                      textEditingController: emailController,
                      isPrefixIconrequired: true,
                      prefixIcon: CupertinoIcons.phone,
                      lable: AppConst.kphoneNumber,
                      validator: (input) => input!.isPhoneValidate(input),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.paddingLARGE),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: ContinuousRectangleBorder(
                              side: const BorderSide(
                                width: 0.8,
                                color: AppColorConst.kappprimaryColorRed,
                              ),
                              borderRadius: BorderRadius.circular(22)),
                          backgroundColor: AppColorConst.kappprimaryColorRed,
                          elevation: 0,
                          fixedSize: Size(86.w, 7.h)),
                      onPressed: () async {if (loginSignKey.currentState!.validate()) {

                        if (userlist.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No user found'),
      ),
    );
  } else {
    String enteredEmail = emailController.text;

    // Filter the userlist to find a user with the entered email
    List<Map<String, dynamic>> matchingUsers = userlist
        .where((user) => user['phoneNumber'] == enteredEmail)
        .toList();

    if (matchingUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone Number do not match'),
        ),
      );
    } else {
       SharedPreferences prefs = await SharedPreferences.getInstance();
  // Iterate over matchingUsers and save phone numbers
  for (var user in matchingUsers!) {
    String phoneNumber = user['phoneNumber'];
    await prefs.setString('phoneNumber', phoneNumber);
  }
      // Email found, navigate to UserProfile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfile(

          ),
        ),
      );
    }
  }
}},            
                      
                      child: Text(
                              AppConst.kLogin,
                              style: TextStyle(
                                  letterSpacing: 0.02.dp,
                                  fontFamily: AppFont.lProductsanfont,
                                  fontWeight: AppDimensions.fontMedium,
                                  color: AppColorConst.kappWhiteColor),
                            )),
                ),
            
              ]),
        ),
       
      ),
    );
  }
}
