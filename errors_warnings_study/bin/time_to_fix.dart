// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This tool takes a file -> time -> errors log and reports an estimate time to fix
// each error

import 'dart:io';
import 'dart:convert';

import 'package:errors_warnings_study/errors_file_data.dart';

main(List<String> args) async {
  String inputPath;
  if (args.length != 1) {
    print("usage: main.dart path");
    exit(1);
  }

  inputPath = args[0];

  int resolved = 0;
  int notResolved = 0;
  int i = 0;


  await new File(inputPath).openRead().transform(UTF8.decoder).transform(new LineSplitter()).forEach((ln) {
    var fileData = new FileData.fromJSON(ln);
    List<int> sortedTimings = fileData.errors.keys.toList()..sort();

    for (int i = 0; i < sortedTimings.length; i++) {
      while (fileData.errors[sortedTimings[i]].isNotEmpty) {
        String error = fileData.errors[sortedTimings[i]].first;

        int firstSeenTime = sortedTimings[i];
        int lastSeenTime = -1;
        int firstUnseenTime = -1;

        // Walk forwards until the error is no longer there, removing it as we go
        for (int j = i; j < sortedTimings.length; j++) {
          if (fileData.errors[sortedTimings[j]].contains(error)) {
            lastSeenTime = sortedTimings[j];
            fileData.errors[lastSeenTime].remove(error);
          } else {
            firstUnseenTime = sortedTimings[j];
            break;
          }
        }

        if (firstUnseenTime == -1) {
          notResolved++;
            print ("!Not resolved: $error $firstSeenTime");
        } else {
          resolved++;
            print ("Resolved: $error, $firstSeenTime, $firstUnseenTime, ${firstUnseenTime-firstSeenTime}");
        }
      }
    }
  });

  stderr.writeln("Resolved: $resolved, Not resolved: $notResolved");
}
