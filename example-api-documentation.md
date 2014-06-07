# API Documentation
* [GET /apps](#get-apps)
* [POST /apps](#post-apps)
* [GET /apps/:id](#get-appsid)
* [PATCH /apps/:id](#patch-appsid)
* [DELETE /apps/:id](#delete-appsid)
* [GET /recipes](#get-recipes)

## GET /apps
List existing apps.

```
GET /apps HTTP/1.1
Content-Type: application/json
Host: api.example.com
```

## POST /apps
Create a new app.

```
POST /apps HTTP/1.1
Content-Type: application/json
Host: api.example.com

{
  "name": "example"
}
```

## GET /apps/:id
Info for existing app.

```
GET /apps/:id HTTP/1.1
Content-Type: application/json
Host: api.example.com
```

## PATCH /apps/:id
Update an existing app.

```
PATCH /apps/:id HTTP/1.1
Content-Type: application/json
Host: api.example.com

{
  "name": "example"
}
```

## DELETE /apps/:id
Delete an existing app.

```
DELETE /apps/:id HTTP/1.1
Content-Type: application/json
Host: api.example.com
```

## GET /recipes
List recipes.

```
GET /recipes HTTP/1.1
Content-Type: application/json
Host: api.example.com
```

