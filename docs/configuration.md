Here is an overview of the various settings that can be configured at startup.

In keeping with principles of [Twelve-factor apps](https://12factor.net/config)
we configure the system via environment variables.

## DEBUG

Default is 0

When set to 1, more debug info is printed to the logs.

```shell
docker run -e DEBUG=1 --rm ghcr.io/epoz/shmarql:latest
```

## SPARQL_QUERY_UI

Default is 1

When set to 0, does not display a browsable SPARQL UI on the /sparql endpoint.

## ENDPOINT

The address of a SPARQL triplestore to which queries are made. eg.

```shell
docker run -e ENDPOINT=https://query.wikidata.org/sparql -p 8000:8000 --rm ghcr.io/epoz/shmarql:latest
```

## DATA_LOAD_PATHS

A directory or URL from which triples can be loaded. This can either be the path in the filesystem of the running container (which then also needs to be mapped as a volume). For example, if you have a .ttl file on disk somewhere, from that same directory run:

```shell
docker run -e DATA_LOAD_PATHS=/data -v $(pwd):/data -p 8000:8000 --rm ghcr.io/epoz/shmarql:latest
```

This will look for all files named, .nt .ttl .nt.gz or .ttl.gz and load them into a local triplestore.

### Specifying HTTP locations

You can also specify (one or more) HTTP locations to load the data from, for example:

```shell
docker run -e DATA_LOAD_PATHS=https://yogaontology.org/ontology.ttl   -p 8000:8000 --rm ghcr.io/epoz/shmarql:latest
```

## SITE_URI

The external URL from which this instance is reached over the internet. This is useful if you want to use SHMARQL to do the content-negotiation for you to resolve class documentation in an ontology, or to show resolvable URIs from a knowledge graph.

## QUERIES_DB

The full path to a location on a fileystem of a database file used to store cached queries.

## FTS_FILEPATH

The path on a filesystem used to do fulltext queries using [fizzysearch](https://ise-fizkarlsruhe.github.io/fizzysearch/).

## RDF2VEC_FILEPATH

The path on a filesystem used to do RDF2Vec queries using [fizzysearch](https://ise-fizkarlsruhe.github.io/fizzysearch/).

## MOUNT

A prefix mount point that will be added to the start of all web requests served. This is useful if the SHMARQL instance is being proxied as part of a bigger application, and you wish to have all requests be prefixed with a certain path.

It should normally start (and end) with a slash, for example:

```shell
docker run -e MOUNT=/yoga/ -e DATA_LOAD_PATHS=https://yogaontology.org/ontology.ttl -p 8000:8000 --rm ghcr.io/epoz/shmarql:latest
```

And now, you would access this from the browser at http://127.0.0.1:8000/yoga/shmarql

## SITEDOCS_PATH

The default behaviour is to compile all docs found in the ./src/docs/ folder of the container to ./src/site/ with [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) and serve those documents as the content of your site. If you would like to override this, you can specify a different path on the filesystem inside the container to use with this configuration.

## SCHPIEL_PATH

A path to a location from which files will be served over HTTP. These files are "overlayed" into the files served from the docs folder, and have priority over the docs. So you can replace items in the docs folder by files from here. See also the `MOUNT` configuration option.

## WATCH_DOCS

Default is 0

When set to 1, the /src/docs (1) directory are watched for changes, and the site is recompiled when changes are detected. This is useful for development, but should not be used in production.
{ .annotate }

1. The /src/docs/ path is _inside_ the container if running from Docker!

This is useful if you would like to write some datastories in Markdown, and would like to test the queries and documentation interactively in a running SHMARQL instance, before deploying it or commiting to a git repository. Importantly, you also then have to map the docs directory that you are working in and the navigation file into the running container.

For example, you can run an instance like this:

```shell
docker run -e WATCH_DOCS=1 -v $(pwd)/docs:/src/docs -v $(pwd)/navigation.yml:/src/docs/.nav.yml -p 8000:8000 --rm -it ghcr.io/epoz/shmarql:latest
```

See the [NFDI4Culture Datastories](https://gitlab.rlp.net/adwmainz/nfdi4culture/knowledge-graph/shmarql/datastories) to see how this is done in practice.
