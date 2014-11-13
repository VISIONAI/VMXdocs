# VMX Documentation Generator

Here you will find documentation in Markdown format and some scriptp
to build the documentation and push it to
[https://docs.vision.ai](docs.vision.ai).

### compiling docs (on local machine)

Compilation uses [http://www.mkdocs.org/](mkdocs) to generate a static
site.

```sh
./compile.sh
```

This will generate a "site/" folder which can be bundled and sent off
to the documentation server.

### seeing changes to docs live (on local machine)

```sh
./serve.sh
```

This will broadcast the docs on the local network, so that they can be
viewed on iOS/Android devices.

### deploying docs (from local to docs.vision.ai)

This will send off the documentation to docs.vision.ai

```sh
./upload.sh
```

### running nginx to serve the docs

This requires a checkout of this directory on the docs file server

```sh
./server/start_nginx_docker.sh
```
