import 'package:flutter/material.dart';
import 'package:gnc/helper/app_theme.dart';

class Loader {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showFileDownloadDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          key: key,
          backgroundColor: Colors.white,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 12.0, top: 12.0),
              child: Row(
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(
                    width: 22,
                  ),
                  Text(
                    "File Downloading...",
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: AppTheme.darkerText,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
