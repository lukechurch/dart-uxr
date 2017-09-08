// Extract all the repos containing Dart

import 'dart:io';

main(List<String> args) {
  if (args.length != 1) {
    print ("Usage: dart extract_dart_repos.dart PATH");
    print ("Where PATH is the path to dart_on_github_index.csv");
    exit(1);
  }

  var lines = new File(args[0]).readAsLinesSync();

  // Drop the first line which is a header
  if (lines[0] != "repo_name,path") {
    throw "Unexpected data format in index";
  }
  lines.remove(0);

  Set repos = new Set();

  for (var line in lines) {
    var splits = line.split(",");
    var repo = splits[0];
    var file = splits[1];
    repos.add(repo);
  }

  for (var repo in repos) {
    print (repo);
  }
}