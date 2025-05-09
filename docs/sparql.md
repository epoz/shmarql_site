---
hide:
  - toc
  - navigation
title: "SPARQL Query Window"
---

<button id="execute_sparql" title="Execute this query, (also use Ctrl+Enter)" hx_post="/shmarql/fragments/sparql" hx_target="#results" hx_swap="innerHTML">
    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-play-btn" viewBox="0 0 16 16">
                <path d="M6.79 5.093A.5.5 0 0 0 6 5.5v5a.5.5 0 0 0 .79.407l3.5-2.5a.5.5 0 0 0 0-.814l-3.5-2.5z"/>
                <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4zm15 0a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z"/>
    </svg>
</button>
<button id="prefixes" class="bg-slate-300 hover:bg-slate-400 text-black px-2 rounded-lg shadow-xl transition duration-300 font-bold" name="prefixes">
Prefixes
      <script>
me().on("click", async ev => {

    let editorContent = sparqleditor.doc.getValue();
    let prefixContent = `PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX schema: <http://schema.org/>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wds: <http://www.wikidata.org/entity/statement/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX dbr: <http://dbpedia.org/resource/>
PREFIX rico: <https://www.ica.org/standards/RiC/ontology#>
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX virtrdfdata: <http://www.openlinksw.com/virtrdf-data-formats#>
PREFIX virtrdf: <http://www.openlinksw.com/schemas/virtrdf#>
PREFIX shmarql: <https://shmarql.com/>
PREFIX cto: <https://nfdi4culture.de/ontology#>
PREFIX nfdi4culture: <https://nfdi4culture.de/id/>
PREFIX nfdicore: <https://nfdi.fiz-karlsruhe.de/ontology/>
PREFIX factgrid: <https://database.factgrid.de/entity/>
`;
sparqleditor.doc.setValue(prefixContent + editorContent);

})
</script>
</button>

<div>
    <textarea id="code" name="code">select distinct ?Concept where {[] a ?Concept} LIMIT 999</textarea>
</div>

<div id="results"></div>

<script src="/shmarql/static/editor.js"></script>
<script src="/shmarql/static/matchbrackets.js"></script>
<script src="/shmarql/static/sparql.js"></script>
<script src="/shmarql/static/htmx-2.0.3.min.js"></script>
<script src="/shmarql/static/surreal-1.3.0.js"></script>

<script>
  const link = document.createElement("link");
  link.rel = "stylesheet";
  link.href = "/shmarql/static/codemirror.css";
  document.head.appendChild(link);


document.addEventListener("DOMContentLoaded", function () {
  sparqleditor = CodeMirror.fromTextArea(document.getElementById("code"), {
    mode: "application/sparql-query",
    matchBrackets: true,
    lineNumbers: true,
  });
  results = document.getElementById("results");
});

function updateProgress() {
    let progress = Math.round((Date.now() - queryStarted) / 1000);
    results.innerHTML = `<div aria-busy="true">Query in progress, took ${progress}s so far...</div>`;
    progress_counter = setTimeout(updateProgress, 1000);
}

document.body.addEventListener("htmx:afterRequest", function (evt) {
    if(progress_counter) {
        clearTimeout(progress_counter);
    }    
});

document.body.addEventListener("htmx:configRequest", function (evt) {
  if (evt.shiftKey) {
        console.log("Shift key was pressed during the click!");
  }

  if (evt.detail.elt.id === "execute_sparql") {
    let the_query = sparqleditor.doc.getValue();
    evt.detail.parameters["query"] = the_query;
    results.innerHTML = '<div aria-busy="true">Loading...</div>';
    history.pushState({ query: the_query }, "", "shmarql?query=" + encodeURIComponent(the_query));
    queryStarted = Date.now();
    progress_counter = setTimeout(updateProgress, 1000);    
  }
});

document.body.addEventListener("keypress", function (evt) {
    if (evt.ctrlKey && evt.key === "Enter") {
        evt.preventDefault();
        htmx.trigger(document.getElementById("execute_sparql"), "click");
    }
});
</script>
