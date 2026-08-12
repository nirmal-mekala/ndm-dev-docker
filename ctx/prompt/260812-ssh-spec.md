### prompt

i missed a requirement

the nirmal user in the container should be able to ssh. it doesnt need to be an
SSH _server_ - i can use docker to zsh in - but it SHOULD be able to connect to
external ssh servers (for git).

also, i plan to use a docker volume for the whole nirmal user's home directory
(related because i expect to not have to add a new ssh pubkey to gitlab each
time i restart), so can you ensure that the dockerfile is compatible with thtat approach
