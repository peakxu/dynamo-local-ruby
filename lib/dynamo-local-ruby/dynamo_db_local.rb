# encoding: utf-8
# Start dynamo DB local
module DynamoLocalRuby
  # Wrapper around Dynamo DB local process
  class DynamoDBLocal
    PORT = 9389
    ENDPOINT = "http://localhost:#{PORT}"
    DYNAMO_LOCAL_PATH = File.expand_path('../../../build/dynamo_db_local',
                                         __FILE__)
    LATEST_WEB_TGZ = 'http://dynamodb-local.s3-website-us-west-2.amazonaws.com'\
                     '/dynamodb_local_latest.tar.gz'

    def initialize(pid)
      @pid = pid
    end

    class << self
      def ensure_dynamo_local_exists
        jar_path = File.join(DYNAMO_LOCAL_PATH, 'DynamoDBLocal.jar')
        return if File.exist?(jar_path)
        `mkdir -p #{DYNAMO_LOCAL_PATH}`
        latest = File.join(DYNAMO_LOCAL_PATH, 'dynamodb_local_latest.tar.gz')
        `wget #{LATEST_WEB_TGZ} -o #{latest}` unless File.exist?(latest)
        `tar xzf #{latest} -C #{DYNAMO_LOCAL_PATH}`
      end

      def up
        ensure_dynamo_local_exists
        lib_path = File.join(DYNAMO_LOCAL_PATH, 'DynamoDBLocal_lib')
        jar_path = File.join(DYNAMO_LOCAL_PATH, 'DynamoDBLocal.jar')
        pid = spawn("java -Djava.library.path=#{lib_path} -jar #{jar_path} "\
                    "-sharedDb -inMemory -port #{PORT}")
        @instance = DynamoDBLocal.new(pid)

        @instance
      end

      def down
        @instance.down if defined? @instance
      end
    end

    def down
      return unless @pid
      Process.kill('SIGINT', @pid)
      Process.waitpid2(@pid)
      @pid = nil
    end
  end
end
