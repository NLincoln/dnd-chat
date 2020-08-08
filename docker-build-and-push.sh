set -e;


GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(git rev-parse HEAD)

docker build . -t nlincoln/dnd-chat:$GIT_BRANCH
docker build . -t nlincoln/dnd-chat:$GIT_COMMIT

docker push nlincoln/dnd-chat:$GIT_BRANCH
docker push nlincoln/dnd-chat:$GIT_COMMIT
