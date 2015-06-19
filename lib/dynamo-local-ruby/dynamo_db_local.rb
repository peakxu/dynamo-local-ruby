# encoding: utf-8
# Start dynamo DB local
module DynamoLocalRuby
  # Wrapper around Dynamo DB local process
  class DynamoDBLocal
    PORT = 9389
    ENDPOINT = "http://localhost:#{PORT}"
    LATEST_WEB_TGZ = 'http://dynamodb-local.s3-website-us-west-2.amazonaws.com'\
                     '/dynamodb_local_latest.tar.gz'

    def initialize(pid)
      @pid = pid
    end

    class << self
      def ensure_dynamo_local_exists(local_path)
        jar_path = File.join(local_path, 'DynamoDBLocal.jar')
        return if File.exist?(jar_path)
        `mkdir -p #{local_path}`
        latest = File.join(local_path, 'dynamodb_local_latest.tar.gz')
        `wget #{LATEST_WEB_TGZ} -o #{latest}` unless File.exist?(latest)
        `tar xzf #{latest} -C #{local_path}`
      end

      def up(build_path)
        local_path = File.join(build_path, 'dynamo_db_local')
        ensure_dynamo_local_exists(local_path)
        lib_path = File.join(local_path, 'DynamoDBLocal_lib')
        jar_path = File.join(local_path, 'DynamoDBLocal.jar')
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
