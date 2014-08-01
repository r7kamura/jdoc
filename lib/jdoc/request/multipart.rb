module Jdoc
  module Request
    class Multipart
      MULTIPART_BOUNDARY = "---BoundaryX"

      # @return [String] returns boundary parameter for multipart content-type
      def self.boundary
        "boundary=#{MULTIPART_BOUNDARY}"
      end

      # @param params [Hash] request parameters
      def initialize(params)
        @params = params
      end

      # @return [String] request body of multipart/form-data request.
      # @example
      #   -----BoundaryX
      #   Content-Disposition: form-data; name="file"
      #
      #   ... contents of file ...
      #   -----BoundaryX--
      def dump
        contents = Rack::Multipart::Generator.new(@params, false).dump.map do |name, content|
          content_part(content, name)
        end.join
        "#{contents}\r--#{MULTIPART_BOUNDARY}--\r"
      end

      private

      # return [String] content part of multipart/form-data request
      def content_part(content, name)
<<-EOF
--#{MULTIPART_BOUNDARY}\r
Content-Disposition: form-data; name="#{name}"\r
\r
#{content}
EOF
      end
    end
  end
end
