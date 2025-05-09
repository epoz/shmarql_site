---
hide:
  - toc
  - navigation
title: "A Tall Tale about lots of data"
---

Here is a simple query

```sparql
SELECT DISTINCT ?uri (COUNT(?x) as ?c) ?label WHERE {
                        ?x a ?uri
                        OPTIONAL{
        {
            ?uri <http://www.w3.org/2000/01/rdf-schema#label> ?label
        }
    }
} GROUP BY ?uri ?label ORDER BY DESC(?c)
# (1)
```

1. What? is this really true? No way!

## Lorem away

Sunt exercitation amet voluptate laborum commodo reprehenderit. Ut eu adipisicing reprehenderit dolore cupidatat veniam aliquip aliquip eu incididunt irure aliqua reprehenderit irure. Cupidatat consectetur labore do irure ut pariatur. Amet ipsum cillum ipsum consectetur minim. Deserunt fugiat in eu reprehenderit reprehenderit voluptate. Nisi reprehenderit est sit ullamco sit ut ad voluptate occaecat sunt enim consequat.

# But wait, automatic queries for The Win

```shmarql
select * where { ?s ?p ?o} limit 30
```

| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| Data 1   | Data 2   | Data 3   |
| Data 4   | Data 5   | Data 6   |
| Data 7   | Data 8   | Data 9   |
