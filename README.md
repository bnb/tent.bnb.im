# tent.io

This repository hosts the Tent blog and documentation. Take a look at [the other repositories](https://github.com/tent) for Tent server and client implementations.

The site is built with Middleman 3.1, which only runs on old Ruby, so everything goes through Docker.

## Scripts

Dev (live-reloading preview at http://localhost:4567):

    bin/dev

Check (builds the site and the production image):

    docker build --platform linux/amd64 .

Deploy to Railway (the Dockerfile builds the site and serves it with Caddy on `$PORT`):

    railway up
