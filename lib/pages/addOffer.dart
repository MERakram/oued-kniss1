import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/generated/l10n.dart' as location_picker;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/google_map_location_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:oued_kniss1/pages/myOffersPage.dart';

import '../server/api.dart';

class addOfferPage extends StatefulWidget {
  int id;
  addOfferPage(this.id);
  @override
  _addOfferPageState createState() {
    return _addOfferPageState();
  }
}

class _addOfferPageState extends State<addOfferPage> {
  String _platformVersion = 'Unknown';
  LocationResult? _pickedLocation;
  LatLng? location;
  double? latitude, longitude;
  String? country, locality, name, street, address;
  String dropdown1Value = 'for sale',dropdown2Value = 'Appartement',locationtext = "Select Location";
  var user_id = 1,title,price,description,categories = [],rooms,surface,latStr,longStr;
  late String category_id = "2";
  File? image;var filePath;
  List<File> multipleImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    //_loadCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('failed $e');
    }
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await MapLocationPicker.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    void determinePosition() async {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude!, longitude!);
        setState(() {
          country = placemarks[0].country;
          locality = placemarks[0].locality;
          street = placemarks[0].street;
          name = placemarks[0].name;
          address = "${country} , ${locality} , ${street}";
        });
        print(country);
        print(locality);
        print(name);
      } catch (e) {
        throw e;
      }
    }

    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        location_picker.S.delegate,
      ],
      home: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Add Offer',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height:height*0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        maxLength: 35,
                        decoration: InputDecoration(
                            counterText:'',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCDB889)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Title',
                            fillColor: Colors.grey[100],
                            filled: true),
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            counterText:'',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCDB889)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Price',
                            fillColor: Colors.grey[100],
                            filled: true),
                        onChanged: (value) {
                          price = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        maxLength: 170,
                        maxLines: 3,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(15, 20, 0, 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCDB889)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Description',
                            fillColor: Colors.grey[100],
                            filled: true),
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: width*0.01,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 50,
                          width: width*0.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: DropdownButton<String>(
                              value: dropdown1Value,
                              underline: SizedBox(),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              elevation: 16,
                              style: const TextStyle(
                                color: Color(0xFF5F5F5F),
                              ),
                              iconSize: 30,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdown1Value = newValue!;
                                });
                              },
                              items: <String>['for sale', 'for rent']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(value),
                                    ));
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 50,
                          width: width*0.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: DropdownButton<String>(
                              value: dropdown2Value,
                              underline: SizedBox(),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              elevation: 16,
                              style: const TextStyle(
                                color: Color(0xFF5F5F5F),
                              ),
                              iconSize: 30,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdown2Value = newValue!;
                                });
                              },
                              items: <String>[
                                'Appartement',
                                'House',
                                'Industrial',
                                'Commercial',
                                'Land'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(value),
                                    ));
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: width*0.01,),
                        Container(
                          height: 50,
                          width: width*0.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: TextField(
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  counterText:'',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFCDB889)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Surface          m²',
                                  fillColor: Colors.grey[100],
                                  filled: true),
                              onChanged: (value) {
                                surface = value;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 50,
                          width: width*0.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: TextField(
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  counterText:'',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFCDB889)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Rooms',
                                  fillColor: Colors.grey[100],
                                  filled: true),
                              onChanged: (value) {
                                rooms = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        LocationResult? result = await showLocationPicker(
                          context,
                          'AIzaSyBQByMa90Ng0VQw-4WsVazBWK7831DsIyI',
                          initialCenter: const LatLng(31.1975844, 29.9598339),
                          myLocationButtonEnabled: true,
                          // layersButtonEnabled: true,
                          resultCardConfirmIcon:
                              Icon(Icons.keyboard_arrow_up_rounded),
                          resultCardPadding: EdgeInsets.all(0),
                          desiredAccuracy: LocationAccuracy.bestForNavigation,
                          countries: ['IN'],
                          language: 'en',
                          // requiredGPS: true,
                        );
                        // debugPrint("result = $result");
                        setState(() {
                          _pickedLocation = result;
                          location = result?.latLng;
                          latitude = location?.latitude;
                          latStr=latitude.toString();
                          longitude = location?.longitude;
                          longStr=longitude.toString();
                          determinePosition();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: Container(
                          height: 60,
                          width: 360,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Center(
                                child: Text(country.toString() == 'null'
                                    ? locationtext
                                    : address.toString())),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        List<XFile>? picked = await _picker.pickMultiImage(
                          );
                        setState(() {
                          multipleImages =
                              picked!.map((e) => File(e.path)).toList();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: Container(
                          height: 60,
                          width: 360,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Center(
                                child:multipleImages.length != 0? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: multipleImages.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Image.file(multipleImages[index]);
                                    },):Text('pick images')),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: width*0.45,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: width*0.04),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: _submit,
                          child: Container(
                            width: width*0.45,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: width*0.04),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCDB889),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }

  _loadCategories() async {
    var response = await Api().getData('/category','JWT');
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error ' + response.statusCode.toString() + ': ' + response.body),
      ));
    }
  }

  void _submit() async {
    // setState(() {
    //   _isLoading = true;
    // });
    var data = new Map<String, String>();
    data['title'] = title;
    data['price'] = price;
    //data['user_id'] = user_id.toString();
    data['description'] = description;
    data['whatfor'] = dropdown1Value=='for sale'?'for_sale':'for_rent';
    data['categories'] = dropdown2Value;
    data['size'] = surface;
    data['rooms'] = rooms;
    data['Location'] = address.toString();
    data['Lat'] =latStr;
    data['Long'] = longStr;
    // data['image'] = _image.path;
    var response = await Api().postDataWithImages(data, '/API/offers/', multipleImages,'JWT','uploaded_images');

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => myOffersPage(widget.id)),

      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Great!",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    } else {
      _showMsg('Error ${response.statusCode}');
    }
  }

  _showMsg(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    ));
  }
}
