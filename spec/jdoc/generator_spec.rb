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
        * [App](#app)
         * [GET /apps](#get-apps)
         * [POST /apps](#post-apps)
         * [GET /apps/:id](#get-appsid)
         * [PATCH /apps/:id](#patch-appsid)
         * [DELETE /apps/:id](#delete-appsid)

        ## App
        An app is a program to be deployed.

        ### Properties
        * id - unique identifier of app
         * Example: `"01234567-89ab-cdef-0123-456789abcdef"`
         * Type: string
         * Format: uuid
         * ReadOnly: true
        * name - unique name of app
         * Example: `"example"`
         * Type: string
         * Patern: `(?-mix:^[a-z][a-z0-9-]{3,50}$)`
        * private - true if this resource is private use
         * Example: `false`
         * Type: boolean
        * deleted_at - When this resource was deleted at
         * Example: `nil`
         * Type: null

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
          "name": "example",
          "private": false,
          "deleted_at": null
        }
        ```

        ### POST /apps
        Create a new app.

        ```
        POST /apps HTTP/1.1
        Content-Type: application/json
        Host: api.example.com

        {
          "name": "example",
          "private": false,
          "deleted_at": null
        }
        ```

        ```
        HTTP/1.1 201
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example",
          "private": false,
          "deleted_at": null
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
          "name": "example",
          "private": false,
          "deleted_at": null
        }
        ```

        ### PATCH /apps/:id
        Update an existing app.

        ```
        PATCH /apps/:id HTTP/1.1
        Content-Type: application/json
        Host: api.example.com

        {
          "name": "example",
          "private": false,
          "deleted_at": null
        }
        ```

        ```
        HTTP/1.1 200
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example",
          "private": false,
          "deleted_at": null
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
          "name": "example",
          "private": false,
          "deleted_at": null
        }
        ```

      EOS
    end
  end
end
