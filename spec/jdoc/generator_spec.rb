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
         * [POST /apps](#post-apps)
         * [DELETE /apps/:id](#delete-appsid)
         * [GET /apps/:id](#get-appsid)
         * [GET /apps](#get-apps)
         * [PATCH /apps/:id](#patch-appsid)
        * [Recipe](#recipe)
         * [GET /recipes](#get-recipes)
        * [User](#user)

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
        * users - 
         * Type: array

        ### POST /apps
        Create a new app.

        ```
        POST /apps HTTP/1.1
        Content-Type: application/json
        Host: api.example.com

        {
          "name": "example",
          "private": false,
          "deleted_at": null,
          "users": {
            "name": "alice"
          }
        }
        ```

        ```
        HTTP/1.1 201
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example",
          "private": false,
          "deleted_at": null,
          "users": {
            "name": "alice"
          }
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
          "deleted_at": null,
          "users": {
            "name": "alice"
          }
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
          "deleted_at": null,
          "users": {
            "name": "alice"
          }
        }
        ```

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
          "deleted_at": null,
          "users": {
            "name": "alice"
          }
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
          "deleted_at": null,
          "users": {
            "name": "alice"
          }
        }
        ```

        ```
        HTTP/1.1 200
        Content-Type: application/json

        {
          "id": "01234567-89ab-cdef-0123-456789abcdef",
          "name": "example",
          "private": false,
          "deleted_at": null,
          "users": {
            "name": "alice"
          }
        }
        ```

        ## Recipe


        ### Properties
        * name - 
         * Example: `"Sushi"`
         * Type: string
        * user - 
         * Type: object

        ### GET /recipes
        List recipes

        ```
        GET /recipes HTTP/1.1
        Content-Type: application/json
        Host: api.example.com
        ```

        ```
        HTTP/1.1 200
        Content-Type: application/json

        {
          "name": "Sushi",
          "user": {
            "name": "alice"
          }
        }
        ```

        ## User


        ### Properties
        * name - 
         * Example: `"alice"`
         * Type: string

      EOS
    end
  end
end
