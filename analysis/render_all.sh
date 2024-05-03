#! /bin/sh

SOURCE=analysis
OUTPUT=ownership/output

cat<<!
               Governing the Commons - Code Clones Replication Package

Will render the Rmd files (possibly restricted via glob prefix PREFIX) in the
$SOURCE subdirectory, and place the corresponding output files in $OUTPUT.

Note that rebuilding the models will take long time (many hours).
Therefore, the image itself contains the default, pre-built, model cache.
Replicating from scratch requires you to use a separate model cache directory.
See README.md for details on how to specify this.

!

for f in ${SOURCE}/${PREFIX}*.Rmd; do
    echo "============> Starting to generate file $f at:" $(date -Iseconds)
    R -e "rmarkdown::render(\"$f\", output_dir=\"$OUTPUT\")" || echo "FAILED - please check your environment or settings"
    echo "============> Finished file $f at:" $(date -Iseconds)
done
