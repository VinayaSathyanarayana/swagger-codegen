module SwaggerClient
  module Swagger
    class Response
      require 'json'
      require 'date'
      require 'tempfile'

      attr_accessor :raw

      def initialize(raw)
        self.raw = raw

        unless raw.success?
          fail ApiError.new(:code => code,
                            :response_headers => headers,
                            :response_body => body),
               raw.status_message
        end
      end

      def code
        raw.code
      end

      def body
        raw.body
      end

      # Deserialize the raw response body to the given return type.
      #
      # @param [String] return_type some examples: "User", "Array[User]", "Hash[String,Integer]"
      def deserialize(return_type)
        return nil if body.blank?

        # handle file downloading - save response body into a tmp file and return the File instance
        return download_file if return_type == 'File'

        # ensuring a default content type
        content_type = raw.headers['Content-Type'] || 'application/json'

        unless content_type.start_with?('application/json')
          fail "Content-Type is not supported: #{content_type}"
        end

        begin
          data = JSON.parse(body, :symbolize_names => true)
        rescue JSON::ParserError => e
          if return_type == 'String'
            return body
          else
            raise e
          end
        end

        build_models data, return_type
      end

      # Walk through the given data and, when necessary, build model(s) from
      # Hash data for array/hash values of the response.
      def build_models(data, return_type)
        case return_type
        when 'String', 'Integer', 'Float', 'BOOLEAN'
          # primitives, return directly
          data
        when 'DateTime'
          # parse date time (expecting ISO 8601 format)
          DateTime.parse data
        when 'Object'
          # generic object, return directly
          data
        when /\AArray<(.+)>\z/
          # e.g. Array<Pet>
          sub_type = $1
          data.map {|item| build_models(item, sub_type) }
        when /\AHash\<String, (.+)\>\z/
          # e.g. Hash<String, Integer>
          sub_type = $1
          {}.tap do |hash|
            data.each {|k, v| hash[k] = build_models(v, sub_type) }
          end
        else
          # models, e.g. Pet
          SwaggerClient.const_get(return_type).new.tap do |model|
            model.build_from_hash data
          end
        end
      end

      # Save response body into a file in (the defined) temporary folder, using the filename
      # from the "Content-Disposition" header if provided, otherwise a random filename.
      #
      # @see Configuration#temp_folder_path
      # @return [File] the file downloaded
      def download_file
        tmp_file = Tempfile.new '', Swagger.configuration.temp_folder_path
        content_disposition = raw.headers['Content-Disposition']
        if content_disposition
          filename = content_disposition[/filename=['"]?([^'"\s]+)['"]?/, 1]
          path = File.join File.dirname(tmp_file), filename
        else
          path = tmp_file.path
        end
        # close and delete temp file
        tmp_file.close!

        File.open(path, 'w') { |file| file.write(raw.body) }
        Swagger.logger.info "File written to #{path}. Please move the file to a proper folder for further processing and delete the temp afterwards"
        return File.new(path)
      end

      # `headers_hash` is a Typhoeus-specific extension of Hash,
      # so simplify it back into a regular old Hash.
      def headers
        h = {}
        raw.headers_hash.each {|k,v| h[k] = v }
        h
      end

      # Extract the response format from the header hash
      # e.g. {'Content-Type' => 'application/json'}
      def format
        headers['Content-Type'].split("/").last.downcase
      end

      def json?
        format == 'json'
      end

      def xml?
        format == 'xml'
      end

      def pretty_body
        return unless body.present?
        case format
        when 'json' then JSON.pretty_generate(JSON.parse(body)).gsub(/\n/, '<br/>')
        end
      end

      def pretty_headers
        JSON.pretty_generate(headers).gsub(/\n/, '<br/>')
      end
    end
  end
end