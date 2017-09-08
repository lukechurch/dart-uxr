# set -e

TODAY=$(date +"%Y_%m_%d")
bq query --destination_table 'dart_code_completion_usage.export_of_dart_files_Github_'$TODAY "SELECT repo_name, path FROM [bigquery-public-data:github_repos.files] WHERE RIGHT(path, 5) = '.dart'"
bq extract 'dart_code_completion_usage.export_of_dart_files_Github_'$TODAY gs://dart-corpus-github/$TODAY/dart_on_github_index.csv

mkdir -p ~/Analysis/dart-on-github/$TODAY
gsutil cp gs://dart-corpus-github/$TODAY/dart_on_github_index.csv ~/Analysis/dart-on-github/$TODAY/dart_on_github_index.csv

dart bin/extract_dart_repos.dart ~/Analysis/dart-on-github/$TODAY/dart_on_github_index.csv > ~/Analysis/dart-on-github/$TODAY/dart_on_github_repos.csv
