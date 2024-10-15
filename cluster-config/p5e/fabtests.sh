SHARED_DIR="/shared"
COMPUTE_NODES="q1-st-cr1-1 q1-st-cr1-2"
TESTS="rdm_tagged_bw,rdm_tagged_pingpong,runt"
TESTS_WITH_GDR="rdm_tagged_bw,rdm_tagged_pingpong,runt,enable-gdr"

bash install-fabtests.sh $SHARED_DIR/fabtests
bash run-fabtests.sh \
$SHARED_DIR/fabtests \
$SHARED_DIR/fabtests/outputs/fabtests.pid \
$SHARED_DIR/fabtests/outputs/fabtests.log \
$SHARED_DIR/fabtests/outputs/fabtests.report \
$COMPUTE_NODES \
$TESTS

scp -i ~/.ssh/pem_keys/mgiacomo/mgiacomo.pem ec2-user@13.58.171.66:/shared/fabtests/outputs/fabtests.report /Users/mgiacomo/Downloads/