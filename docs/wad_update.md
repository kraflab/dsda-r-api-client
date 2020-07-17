### Wad Update JSON Example
Request:
```json
{
  "wad_update": {
    "id": "current_short_name",
    "author": "enkeli33",
    "single_map": false,
    "iwad": "heretic",
    "name": "It's Real And It Kills",
    "short_name": "iraik",
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
`id`: *required*, the short_name of the wad to update.

The other fields will update the existing ones. You can leave out all fields except the one(s) you want to update. Currently the same fields are supported as in wad creation.
