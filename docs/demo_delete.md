### Demo Delete JSON Example
Request:
```json
{
  "demo_delete": {
    "match_details": {
      "wad": "hexen",
      "category": "UV Speed",
      "level": "Map 03",
      "time": "1:13.03",
      "player": "4shockblast",
      "tas": true,
      "solo_net": false,
      "coop": true
    }
  }
}
```

Response:
```json
{
  "success": true
}
```

### Field Details
`match_details`: *required*, details used to find the demo to delete. The _wad_, _category_, and _level_ subfields are required. The others are optional and must be used when needed to narrow down the results. The player subfield just takes one player (pick anyone for a coop run).

This action requires the use of a one time password. Use `--otp 123456` when running the client to include this in the request.
