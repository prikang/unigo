import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unigo/commons/custom_button.dart';

import 'package:unigo/provider/going_provider.dart';
import 'package:unigo/provider/leaving_provider.dart';
import 'package:unigo/users_profile/presentation/views/profile_screen.dart';
import 'package:provider/provider.dart' as pre;

import 'package:unigo/users_tickets/presentation/views/leaving_screen.dart';
import 'package:unigo/utils/custom_navigation/app_nav.dart';
import 'package:unigo/utils/form_validation/form_validation_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../const/app_colors_const.dart';
import '../../../../../const/app_const.dart';
import '../../../../../const/app_dimension.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../const/app_fonts.dart';

import '../../../auth/presentation/login/views/main_login_screen.dart';
import '../../../commons/custom_form.dart';
import '../../../const/app_images_const.dart';
import '../../../provider/location_provider.dart';
import '../../../users_tickets/presentation/views/going_screen.dart';
import 'riderlist.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHelloState();
}

class _MyHelloState extends ConsumerState<Dashboard> {
  TextEditingController emailController = TextEditingController();
TextEditingController paswordController = TextEditingController();
  final GlobalKey<FormState> forgotSignKey = GlobalKey<FormState>();

  LatLng? currentLocation;
  
  String? currentAddress;

  @override
  void dispose() {
    emailController.clear();
    paswordController.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    getCurrentLocation();
  }


  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the case where the user denies location permission
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user permanently denies location permission
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation = LatLng(position.latitude, position.longitude);
      await getCurrentAddress();
    }
  }

  

Future<void> getCurrentAddress() async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    currentLocation!.latitude,
    currentLocation!.longitude,
    localeIdentifier: 'en_US', // Optional: Specify locale for the address format
    // Optional: Specify locale for the name of the place
  );

  if (placemarks.isNotEmpty) {
    Placemark placemark = placemarks[0];

    String name = placemark.name ?? ''; // Name of the place (e.g., Apple Inc.)
    String street = placemark.street ?? ''; // Street name (e.g., Infinite Loop)
    String subLocality = placemark.subLocality ?? ''; // Sub-locality (e.g., Cupertino)
    String locality = placemark.locality ?? ''; // Locality (e.g., Cupertino)
    String subAdministrativeArea = placemark.subAdministrativeArea ?? ''; // Sub-administrative area (e.g., Santa Clara County)
    String administrativeArea = placemark.administrativeArea ?? ''; // Administrative area (e.g., California)
    String postalCode = placemark.postalCode ?? ''; // Postal code (e.g., 95014)
    String country = placemark.country ?? ''; // Country (e.g., United States)
    String isoCountryCode = placemark.isoCountryCode ?? ''; // ISO country code (e.g., US)

    // Construct the address string
    currentAddress = '$name, $subLocality, $subAdministrativeArea, $administrativeArea, $postalCode, $country';
  }
  setState(() {});
}


 

  // Function to calculate distance between two sets of latitude and longitude
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
  double? lats ;
   double? longs ;
     double? lats1 ;
    double? longs1 ;
     double? distance;
     int? price;
      int? price1;
      bool free = false;
  
  @override
  Widget build(BuildContext context) {
    log(currentAddress.toString());
    final loc = pre.Provider.of<Locationprovider>(context,listen: false);
    final lea = pre.Provider.of<LeavingProvider>(context,listen: false);
    final gog = pre.Provider.of<GoingProvider>(context,listen: false);
    final statte = loc.location;
    final statte1 = loc.location1;
    
    emailController = statte == null ? emailController : TextEditingController(text: statte);
    paswordController = statte1 == null ? paswordController : TextEditingController(text: statte1);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            kToolbarHeight + 1), // Set the preferred height of the AppBar
        child: AppBar(
          backgroundColor: AppColorConst.kappWhiteColor,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.location_on_rounded),
                color: CupertinoColors.systemGrey,
                onPressed: () {
                  pushAndRemoveUntil(context, const LoginScreen());
                },
              );
            },
          ),
          title: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    currentAddress ?? "Loading address...",
                    style: TextStyle(
                      fontSize: AppDimensions.body_15,
                      letterSpacing: 0.06.dp,
                      fontFamily: AppFont.jProductsanfont,
                      fontWeight: AppDimensions.fontNormal,
                      color: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_sharp),
              color: CupertinoColors.darkBackgroundGray,
              iconSize: 4.w,
              onPressed: () {
                pushAndRemoveUntil(context, const LoginScreen());
              },
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.person_circle_fill),
              color: CupertinoColors.systemGrey4,
              iconSize: 9.w,
              onPressed: () {
               normalNav(context, Profile4());
              },
            )
          ],
          elevation: 0,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  const SizedBox(width: AppDimensions.paddingLARGE),
                  Text(
                    "From :",
                    style: TextStyle(
                        fontSize: AppDimensions.body_18,
                        letterSpacing: 0.06.dp,
                        fontFamily: AppFont.kProductsanfont,
                        fontWeight: AppDimensions.fontBold,
                        color: AppColorConst.kappprimaryColorRed),
                  ),
                ],
              ),
            SizedBox(height: 0.5.h),
            
               Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomAppForm(
                          isSuffixIconrequired: false,
                          readOnly: true,
                          textEditingController: emailController,
                          isPrefixIconrequired: true,
                          prefixIcon: CupertinoIcons.location,
                          lable: "From",
                          onTap: (){
                            normalNav(context, const LeavingScreen());
                          },
                        ),
                      ),
                    ),
                     SizedBox(height: 0.5.h),
            
                     Row(
                children: [
                  const SizedBox(width: AppDimensions.paddingLARGE),
                  Text(
                    "To :",
                    style: TextStyle(
                        fontSize: AppDimensions.body_18,
                        letterSpacing: 0.06.dp,
                        fontFamily: AppFont.kProductsanfont,
                        fontWeight: AppDimensions.fontBold,
                        color: AppColorConst.kappprimaryColorRed),
                  ),
                ],
              ),
            SizedBox(height: 0.5.h),
            
               Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomAppForm(
                          isSuffixIconrequired: false,
                          readOnly: true,
                          textEditingController: paswordController,
                          isPrefixIconrequired: true,
                          prefixIcon: CupertinoIcons.location,
                          lable: "To",
                          onTap: (){
                            normalNav(context, const GoingScreen());
                          },
                        ),
                      ),
                    ),
           
              SizedBox(height: 3.h),
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
                      onPressed: () {
                        if(emailController.text.isEmpty && paswordController.text.isEmpty){
                           
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please add your respective locations.'),
                            ),
                          );                        
                        }else{
                           lats = lea.latitude;
     longs =lea.longitude;
      lats1 = gog.latitude;
     longs1 =gog.longitude;
    setState(() {
  // Ensure that lats, longs, lats1, and longs1 are not null
  if (lats != null && longs != null && lats1 != null && longs1 != null) {
    // Calculate the distance
    distance = calculateDistance(
      lats!.toDouble(),
      longs!.toDouble(),
      lats1!.toDouble(),
      longs1!.toDouble(),
    );
    
    // Calculate price and price1
    if (distance != null) {
      price = (distance!/25).toInt();
      price1 = (price! * 0.6).toInt(); // Convert the result to int
    }
    free = true;
    // Log the values
    log(price.toString());
    log(price1.toString());
  }
});


                          
                        }   
                      },              
                      child: Text(
                              "Submit",
                              style: TextStyle(
                                  letterSpacing: 0.02.dp,
                                  fontFamily: AppFont.lProductsanfont,
                                  fontWeight: AppDimensions.fontMedium,
                                  color: AppColorConst.kappWhiteColor),
                            )),
                ),
             SizedBox(height: 4.h),
           
          free?  Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                            "Total Price : ",
                            style: TextStyle(
                                fontSize: AppDimensions.body_24,
                                letterSpacing: 0.9,
                                fontFamily: AppFont.kProductsanfont,
                                fontWeight: AppDimensions.fontBold,
                                ),
                          ),
                           Text(
                            "Rs: ${price.toString()}",
                            style: TextStyle(
                                fontSize: AppDimensions.body_24,
                                letterSpacing: 0.9,
                                fontFamily: AppFont.kProductsanfont,
                                fontWeight: AppDimensions.fontBold,
                                color: CupertinoColors.activeGreen),
                          ),
                  ],
                ),
                      SizedBox(height: 2.h),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                            "To Pay : ",
                            style: TextStyle(
                                fontSize: AppDimensions.body_24,
                                letterSpacing: 0.9,
                                fontFamily: AppFont.kProductsanfont,
                                fontWeight: AppDimensions.fontBold,
                                ),
                          ),
                           Text(
                            "Rs: ${price1.toString()}",
                            style: TextStyle(
                                fontSize: AppDimensions.body_24,
                                letterSpacing: 0.9,
                                fontFamily: AppFont.kProductsanfont,
                                fontWeight: AppDimensions.fontBold,
                                color: CupertinoColors.activeGreen),
                          ),
                  ],
                ),
                 SizedBox(height: 4.h),
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
                      onPressed: () {
                       normalNav(context, RidersProfile()) ;
                      },              
                      child:  Text(
                              "Find Riders",
                              style: TextStyle(
                                  letterSpacing: 0.02.dp,
                                  fontFamily: AppFont.lProductsanfont,
                                  fontWeight: AppDimensions.fontMedium,
                                  color: AppColorConst.kappWhiteColor),
                            )),
                ),        
              ],
            ) : Container(),
                  
                     
            ]),
      ),
      
    );
  }
}
