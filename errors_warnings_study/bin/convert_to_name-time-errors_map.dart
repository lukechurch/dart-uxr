// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This tool takes in an analysis server instrumentation log and prints to stdOut
// a map of file -> time -> errors

import 'dart:convert';
import 'dart:io';

import 'package:errors_warnings_study/instrumentation_log_parser.dart';
import 'package:errors_warnings_study/errors_file_data.dart';

var results = <String, FileData>{};

main(List<String> args) async {
  String inputPath;
  if (args.length != 1) {
    print("usage: main.dart path");
    exit(1);
  }

  inputPath = args[0];

  int i = 0;
  int errs = 0;

  await new File(inputPath).openRead().transform(UTF8.decoder).transform(new LineSplitter()).forEach((ln) {


    Map<String, dynamic> message = parseLogLine(ln);
    if (message == null) {
      errs++;
      return;
    }
    i++;

    int time = message["time"];
    Map data = message["data"];

    // E.g. ~1473889108576:Noti:{"event"::"analysis.errors","params"::{"file"::"file_name.dart","errors"::[]}}

    if (data["event" != "analysis.errors"]) return;
    String fileName = data["params"]["file"];
    List errors = data["params"]["errors"];

    results.putIfAbsent(fileName, () => new FileData(fileName));
    var fileData = results[fileName];
    fileData.errors.putIfAbsent(time, () => new Set());

    fileData.errors[time].addAll(errors.map((e) => e["message"]));
  }

  );



  results.forEach((k, FileData f) {
    if (!f.errors.values.every((errSet) => errSet.isEmpty)) {
      print(JSON.encode(f));
    }
  });

  stderr.writeln("Done $inputPath: $i Errs $errs");
}
