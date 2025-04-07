# ROR Docker
Custom self contained docker image for [ROR
API](https://github.com/ror-community/ror-api). This is a custom build
of the API designed to be easily ran by anyone without having to clone
the ROR repository.

## Getting started

The easiest way to get started is to run the API using the compose file.

```
docker compose up
```

You will need to index the current ROR data using the command.

```
docker-compose exec ror python manage.py setup v1.0-2022-03-17-ror-data -s 1
```

The latest ROR dataset can be found at Index the latest ROR dataset from
https://github.com/ror-community/ror-data. The `-s` parameter indicates
the schema version to use.

For more information about the ROR API, visit their [repository](https://github.com/ror-community/ror-api) and send
them some love :heart:

## Disclaimer

This project is in no way affiliated with ROR. If you have issues
running the API using this docker image, please raise an issue here not
in there repository as a first point of call.
