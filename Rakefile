# encoding: utf-8
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

task :download_dynamodb_local do
  local_path = File.expand_path('../lib/jars/dynamodb_local', __FILE__)
  `mkdir -p #{local_path}`
  return if File.exist?(File.join(local_path, 'DynamoDBLocal.jar'))
  latest = File.join(local_path, 'dynamodb_local_latest.tar.gz')
  LATEST_WEB_TGZ = 'http://dynamodb-local.s3-website-us-west-2.amazonaws.com'\
                   '/dynamodb_local_latest.tar.gz'
  `wget #{LATEST_WEB_TGZ} -O #{latest}` unless File.exist?(latest)
  `tar xzf #{latest} -C #{local_path}`
  `rm #{latest}`
end

task default: :rubocop

task build: :download_dynamodb_local
