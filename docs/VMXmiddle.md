# VMX REST API


VMX Middle runs on top of VMX server and serves the VMX App Builder
over HTTP.  This document describes the REST API provided by VMX.

---

## Routes


VERB    | Route   | Description
----|-------------| ----------
GET  | /session  | List open sessions
GET  | /model   |  List available models
POST | /session |  Create a new session
POST | /session/#session_id   |  Detect objects inside the image
GET  | /session/#session_id/params  | List loaded model's parameters
POST | /session/#session_id/edit   |  Edit the model
POST | /session/#session_id/load   |  Load a model
GET  | /check  | Check VMX version and whether this copy is licensed
POST | /activate/#key | Active this copy of VMX
GET  | /random | Return a random image from the models


## Possible Errors

```json
{
error: "Error ExitFailure 11: Cannot Start /vmx/build/VMXserver"
}
```

ExitFailure 11 means that the licensing check failed and your VMX
installation needs to be activated.  Try visiting the
`http://localhost:3000/check` URL and confirm that the licensed field
is `false`.

