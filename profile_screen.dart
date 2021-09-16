import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gnc/api/ApiConstant.dart';
import 'package:gnc/api/AppConstant.dart';
import 'package:gnc/api/model/profile_response.dart';
import 'package:gnc/helper/app_theme.dart';
import 'package:gnc/screen/drawer_profile_tab_screen/profile_document_screen.dart';
import 'package:gnc/screen/drawer_profile_tab_screen/profile_exam_screen.dart';
import 'package:gnc/screen/drawer_profile_tab_screen/profile_fees_screen.dart';
import 'package:gnc/widget/sub_profile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey expansionTileKey = GlobalKey();

  SharedPreferences sharedPreferences;
  ProfileResponse _profileResponse;
  Map profileMap;

  @override
  void initState() {
    super.initState();
    initView();
  }

  Future initView() async {
    sharedPreferences = await SharedPreferences.getInstance();
    profileMap =
        jsonDecode(sharedPreferences.getString(AppConstant.PROFILE_DATA));
    setState(() {
      _profileResponse = ProfileResponse.fromJson(profileMap);
    });
  }

  Future<ProfileResponse> getProfileData() async {
    profileMap =
        jsonDecode(sharedPreferences.getString(AppConstant.PROFILE_DATA));
    return _profileResponse = await ProfileResponse.fromJson(profileMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        elevation: 0.0,
        /* iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),*/
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            color: AppTheme.nearlyWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: (_profileResponse == null)
          ? Container()
          : DefaultTabController(
              length: 4,
              child: NestedScrollView(
                // allows you to build a list of elements that would be scrolled away till the body reached the top
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        _randomHeightWidgets(context),
                      ),
                    ),
                  ];
                },
                // You tab view goes here
                body: Column(
                  children: <Widget>[
                    Material(
                      color: AppTheme.primary,
                      child: TabBar(
                        isScrollable: true,
                        indicatorColor: AppTheme.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 6,
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              height: 30.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Profile',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              height: 30.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Fees',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              height: 30.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Exam',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              height: 30.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Document',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /*Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              height: 30.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Residence',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: ScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        dragStartBehavior: DragStartBehavior.start,
                        children: [
                          ListView(
                            shrinkWrap: true,
                            primary: false,
                            children: [
                              listItem(
                                index: 1,
                                title: "Personal Info",
                              ),
                              listItem(
                                index: 2,
                                title: "Address",
                              ),
                              listItem(
                                index: 3,
                                title: "Next of Kin Details",
                              ),
                              listItem(
                                index: 4,
                                title: "Miscellaneous Details",
                              ),
                              listItem(
                                index: 5,
                                title: "Residence Details",
                              ),
                            ],
                          ),
                          ProfileFeesScreen(
                            title: "Profile Fees Screen",
                          ),
                          ProfileExamScreen(
                            title: "Profile Exam Screen",
                          ),
                          ProfileDocumentScreen(
                            title: "Profile Document Screen",
                          ),
                          /* ProfileResidenceScreen(
                            title: "Profile Residence Screen",
                          )*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  double get randHeight => Random().nextInt(100).toDouble();
  List<Widget> _randomChildren;

  _randomHeightWidgets(BuildContext context) {
    _randomChildren ??= List.generate(1, (index) {
      final height = randHeight.clamp(
        50.0,
        MediaQuery.of(context)
            .size
            .width, // simply using MediaQuery to demonstrate usage of context
      );
      return Container(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                  ),
                  width: double.infinity,
                  height: 220,
                  child: Image.asset(
                    'assets/images/profilebackground.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                  ),
                  width: double.infinity,
                  height: 220,
                  /*decoration: BoxDecoration(
                    color: AppTheme.assets.withOpacity(0.2),
                  ),*/
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: (getProfileData == null)
                            ? Container()
                            : Container(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/student.png',
                                    image: ApiConstant.STUDENT_IMAGE_BASE_URL +
                                        _profileResponse.data[0].photo,
                                  ),
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: (getProfileData == null)
                            ? Text(" ")
                            : Text(
                                _profileResponse.data[0].firstname +
                                    ' ' +
                                    _profileResponse.data[0].lastname,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.white,
                                  fontSize: 20,
                                  fontFamily: AppTheme.fontName,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: (getProfileData == null)
                            ? Text(" ")
                            : Text(
                                'Student Number : ${_profileResponse.data[0].admissionNo}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontFamily: AppTheme.fontName,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: (getProfileData == null)
                            ? Text(" ")
                            : Text(
                                _profileResponse.data[0].programModule,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontFamily: AppTheme.fontName,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: (getProfileData == null)
                            ? Text(" ")
                            : Text(
                                'Level : ${_profileResponse.data[0].levelname}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontFamily: AppTheme.fontName,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });

    return _randomChildren;
  }

  Widget listItem({int index, String title, IconData icon}) {
    final GlobalKey expansionTileKey = GlobalKey();
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Material(
          color: Colors.black12,
          child: Theme(
            data: ThemeData(accentColor: Colors.black),
            child: ExpansionTile(
              key: expansionTileKey,
              onExpansionChanged: (value) {
                if (value) {
                  _scrollToSelectedContent(expansionTileKey: expansionTileKey);
                }
              },
              title: Text(
                title,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppTheme.primary,
                ),
              ),
              children: <Widget>[cardWidget(index)],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardWidget(int index) {
    return Container(
      color: AppTheme.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: index == 5 && _profileResponse.data[0].resName != null
                ? Text(
                    'Your Residence has been Approved',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  )
                : Container(),
          ),
          setData(index),
        ],
      ),
    );
  }

  void _scrollToSelectedContent({GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: Duration(milliseconds: 200));
      });
    }
  }

  Widget setData(int index) {
    if (index == 1) {
      return Container(
        child: Column(
          children: <Widget>[
            SubProfileWidget(
              title: 'Admission Date',
              value: _profileResponse.data[0].admissionDate,
            ),
            SubProfileWidget(
              title: 'Date Of Birth',
              value: _profileResponse.data[0].dob,
            ),
            SubProfileWidget(
              title: 'Programme Code',
              value: (_profileResponse.data[0].pmcode != null)
                  ? _profileResponse.data[0].pmcode
                  : "",
            ),
            SubProfileWidget(
              title: 'Mobile Number',
              value: _profileResponse.data[0].mobileno,
            ),
            SubProfileWidget(
              title: 'Religion',
              value: _profileResponse.data[0].religion,
            ),
            SubProfileWidget(
              title: 'Race',
              value: _profileResponse.data[0].race,
            ),
            SubProfileWidget(
              title: 'Email',
              value: _profileResponse.data[0].email,
            ),
          ],
        ),
      );
    } else if (index == 2) {
      return Container(
        child: Column(
          children: <Widget>[
            SubProfileWidget(
              title: 'Current Address',
              value: _profileResponse.data[0].presentaddress,
            ),
            SubProfileWidget(
              title: 'Home Address	',
              value: _profileResponse.data[0].permanentaddress,
            ),
          ],
        ),
      );
    } else if (index == 3) {
      return Container(
        child: Column(
          children: <Widget>[
            SubProfileWidget(
              title: 'Relationship',
              value: _profileResponse.data[0].kinrelationship,
            ),
            SubProfileWidget(
              title: 'Name',
              value: _profileResponse.data[0].kinname,
            ),
            SubProfileWidget(
              title: 'Address',
              value: _profileResponse.data[0].kinaddress,
            ),
            SubProfileWidget(
              title: 'Contact',
              value: _profileResponse.data[0].kincontact,
            ),
            SubProfileWidget(
              title: 'Email',
              value: _profileResponse.data[0].kinemail,
            ),
            SubProfileWidget(
              title: 'Fax',
              value: _profileResponse.data[0].kinfax,
            ),
          ],
        ),
      );
    } else if (index == 4) {
      return Container(
        child: Column(
          children: <Widget>[
            SubProfileWidget(
              title: 'Language',
              value: _profileResponse.data[0].language,
            ),
            SubProfileWidget(
              title: 'High School Attended Name',
              value: _profileResponse.data[0].highschoolattended,
            ),
            SubProfileWidget(
              title: 'SANC Number	',
              value: _profileResponse.data[0].sancno,
            ),
          ],
        ),
      );
    } else if (index == 5) {
      return Container(
        child: Column(
          children: <Widget>[
            SubProfileWidget(
              title: 'Residence Name',
              value: (_profileResponse.data[0].resName != null)
                  ? _profileResponse.data[0].resName
                  : "",
            ),
            SubProfileWidget(
              title: 'Residence Room',
              value: (_profileResponse.data[0].roomNo != null)
                  ? _profileResponse.data[0].roomNo
                  : "",
            ),
            SubProfileWidget(
              title: 'Bed',
              value: (_profileResponse.data[0].residencebed != null)
                  ? _profileResponse.data[0].residencebed
                  : "",
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
