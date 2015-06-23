# encoding: utf-8
# Start dynamo DB local
module DynamoLocalRuby
  # Wrapper around Dynamo DB local process
  class DynamoDBLocal
    PORT = 9389
    ENDPOINT = "http://localhost:#{PORT}"

    def initialize(pid)
      @pid = pid
    end

    class << self
      def up
        local_path = File.expand_path('../../../lib/jars/dynamodb_local',
                                      __FILE__)
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
