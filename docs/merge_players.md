### Merge Players JSON Example
Request:
```json
{
  "merge_player": {
    "from": "opulent",
    "into": "the_archivist"
  }
}
```

Response:
```json
{
  "merged": true
}
```

### Field Details
`from`: *required*, username of player that will disappear.

`into`: *required*, username of player that will absorb the other.
