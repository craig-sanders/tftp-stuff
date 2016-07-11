
1. run `./fetch-update latest` to download the latest amd64 stable clonezilla .zip

 or `./fetch-update version dist arch` to fetch a specific version

2. run `./unpack.sh gparted-live-$version-$arch.zip`

3. run `./make-gp-menu.sh > default`



Or just run either `make all` to create/re-create the `default` file or
`make allfetch` to fetch the latest gparted, unpack it, and create
`default`.

