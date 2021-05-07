sudo docker run --rm -v $(pwd):/backup -v $(pwd)/volumes:/volumes busybox sh -c "tar -xzvf /backup/volumes.tar"

