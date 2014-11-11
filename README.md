# Documentation for VMX

Here you will find documentation in Markdown format and some script to
build the documentation and push it to the docs.vision.ai server

### compiling docs

Compilation uses mkdocs to generate a static site.

```sh
./compile.sh
```

This will generate a "site/" folder which can be bundles and sent off
to the documentation server.

### seeing changes to docs live

```sh
mkdocs serve
```

### deploying docs

This will send off the documentation to docs.vision.ai

```sh
./upload.sh
```
