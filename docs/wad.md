### Wad JSON Example
Request:
```json
{
  "wad": {
    "author": "enkeli33",
    "single_map": false,
    "iwad": "heretic",
    "name": "It's Real And It Kills",
    "short_name": "iraik",
    "parent": "iraik_new",
    "year": 2018,
    "file": {
      "name": "iraik.zip",
      "data": "UEsDBBQA..."
    }
  }
}

```

Response:
```json
{
  "save": true,
  "wad": {
    "id": 13,
    "file_id": 10
  },
  "error": false,
  "error_message": []
}
```

### Field Details
`author`: *required*, author of wad. Use `Unknown` for unknown, and `Various` if more than two people authored the wad.

`single_map`: *optional*, whether or not the wad is only one map.

`iwad`: *required*, the iwad of the wad.

`name`: *required*, the full name of the wad. E.g., `Back to Saturn X: Episode 1`.

`short_name`: *required*, the short name of the wad, usually the filename. E.g., `btsx_e1`.

`parent`: *optional*, the short name of the latest version of this wad. E.g., `btsx_e1_final`.

`year`: *required*, the year of the wads release (or release of final version).

`file`: *optional*, specifies the wad file information.  Place the file name under `name`, and a `Base64` encoding under `data`. Don't upload the file if it is a commercial product!
