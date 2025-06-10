# Datastories

It is possible to create a collection of [Markdown](https://en.wikipedia.org/wiki/Markdown) files that contain integrated SPARQL queries and charts to be served by an instance of SHMARQL. By default, the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme is used, but you can create your own custom themes and styling too.

When you run a SHMARQL instance, there is a set of default files in the /src/docs/ directory that serve as the default user interface. You can override these files and create your own files in a local docs directory. For example, if you had a local directory called docs, you could use it like this:

```shell
docker run -v $(pwd)/docs:/src/docs -v $(pwd)/navigation.yml:/src/docs/.nav.yml -p 8000:8000 --rm -it ghcr.io/epoz/shmarql:latest
```

Or, you could build your own custom image that replaces the docs folder in a build step. See for example how this is done for the [NFDI4Memory consortium](https://github.com/ISE-FIZKarlsruhe/nfdi4memory).

## SPARQL Queries

You can embed any SPARQL query in your datastory by creating block and setting the type to `sparql`, like this: (1)
{ .annotate }

1. Note that in the actual markdown your triple-quotes should be back-tics ` and not single quotes ' for example purposes we are choosing to try and show the blocks visually. Tips on how to do this properly are welcome 😉

```
'''sparql
select \* where {?s ?p ?o} limit 10
'''
```

By setting the type of the block to `shmarql` the source query will not be shown in the page, but executed and the results displayed.

```
'''shmarql
select \* where {?s ?p ?o} limit 10
'''
```

## Charting

It is possible to create charts using the [Plotly](https://plotly.com/graphing-libraries/) library in the Markdown files. This is done by adding some comments to the top of the embedded SPARQL queries, which signal that the output should be a chart and not just a table of results.

For example, you can create a bar chart like this:

```
'''sparql
# shmarql-view: barchart
# shmarql-x: type
# shmarql-y: count
# shmarql-label: Instance Count

PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?type (xsd:integer(COUNT(?subject)) AS ?count)
WHERE {
  ?subject a ?type .
}
GROUP BY ?type
ORDER BY desc(?count)
'''
```
