// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

class FileData {
  String name;
  var errors = <int, Set<String>>{};

  FileData(this.name);
  FileData.fromJSON(String json) {
    Map map = JSON.decode(json);
    this.name = map["name"];
    Map errorsMap = map["errors"];

    errorsMap.forEach((k, v){
      errors[int.parse(k)] = new Set<String>()..addAll(v);
    });
  }

   Map toJson() { 
    Map map = new Map();
    map["name"] = name;
    var jsonableErrors = <String, List<String>>{};
      errors.forEach((k, v) {
        jsonableErrors["$k"] = v.toList();
      });
    map["errors"] = jsonableErrors;
    return map;
  }
}