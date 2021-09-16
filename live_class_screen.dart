import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gnc/api/ApiConstant.dart';
import 'package:gnc/api/ApiService.dart';
import 'package:gnc/api/AppConstant.dart';
import 'package:gnc/api/model/class_history_added_response.dart';
import 'package:gnc/api/model/online_class_response.dart';
import 'package:gnc/helper/app_theme.dart';
import 'package:gnc/widget/live_class_widget.dart';
import 'package:gnc/widget/loader.dart';
import 'package:gnc/widget/toast_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveClassScreen extends StatefulWidget {
  @override
  _LiveClassScreenState createState() => _LiveClassScreenState();
}

class _LiveClassScreenState extends State<LiveClassScreen> {
  final GlobalKey<State> _joinClassLoader = new GlobalKey<State>();

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
          'Live Class',
          style: TextStyle(
            fontSize: 20,
            color: AppTheme.nearlyWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder(
        future: ApiService.getOnlineClassList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Failed to make a request. Please check your internet connection or try after some time.',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            OnlineClassResponse onlineClassResponse = snapshot.data;
            return (onlineClassResponse.status == 1)
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: onlineClassResponse.data.length,
                    itemBuilder: (context, index) {
                      return LiveClassWidget(
                        classTitle: onlineClassResponse.data[index].title,
                        className:
                            onlineClassResponse.data[index].programModule,
                        classHost: onlineClassResponse.data[index].hostname,
                        status: onlineClassResponse.data[index].status,
                        onTap: () {
                          Loader.showLoadingDialog(context, _joinClassLoader);
                          joinClass(
                              onlineClassResponse.data[index].conferenceId,
                              onlineClassResponse.data[index].url);
                        },
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Online class data not available',
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  joinClass(String confId, String confUrl) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var studentId = sharedPreferences.getString(AppConstant.STUDENT_ID);

    Map<String, String> queryParams = {
      AppConstant.STUDENT_ID: studentId,
      AppConstant.CONFERENCE_ID: confId
    };

    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = ApiConstant.CLASSHISTORY + '?' + queryString;

    final response = await http.get(requestUrl);
    if (response.statusCode == 200) {
      Navigator.of(_joinClassLoader.currentContext, rootNavigator: true).pop();
      var jsonString = response.body;
      Map homeworkJoinGroupResponseMap = jsonDecode(jsonString);
      var homeworkJoinGroupResponse =
          ClassHistoryAddedResponse.fromJson(homeworkJoinGroupResponseMap);
      if (homeworkJoinGroupResponse != null) {
        if (homeworkJoinGroupResponse.status == 1) {
          setState(() {});
          String url = confUrl;
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
          //ToastWidget.showSimpleToast(homeworkJoinGroupResponse.msg);
        } else {
          ToastWidget.showSimpleToast(homeworkJoinGroupResponse.msg);
        }
      }
    } else {
      Navigator.of(_joinClassLoader.currentContext, rootNavigator: true).pop();
      print(response.body);
    }
  }
}
