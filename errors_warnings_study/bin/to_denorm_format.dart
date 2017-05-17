// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This tool takes a time_to_fix file and emits summary information in a format
// that is easier to render

import 'dart:io';
import 'dart:convert';


main(List<String> args) async {
  String inputPath;
  if (args.length != 1) {
    print("usage: to_denorm_format.dart path");
    exit(1);
  }

  inputPath = args[0];

  // E.g. Resolved: {"severity":"ERROR","type":"SYNTACTIC_ERROR","message":"Expected an identifier","code":"missing_identifier","hasFix":false}, 1473891312265, 1473891313360, 1095

  await new File(inputPath).openRead().transform(UTF8.decoder).transform(new LineSplitter()).forEach((ln) {
    if (!ln.startsWith("Resolved:")) return;
    ln = ln.substring("Resolved:".length);

    int endOfJson = ln.lastIndexOf("}") + 1;
    int timeToFix = int.parse(ln.split(",").last);

    Map data = JSON.decode(ln.substring(0, endOfJson));

    print ("${data['code']}, ${data['hasFix']}, $timeToFix");

  });
}
