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
 * Example: `01234567-89ab-cdef-0123-456789abcdef`
 * Type: string
 * Format: uuid
 * ReadOnly: true
* name - unique name of app
 * Example: `example`
 * Type: string
 * Patern: `(?-mix:^[a-z][a-z0-9-]{3,50}$)`
* private - true if this resource is private use
 * Example: `false`
 * Type: boolean

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
  "private": false
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
  "private": false
}
```

```
HTTP/1.1 201
Content-Type: application/json

{
  "id": "01234567-89ab-cdef-0123-456789abcdef",
  "name": "example",
  "private": false
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
  "private": false
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
  "private": false
}
```

```
HTTP/1.1 200
Content-Type: application/json

{
  "id": "01234567-89ab-cdef-0123-456789abcdef",
  "name": "example",
  "private": false
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
  "private": false
}
```

