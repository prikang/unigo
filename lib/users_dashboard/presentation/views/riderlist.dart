import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unigo/core/api.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../const/app_colors_const.dart';
import '../../../const/app_dimension.dart';
import '../../../const/app_fonts.dart';


class RidersProfile extends ConsumerStatefulWidget {
  const RidersProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHelloState();
}

class _MyHelloState extends ConsumerState<RidersProfile> {
  List<Map<String, dynamic>> userlist = [];

  @override
  void initState() {
    Api.getInfo1().then((value) {
      if (value != null && value is List<Map<String, dynamic>>) {
        setState(() {
          userlist = value;
        });
      }
    });
    super.initState();
  }
void _launchPhoneCall(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        title: Text('Riders List',style: TextStyle(
              fontSize: AppDimensions.body_16,
              letterSpacing: 0.06.dp,
              fontFamily: AppFont.kProductsanfont,
              fontWeight: AppDimensions.fontMedium,
              color: AppColorConst.kappWhiteColor),),
      ),
      body: userlist.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: userlist.length,
              itemBuilder: (context, index) {
                final user = userlist[index];
                return ListTile(
                  title: Text('Username: ${user['fullname']}'),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      Text('Vehicle Number: ${user['vehicleNumber']}'),
                      Text('License Number: ${user['licenseNumber']}'),
                    ],
                  ),
                   trailing: GestureDetector(
    onTap: () {
      _launchPhoneCall(user['phoneNumber']); // Launch phone call
    },
    child: Icon(Icons.phone),
  ),
                );
              },
            ),
    );
  }
}
