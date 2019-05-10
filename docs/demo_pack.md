### Demo Pack JSON Example
This format is specifically for this api client. The demo entries have the same format as in the demo documentation, but do not require file information, since it is supplied in the root of the body.
```json
{
  "demo_pack": {
    "file": {
      "name": "h1b1-028.zip",
      "data": "UEsDBBQA..."
    },
    "demos": [
      {
        "tas": false,
        "guys": "1",
        "version": "0",
        "wad": "heretic",
        "engine": "Heretic v1.3",
        "time": "0:28",
        "level": "E1M1",
        "levelstat": "0:28",
        "category": "SM Speed",
        "recorded_at": "2002-07-15 20:03:22 -0400",
        "players": [
          "Vincent Catalaa"
        ]
      },
      {
        "tas": false,
        "guys": "1",
        "version": "0",
        "wad": "heretic",
        "engine": "Heretic v1.3",
        "time": "0:56",
        "level": "E1M2",
        "levelstat": "0:56",
        "category": "SM Speed",
        "recorded_at": "2002-07-15 21:03:22 -0400",
        "players": [
          "Vincent Catalaa"
        ]
      }
    ]
  }
}
```
