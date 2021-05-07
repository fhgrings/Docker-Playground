sudo docker run --rm -v $(pwd):/backup -v $(pwd)/volumes:/volumes busybox sh -c "tar -czvf /backup/volumes.tar /volumes/ "
