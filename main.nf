#!/usr/bin/env nextflow

import org.yaml.snakeyaml.Yaml

nextflow.enable.dsl = 2

//test profile to run
params.profile = "singularity"
//path to a local copy of the nf-core modules repository
params.modules_dir = "/home/sturm/projects/2020/nf-core-modules"
//output directory
params.results = "results"
params.publish_dir_mode = "symlink"


process test_module {

    tag { pytest_tag }

    conda "env.yml"

    publishDir "${params.results}/logs/${tmp_tag}/", mode: params.publish_dir_mode, pattern: "*.log"
    publishDir "${params.results}/workflow-dirs/${tmp_tag}/", mode: params.publish_dir_mode, pattern: "pytest-workflow"

    input:
    val pytest_tag
    path modules_dir

    output:
    path "*.log", emit: log
    path "pytest-workflow", emit: workflow_dir, optional: true
    path "success.txt", emit: success
    path "failed.txt", emit: failed

    script:
    tmp_tag = pytest_tag.replace("/", "_")
    """
    touch success.txt failed.txt
    CWD=\$(pwd)
    PYTEST_WORKFLOW_DIR=\$(pwd)/pytest-workflow
    cd $modules_dir && \\
    NF_CORE_MODULES_TEST=1 PROFILE=${params.profile} pytest \\
        --tag $pytest_tag \\
        --symlink --kwd \\
        --basetemp=\$PYTEST_WORKFLOW_DIR 2>&1 > \$CWD/${tmp_tag}.log && \\
        echo ${pytest_tag} > \$CWD/success.txt || \\
        echo ${pytest_tag} > \$CWD/failed.txt
    """

}

workflow {

    Yaml parser = new Yaml()
    def yaml = parser.load(file("${params.modules_dir}/tests/config/pytest_modules.yml").text)

    test_module(Channel.from(yaml.keySet()), file(params.modules_dir))

    test_module.out.success.collectFile(name: "${params.results}/succeeded.txt", sort: true)
    test_module.out.failed.collectFile(name: "${params.results}/failed.txt", sort: true)

}
