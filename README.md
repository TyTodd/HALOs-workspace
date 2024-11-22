# HALOs on Matlaber
First use Remote-SSH vscode esxtension to ssh in. You san set the host name to `matlaber6.mit.edu`

## Docker
Build the container
```
docker build -t halos_env .
```
Run the container
replace `~/UROP/HALOs-workspace/home` with local path to `HALOs-workspace/home` 
```
docker run -d   --name halos_container   -v ~/UROP/HALOs-workspace/home:/home   halos_env   bash -c "tail -f /dev/null"
```
Enter the container
```
docker exec -it halos_container /bin/bash
```

If you ever need to restart the container you can use:
```
docker stop halos_container
docker rm halos_container
```

Now just do everything in the home directory