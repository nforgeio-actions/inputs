# inputs

Logs workflow inputs.

It would be nice if GitHub workflows logged their event inputs for debugging purposes but unfortunately
this is not supported at this time.

The **input** action is intended as an alternative.  This simply writes the workflow event inputs
to the action output.

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
```

That's all there is to this!
