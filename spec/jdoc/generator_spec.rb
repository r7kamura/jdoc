require "spec_helper"
require "active_support/core_ext/string/strip"
require "yaml"

describe Jdoc::Generator do
  describe ".call" do
    subject do
      described_class.call(schema)
    end

    let(:schema) do
      YAML.load_file(schema_path)
    end

    let(:schema_path) do
      File.expand_path("../../fixtures/schema.yml", __FILE__)
    end

    it "returns a String of API documentation in Markdown from given JSON Schema" do
      should == <<-EOS.strip_heredoc
        # Example API
        * App
         * [GET /apps](#get-apps)
         * [POST /apps](#post-apps)
         * [GET /apps/:id](#get-appsid)
         * [PATCH /apps/:id](#patch-appsid)
         * [DELETE /apps/:id](#delete-appsid)

        ## App
        An app is a program to be deployed.

        ### GET /apps
        List existing apps.

        ```
        GET /apps HTTP/1.1
        Content-Type: application/json
        Host: api.example.com
        ```

        ```
        HTTP/1.1 200
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example"
        }
        ```

        ### POST /apps
        Create a new app.

        ```
        POST /apps HTTP/1.1
        Content-Type: application/json
        Host: api.example.com

        {
          "name": "example"
        }
        ```

        ```
        HTTP/1.1 201
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example"
        }
        ```

        ### GET /apps/:id
        Info for existing app.

        ```
        GET /apps/:id HTTP/1.1
        Content-Type: application/json
        Host: api.example.com
        ```

        ```
        HTTP/1.1 200
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example"
        }
        ```

        ### PATCH /apps/:id
        Update an existing app.

        ```
        PATCH /apps/:id HTTP/1.1
        Content-Type: application/json
        Host: api.example.com

        {
          "name": "example"
        }
        ```

        ```
        HTTP/1.1 200
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example"
        }
        ```

        ### DELETE /apps/:id
        Delete an existing app.

        ```
        DELETE /apps/:id HTTP/1.1
        Content-Type: application/json
        Host: api.example.com
        ```

        ```
        HTTP/1.1 200
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example"
        }
        ```

      EOS
    end
  end
end
