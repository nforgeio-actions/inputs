# inputs

Logs workflow inputs.

It would be nice if GitHub workflows logged their event inputs for debugging purposes but unfortunately
this is not supported at this time.

The **input** action is intended as an alternative.  This simply writes the **input** string passed to
the workflow log.  This can be any string, but typically you'll want to format this as YAML.

## Examples

**typical use:**
```
name: my-workflow
on: 
  workflow_dispatch:
    inputs:
      input1:
        description: "Test input1:"
        required: false
      input2:
        description: "Test input2"
        required: false

jobs:
  my-job:
    runs-on: self-hosted
    env:
      MASTER_PASSWORD: ${{ secrets.DEVBOT_MASTER_PASSWORD }}

    steps:

    #--------------------------------------------------------------------------
    # Initialize

    # Node.js is required by our custom actions

    - uses: actions/setup-node@v2
      with:
        node-version: '14'    

    # Complete the initialization

    - id: environment
      uses: nforgeio-actions/environment@master
      with:
        master-password: ${{ secrets.DEVBOT_MASTER_PASSWORD }}

    - uses: nforgeio-inputs@master
      with:
        inputs: |
          input1: ${{ github.event.inputs.input1 }}
          input2: ${{ github.event.inputs.input2 }}
```

Notice how we use the YAML "|" operator to pass a multi-line YAML formatted string to the action.

**NOTE:** In the future we may be able to parse the webhook event payload file referenced by the
**GITHUB_EVENT_PATH** environment variable to read and format the inputs automatically but this
implementation should suffice for now.
