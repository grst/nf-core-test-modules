# Workflow to test nf-core modules

A nextflow-inception: run a nextflow pipeline to run pytest-workflow which runs nextflow. This
workflow can be used to run all module-tests from nf-core/modules locally.

## Hint:

use

```bash
find  -L  workflow-dirs -maxdepth 4 -type f -exec tar -rvhf workflow-dirs.tar.gz {} \;
```

to pack up the `workflow-dirs` directory.
