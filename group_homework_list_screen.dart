import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gnc/api/ApiConstant.dart';
import 'package:gnc/api/ApiService.dart';
import 'package:gnc/api/AppConstant.dart';
import 'package:gnc/api/model/homework_group_list_response.dart';
import 'package:gnc/api/model/homework_join_group_response.dart';
import 'package:gnc/helper/app_theme.dart';
import 'package:gnc/widget/homework_by_group_widget.dart';
import 'package:gnc/widget/loader.dart';
import 'package:gnc/widget/toast_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupHomeworkListScreen extends StatefulWidget {
  final String title;

  const GroupHomeworkListScreen({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _GroupHomeworkListScreenState createState() =>
      _GroupHomeworkListScreenState();
}

class _GroupHomeworkListScreenState extends State<GroupHomeworkListScreen> {
  final GlobalKey<State> _joinGroupLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getHomeworkGroupList(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
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
        if (snapshot.connectionState == ConnectionState.done) {
          HomeworkGroupListResponse homeworkGroupListResponse = snapshot.data;
          return (homeworkGroupListResponse.status == 1)
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: homeworkGroupListResponse.data.length,
                        itemBuilder: (context, index) {
                          return HomeworkByGroupdWidget(
                            groupStatus:
                                homeworkGroupListResponse.data[index].status,
                            homeworkProgram: homeworkGroupListResponse
                                .data[index].programModule,
                            homeworkSubject:
                                homeworkGroupListResponse.data[index].levelname,
                            /* noticeColor: Colors.red,*/
                            groupName:
                                homeworkGroupListResponse.data[index].groupname,
                            onTap: () {
                              Loader.showLoadingDialog(
                                  context, _joinGroupLoader);
                              joinGroup(homeworkGroupListResponse
                                  .data[index].groupid);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Homework group data not available',
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
    );
  }

  joinGroup(String groupid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var studentId = sharedPreferences.getString(AppConstant.STUDENT_ID);

    Map<String, String> queryParams = {
      AppConstant.STUDENT_ID: studentId,
      AppConstant.GROUP_ID: groupid
    };

    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = ApiConstant.HOMEWORKJOINGRP + '?' + queryString;

    final response = await http.get(requestUrl);
    if (response.statusCode == 200) {
      Navigator.of(_joinGroupLoader.currentContext, rootNavigator: true).pop();
      var jsonString = response.body;
      Map homeworkJoinGroupResponseMap = jsonDecode(jsonString);
      var homeworkJoinGroupResponse =
          HomeworkJoinGroupResponse.fromJson(homeworkJoinGroupResponseMap);
      if (homeworkJoinGroupResponse != null) {
        if (homeworkJoinGroupResponse.status == 1) {
          setState(() {});
          ToastWidget.showSimpleToast(homeworkJoinGroupResponse.msg);
        } else {
          ToastWidget.showSimpleToast(homeworkJoinGroupResponse.msg);
        }
      }
    } else {
      Navigator.of(_joinGroupLoader.currentContext, rootNavigator: true).pop();
      print(response.body);
    }
  }
}
