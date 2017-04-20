## Demo API
To create a demo, issue a POST https request to `/api/demos`,
with the headers `['API_USERNAME']` and `['API_PASSWORD']` set, along with the
body JSON, as shown below.
The response is JSON: a success will yield `response.save = 'Success'` and
a `response.demo.id` with the created demo's unique identifier.
You will also receive a `response.demo.file_id` with the id of an uploaded file,
for use in demo pack uploads.
Failures will set `response.error` and `response.error_message`.

### Demo JSON Example
```json
{
  "demo": {
    "tas": "0",
    "guys": "1",
    "file": {
      "name": "h1b1-028.zip",
      "data": "UEsDBBQA..."
    }
    "file_id": "1",
    "version": "0",
    "engine": "Heretic v1.3",
    "wad_username": "heretic",
    "time": "0:28",
    "level": "E1M1",
    "levelstat": "0:28",
    "category_name": "SM Speed",
    "video_link": "",
    "recorded_at": "2002-07-15 20:03:22 -0400",
    "players": ["Vincent Catalaa"],
    "tags": [{"text": "Also reality", "style": "1"}]
  }
}
```

### Field Details
`tas`: *required*, specifies the tas level of a demo.
```ruby
0: Not Tas, 1: Segmented, 2: Slowdown, 3: Partial Building, 4: Built
```

`guys`: *required*, specifies the number of players **in the game** (i.e., "doomguys").  Two players could work cooperatively on a tas: then you would have two names in the players field, but only one guy in the game.

`file`: *optional*, specifies the demo file information.  Place the file name under `name`, and a `Base64` encoding under `data`.

`file_id`: *optional*, specifies an existing file id rather than an upload (for demo packs).

`version`: *required*, the version of the wad the demo was recorded on, according to the wad's versioning on DSDA (default to 0).

`engine`: *required*, list of ports / engines used.  Separate entries with `\n`, as this is the raw text rendered on that table.

`wad_username`: *required*, the short name of the wad (e.g., `abyspe10`).

`time`: *required*, the final time, displayed as `[hh:]mm:ss[.tt]`.

`level`: *required*, the level / map / movie.  Use `E1M1`, `Map 03`, `Ep 1`, `All`, `All+` (e.g., doom 2 uv speed with 31-32).

`levelstat`: *required*, list of map times, separated by `\n`.  If not available, use the final time.

`category_name`: *required*, the run category, without dashes (`UV Speed`, `Pacifist`, `NM 100S`).

`video_link`: *optional*, link to the video on youtube, just the unique string (not the full url).

`recorded_at`: *optional*, `datetime` of demo recording (e.g., extracted from .lmp modify time).

`players`: *required*, array of player names.

`tags`: *optional*, list of tags, with the text of the tag and a style flag.
```ruby
0: Hidden, 1: Visible
