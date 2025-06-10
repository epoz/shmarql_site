FROM ghcr.io/epoz/shmarql:v0.56

RUN rm -r /src/docs/
COPY docs/ /src/docs/

WORKDIR /src/
COPY mkdocs.yml a.yml
RUN python -m shmarql docs_build -f a.yml
