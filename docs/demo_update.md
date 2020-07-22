### Demo Update JSON Example
Request:
```json
{
  "demo_update": {
    "match_details": {
      "wad": "hexen",
      "category": "UV Speed",
      "level": "Map 03",
      "time": "1:13.03",
      "player": "4shockblast",
      "tas": true,
      "solo_net": false,
      "coop": true
    },
    "tas": false,
    "solo_net": false,
    "guys": "1",
    "version": "0",
    "wad": "heretic",
    "kills": "10/21",
    "items": "3/13",
    "secrets": "0/0",
    "engine": "Heretic v1.3",
    "time": "0:28",
    "level": "E1M1",
    "levelstat": "0:28",
    "category": "SM Speed",
    "video_link": "",
    "suspect": false,
    "cheated": false,
    "secret_exit": false,
    "recorded_at": "2002-07-15 20:03:22 -0400",
    "players": [
      "Vincent Catalaa"
    ],
    "tags": [
      {
        "text": "Also reality",
        "show": true
      }
    ]
  }
}
```

Response:
```json
{
  "save": true,
  "demo": {
    "id": 13,
    "file_id": 10
  },
  "error": false,
  "error_message": []
}
```

### Field Details
`match_details`: *required*, details used to find the demo to update. The _wad_, _category_, and _level_ subfields are required. The others are optional and must be used when needed to narrow down the results. The player subfield just takes one player (pick anyone for a coop run).

The other fields will update the existing ones. You can leave out all fields except the one(s) you want to update. Currently the same fields are supported as in demo creation, except for `file`, `file_id`. The data replaces the current value, so if you want to add a player, make sure to include all players in your request.
