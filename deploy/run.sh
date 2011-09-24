cd ../../ 
ROOT_DIR=`pwd`
RUBY=/home/monintor/ruby1.8/bin/ruby

mkdir -p $ROOT_DIR/log/sit-uat
mkdir -p $ROOT_DIR/log/prod

nohup $RUBY $ROOT_DIR/main.rb $ROOT_DIR/config/qa/coredump.yml $ROOT_DIR/deploy/env.yml 2>&1>$ROOT_DIR/log/qa/coredump.log &

nohup $RUBY $ROOT_DIR/main.rb $ROOT_DIR/config/qa/systemout.yml $ROOT_DIR/deploy/env.yml 2>&1>$ROOT_DIR/log/qa/systemout.log &

nohup $RUBY $ROOT_DIR/main.rb $ROOT_DIR/config/prod/coredump.yml $ROOT_DIR/deploy/env.yml 2>&1>$ROOT_DIR/log/prod/coredump.log &

nohup $RUBY $ROOT_DIR/main.rb $ROOT_DIR/config/prod/systemout.yml $ROOT_DIR/deploy/env.yml 2>&1>$ROOT_DIR/log/prod/systemout.log &
