import 'package:flutter/material.dart';
import 'package:gnc/api/ApiService.dart';
import 'package:gnc/api/model/statement_response.dart';
import 'package:gnc/helper/app_theme.dart';
import 'package:gnc/widget/profile_fee_widget.dart';

class StatementScreen extends StatefulWidget {
  @override
  _StatementScreenState createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
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
          'Statement',
          style: TextStyle(
            fontSize: 20,
            color: AppTheme.nearlyWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder(
        future: ApiService.getStatement(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  snapshot.error.toString(),
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
            StatementResponse statementResponse = snapshot.data;
            return (statementResponse.status == 1)
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 14, right: 14, top: 10),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Student Name',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: AppTheme.nearlyBlack,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      statementResponse
                                              .studentdata[0].firstname +
                                          ' ' +
                                          statementResponse
                                              .studentdata[0].lastname,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppTheme.nearlyBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 14, right: 14, top: 10),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Student No.',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: AppTheme.nearlyBlack,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      statementResponse
                                          .studentdata[0].admissionNo,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppTheme.nearlyBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 14, right: 14, top: 10),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: AppTheme.nearlyBlack,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      statementResponse
                                          .studentdata[0].permanentaddress,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppTheme.nearlyBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Programme Enrolled',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: AppTheme.nearlyBlack,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      statementResponse
                                          .studentdata[0].nursingcategory,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppTheme.nearlyBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: statementResponse.data.length,
                          itemBuilder: (context, index) {
                            return ProfileFeeWidget(
                              feeDate:
                                  statementResponse.data[index].paymentdates,
                              feeAmountToPay:
                                  '${statementResponse.data[index].amountpay}',
                              feeDebit:
                                  '${statementResponse.data[index].adjustamt}',
                              feeCredit:
                                  '${statementResponse.data[index].paidamt}',
                              feeDescription:
                                  statementResponse.data[index].adjustreason,
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 14.0, bottom: 8.0, top: 8.0),
                          child: Text(
                            "Total Balance: ${statementResponse.outstandingamt}",
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppTheme.nearlyBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Statement data not available',
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
}
