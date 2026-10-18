# tent.io

This repository hosts the Tent blog and documentation. Take a look at [the other repositories](https://github.com/tent) for Tent server and client implementations.

The site is built with Middleman 3.1, which only runs on old Ruby, so everything goes through Docker.

## AT Protocol annotations

Set `ATPROTO_ANNOTATIONS=1` when building (or running `bin/dev`) to add notes naming the closest AT Protocol concept to matching sections of the site, with links to the [AT Protocol docs](https://atproto.com) (or [Bluesky's](https://docs.bsky.app) for Bluesky record types). Readers turn them on with the switch in the corner of the page (off by default, remembered per browser). Cards sit in the margin beside their headings where there's room, and open from an `at://` marker where there isn't, so the original page never moves. They're off by default. The notes live in `annotations/atproto.json`, checked against `annotations/atproto.schema.json` at build time, and the build fails if a note's heading no longer exists. On Railway, set the variable on the `tent` service and redeploy.

## Scripts

Dev (live-reloading preview at http://localhost:4567):

    bin/dev

Check (builds the site and the production image, with and without annotations):

    docker build --platform linux/amd64 . && docker build --platform linux/amd64 --build-arg ATPROTO_ANNOTATIONS=1 .

Deploy to Railway (the Dockerfile builds the site and serves it with Caddy on `$PORT`). Link the checkout once with `railway link --project tent.bnb.im --service tent`, since an unlinked `railway up` creates a new project:

    railway up
