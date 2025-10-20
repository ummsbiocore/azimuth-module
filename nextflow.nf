$HOSTNAME = ""
params.outdir = 'results'  


if (!params.input){params.input = ""} 
if (!params.reference){params.reference = ""} 
if (!params.reference_index){params.reference_index = ""} 

if (params.input){
   Channel.fromPath(params.input, type: 'any').map{ file -> tuple(file.baseName, file) }.set{g_1_0_g_0}
} else {
	g_1_0_g_0 = Channel.empty()
}
g_2_1_g_0 = file(params.reference, type: 'any')
g_3_2_g_0 = file(params.reference_index, type: 'any')

//* autofill
if ($HOSTNAME == "default"){
    $CPU  = 5
    $MEMORY = 60
}
//* platform
//* platform
//* autofill

process Azimuth_Annotation {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}_annotated.rds$/) "azimuth_annotation/$filename"}
input:
 tuple val(name), file(input)
 path reference
 path reference_index

output:
 path "${name}_annotated.rds"  ,emit:g_0_rdsFile00 

container "quay.io/viascientific/azimuth:1.0.0"

script:
	
"""
mkdir reference
cp ${reference} reference/ref.Rds
cp ${reference_index} reference/idx.annoy

azimuth_annotation.R ${input} ${name}_annotated.rds
"""
}


workflow {


Azimuth_Annotation(g_1_0_g_0,g_2_1_g_0,g_3_2_g_0)
g_0_rdsFile00 = Azimuth_Annotation.out.g_0_rdsFile00


}

workflow.onComplete {
println "##Pipeline execution summary##"
println "---------------------------"
println "##Completed at: $workflow.complete"
println "##Duration: ${workflow.duration}"
println "##Success: ${workflow.success ? 'OK' : 'failed' }"
println "##Exit status: ${workflow.exitStatus}"
}
