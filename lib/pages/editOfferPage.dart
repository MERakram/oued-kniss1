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

import '../server/api.dart';

class editOfferPage extends StatefulWidget {
  int id;
  editOfferPage(this.id);
  @override
  _editOfferPageState createState() {
    return _editOfferPageState();
  }
}


class _editOfferPageState extends State<editOfferPage> {
  var _offerData;
  String _platformVersion = 'Unknown';
  LocationResult? _pickedLocation;
  LatLng? location;
  double? latitude, longitude;
  String? country, locality, name, street, address;
  late String dropdown1Value ,dropdown2Value,locationtext = "Select Location";
  var user_id = 1,title,rooms,surface,price,description,categories = [],latStr,longStr;
  String category_id = "2";
  List<File> multipleImages = [];
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _loadData();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
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
                child: _offerData==null?Center(child: CircularProgressIndicator(),):Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Edit Offer',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height:height*0.04,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        initialValue:_offerData['title'],
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
                            fillColor: Colors.grey[200],
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
                      child: TextFormField(
                        initialValue: _offerData['price'],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCDB889)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Price',
                            fillColor: Colors.grey[200],
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
                      child: TextFormField(
                        initialValue: _offerData['description'],
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
                            fillColor: Colors.grey[200],
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
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 50,
                          width: width*0.4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: DropdownButton<String>(
                              value: dropdown1Value=='for_sale'?'for sale':'for rent',
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
                            color: Colors.grey[200],
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
                            child: TextFormField(
                              initialValue: _offerData['size'],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xFFCDB889)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Surface              m²',
                                  fillColor: Colors.grey[200],
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
                            child: TextFormField(
                              initialValue: _offerData['rooms'],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
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
                                  fillColor: Colors.grey[200],
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
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Center(
                                child: Text(country.toString() == 'null'
                                    ? _offerData['Location']
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
                            maxWidth: 50, maxHeight: 50);
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
                            color: Colors.grey[200],
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
                              padding: EdgeInsets.symmetric(horizontal: 25),
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
                          onTap: _patchoffer,
                          child: Container(
                            width: width*0.45,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFFCDB889),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Edit',
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
                    GestureDetector(
                      onTap: _DeleteOffer,
                      child: Container(
                        width: width*0.45,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Delete',
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
              ),
            ),
          ),
          backgroundColor: Colors.grey[300],
        ),
      ),
    );
  }

  _loadData() async {
    var response = await Api().getData('/API/offers/${widget.id}/','JWT');
    if (response.statusCode == 200) {
      setState(() {
        _offerData = json.decode(response.body);
        dropdown1Value=_offerData['whatfor'];
        dropdown2Value=_offerData['categories'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error ' + response.statusCode.toString() + ': ' + response.body),
      ));
    }
  }
  _DeleteOffer() async {
    var response = await Api().deleteData('/API/offers/${widget.id}/','JWT');
    if (response.statusCode == 204) {
      Navigator.pop(context);
      print(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error ' + response.statusCode.toString() + ': ' + response.body),
      ));
    }
  }
  void _patchoffer() async {
    // setState(() {
    //   _isLoading = true;
    // });
    var data = new Map<String, String>();
    data['title'] = title==null?_offerData['title']:title;
    data['price'] = price==null?_offerData['price']:price;
    //data['user_id'] = user_id.toString();

    data['description'] = description==null?_offerData['description']:description;
    data['size'] = surface==null?_offerData['size']:surface;
    data['rooms'] = rooms==null?_offerData['rooms']:rooms;
    data['whatfor']=dropdown1Value==null?_offerData['whatfor']:dropdown1Value=='for sale'?'for_sale':'for_rent';
    data['categories']=dropdown2Value==null?_offerData['categories']:dropdown2Value;
    data['Location'] = address==null?_offerData['Location']:address.toString();
    data['Lat'] =latStr==null?_offerData['Lat']:latStr;
    data['Long'] = longStr==null?_offerData['Long']:longStr;
    // data['image'] = _image.path;

    //var response = await Api().postDataWithImage(data, '/offers', _image.path);
    var response = await Api().patchData(data,'/API/offers/${widget.id}/','JWT');
    if (response.statusCode == 200) {
      Navigator.pop(context);
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
