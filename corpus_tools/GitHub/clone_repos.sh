# Clone all of the repos in the supplied file into the current directory
# Usage ./clone_repos.sh PATH
# Where PATH is a file containing one repo per line, e.g. lukechurch/dart-uxr

cwd=$(pwd)

while read line
do
   cd $cwd
   echo $line
   subpath=${line/\//_}
   echo $subpath
   mkdir $subpath
   cd $subpath
   command="git clone https://github.com/$line.git"
   log="git_log.log"
   match="Username"

    $command > "$log" &
    pid=$!

    # Very hacky cloner that lets the process run for 5 seconds
    # if it's still alive after 5 seconds it runs for 3 minutes
    # and then kills it
    echo $pid
    sleep 5

    if kill -0 $pid > /dev/null
    then
        echo 'waiting 60'
        sleep 60
        if kill -0 $pid > /dev/null
        then
            echo 'waiting 120'
            sleep 120

            echo 'killing'            
            kill $pid
        fi
    fi

done < "${1:-/dev/stdin}"




