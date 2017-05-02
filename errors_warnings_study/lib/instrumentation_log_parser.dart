// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

Map<String, dynamic> parseLogLine(String logLine, [bool verboseDiagnostics = false]) {
  // E.g. ~1473889108576:Noti:{"event"::"analysis.errors","params"::{"file"::"file_name.dart","errors"::[]}}

  if (logLine[0] != "~") {
    if (verboseDiagnostics) {
      print ("Log line didn't start with ~");
    }
    return null;
  }
  try {
    logLine = logLine.substring(1);

    var splits = logLine.split(":");
    int time = int.parse(splits.removeAt(0));
    String messageType = splits.removeAt(0);

    String messageStructure = splits.join(":").replaceAll("::", ":");
    var jsonMap = JSON.decode(messageStructure);

    return {
      "time": time,
      "messageType": messageType,
      "data": jsonMap
    };
  } catch (e,st) {
    if (verboseDiagnostics) {
      print (e);
      print (st);
    }
  }
  return null;
}