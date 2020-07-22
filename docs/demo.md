### Demo JSON Example
Request:
```json
{
  "demo": {
    "tas": false,
    "solo_net": false,
    "guys": "1",
    "version": "0",
    "wad": "heretic",
    "file": {
      "name": "h1b1-028.zip",
      "data": "UEsDBBQA..."
    },
    "kills": "10/21",
    "items": "3/13",
    "secrets": "0/0",
    "file_id": "1",
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
`tas`: *required*, specifies whether or not the demo is a tas.

`solo_net`: *required*, specifies whether or not the demo uses solo-net.

`guys`: *required*, specifies the number of players **in the game** (i.e., "doomguys").  Two players could work cooperatively on a tas: then you would have two names in the players field, but only one guy in the game.

`kills`: *optional*, kills as a fraction.

`items`: *optional*, items as a fraction.

`secrets`: *optional*, secrets as a fraction.

`file`: *optional*, specifies the demo file information.  Place the file name under `name`, and a `Base64` encoding under `data`.

`file_id`: *optional*, specifies an existing file id rather than an upload (for demo packs).

`version`: *required*, the version of the wad the demo was recorded on, according to the wad's versioning on DSDA (default to 0).

`engine`: *required*, list of ports / engines used.  Separate entries with `\n`, as this is the raw text rendered on that table.

`wad`: *required*, the short name of the wad (e.g., `abyspe10`).

`time`: *required*, the final time, displayed as `[hh:]mm:ss[.tt]`.

`level`: *required*, the level / map / movie.  Use `E1M1`, `Map 03`, `Ep 1`, `D2All`, etc.

`levelstat`: *required*, list of map times, separated by `,`.

`category`: *required*, the run category, without dashes (`UV Speed`, `Pacifist`, `NM 100S`).

`video_link`: *optional*, link to the video on youtube, just the unique string (not the full url).

`suspect`: *optional*, indicates a dubious demo (player history of cheating). Should only be used in serious cases (discuss with the team).

`cheated`: *optional*, indicates a CONFIRMED cheated demo. The player must have admitted to cheating the specific demo or there must be undeniable evidence.

`secret_exit`: *optional*, indicates whether or not the demo uses a secret exit.

`recorded_at`: *optional*, `datetime` of demo recording (e.g., extracted from .lmp modify time).

`players`: *required*, array of player names.

`tags`: *optional*, list of tags, with the text of the tag and whether to show it by default.
