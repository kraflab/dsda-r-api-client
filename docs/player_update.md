### Player Update JSON Example
Request:
```json
{
  "player_update": {
    "id": "opulent",
    "username": "the_archivist",
    "name": "Doug Merrill",
    "twitch": "abc",
    "youtube": "abc",
    "alias": "doug_merrill"
  }
}
```

Response:
```json
{
  "save": true,
  "player": {
    "id": 13,
    "username": "the_archivist"
  },
  "error": false,
  "error_message": []
}
```

### Field Details
`id`: *required*, current username of player (the name in web address).

You can leave out all fields except the one(s) you want to update.

`name`: *optional*, name of player. This can be the full name for players known by it, or can just be a copy of the username.

`username`: *optional*, username of player. This is used for routing in the site, as in `/players/opulent`. Use only letters, numbers, hyphen, underscore.

`twitch`: *optional*, twitch username of player.

`youtube`: *optional*, youtube username of player.

`alias`: *optional*, adds the given string as an alias for the player.
