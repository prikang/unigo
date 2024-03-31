import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unigo/const/app_colors_const.dart';
import 'package:unigo/const/app_const.dart';
import 'package:unigo/const/app_dimension.dart';
import 'package:unigo/const/app_fonts.dart';
import 'package:unigo/provider/going_provider.dart';
import 'package:unigo/provider/leaving_provider.dart';
import 'package:unigo/users_dashboard/presentation/views/dashboard_screen.dart';
import 'package:unigo/utils/custom_navigation/app_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart' as pre;
import '../../../provider/location_provider.dart';

class GoingScreen extends ConsumerStatefulWidget {
  const GoingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHelloState();
}

class _MyHelloState extends ConsumerState<GoingScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController1 = TextEditingController();
  List<String> _places = [];
Map<String, Map<String, double>> _placeCoordinates = {};

Future<void> searchPlacesInNepal() async {
  final query = _textEditingController.text;
  final url =
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?country=np&access_token=pk.eyJ1IjoiZGdkb24tMTIzIiwiYSI6ImNsbGFlandwcjFxNGMzcm8xbGJjNTY4bmgifQ.dGSMw7Ai7BpXWW4qQRcLgA';

  try {
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    final features = data['features'] as List<dynamic>;
    final places = <String>[];
    final Map<String, Map<String, double>> placeCoordinates = {};

    for (final feature in features) {
      final placeTypes = feature['place_type'] as List<dynamic>;
      if (placeTypes.contains('district') ||
          placeTypes.contains('place') ||
          placeTypes.contains('locality')) {
        final placeName = feature['place_name'] as String;
        final coordinates =
            feature['geometry']['coordinates'] as List<dynamic>;
        final latitude = coordinates[1] as double;
        final longitude = coordinates[0] as double;
        final formattedPlace = '$placeName';
        places.add(formattedPlace);
        placeCoordinates[placeName] = {'latitude': latitude, 'longitude': longitude};
      }
    }

    if (places.isEmpty) {
      places.add('No results found');
    }

    setState(() {
      _places = places;
      _placeCoordinates = placeCoordinates;
      log(_placeCoordinates.toString());
    });
  } catch (e) {
    print('Failed to get search results from Mapbox: $e');
  }
}



  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = pre.Provider.of<Locationprovider>(context,listen: false);
    final gog = pre.Provider.of<GoingProvider>(context,listen: false);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppConst.kGoing,
          style: TextStyle(
              fontSize: AppDimensions.body_16,
              letterSpacing: 0.06.dp,
              fontFamily: AppFont.kProductsanfont,
              fontWeight: AppDimensions.fontMedium,
              color: AppColorConst.kappWhiteColor),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: AppColorConst.kappWhiteColor,
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        backgroundColor: AppColorConst.kappprimaryColorRed,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 12.25.h,
              color: AppColorConst.kappprimaryColorRed,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        width: 92.5.w,
                        child: TextFormField(
                          controller: _textEditingController,
                          maxLines: 1,
                          cursorColor: const Color(0xFF222222),
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) => searchPlacesInNepal(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFFFFFFF),
                            suffixIcon: InkWell(
                              onTap: () {
                                _textEditingController.text = '';
                              },
                              child: const Icon(
                                Icons.close,
                                size: 28,
                                color: Color(0xFF222222),
                              ),
                            ),
                            prefixIcon: const Icon(
                              CupertinoIcons.search,
                              size: 28,
                              color: Color(0xFF222222),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFFFFF),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFFFFF),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                            ),
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                              height: 1,
                              fontFamily: AppFont.kProductsanfont,
                              color: Color(0xFF222222),
                              fontSize: 16,
                            ),
                            suffixIconColor:
                                const Color.fromARGB(255, 255, 0, 0),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: AppFont.kProductsanfont,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Going field cannot be empty';
                            } else if (_places.isEmpty) {
                              return 'No matching places found';
                            }
                            return null;
                          },
                          onEditingComplete: () async {
                            loc.updateLocation1(_textEditingController.text);
                            pushAndRemoveUntil(context, Dashboard());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
           Expanded(
  child: ListView.builder(
    itemCount: _places.length,
    itemBuilder: (BuildContext context, int index) {
      final place = _places[index];
      return ListTile(
        title: place == 'No results found' ? Text(place) : Text(place),
        onTap: () {
          if (place != 'No results found') {
            // Get the coordinates of the selected place
            final coordinates = _placeCoordinates[place];
            if (coordinates != null) {
              final latitude = coordinates['latitude'];
              final longitude = coordinates['longitude'];
              
              // Set the text of the text field to the selected place
              _textEditingController.text = place;
              
              // Clear the list of places
              setState(() => _places.clear());
              gog.setLatitude(latitude!.toDouble());
              gog.setLongitude(longitude!.toDouble());
              // Do something with the coordinates, e.g., store them
              print('Latitude: $latitude, Longitude: $longitude');
            }
          }
        },
      );
    },
  ),
),

          ],
        ),
      ),
    );
  }
}
