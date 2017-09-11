# Clone all of the repos in the supplied file into the current directory
# Usage ./clone_repos.sh PATH
# Where PATH is a file containing one repo per line, e.g. lukechurch/dart-uxr

while read line
do
   git clone https://github.com/$line
done < "${1:-/dev/stdin}"