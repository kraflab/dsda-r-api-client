### Player JSON Example
Request:
```json
{
  "player": {
    "name": "Doug Merrill",
    "username": "opulent"
  }
}
```

Response:
```json
{
  "save": true,
  "player": {
    "id": 13,
    "username": "opulent"
  },
  "error": false,
  "error_message": []
}
```

### Field Details
`name`: *required*, name of player. This can be the full name for players known by it, or can just be a copy of the username.

`username`: *optional*, username of player. This is used for routing in the site, as in `/players/opulent`. If nothing is given, it will be generated from the name automatically: `Doug Merrill` would become `doug_merrill`. Use only letters, numbers, hyphen, underscore.
