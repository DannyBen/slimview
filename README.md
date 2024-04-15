# Slimview - CLI to render and serve Slim templates

## Install

Install dependencies:

```
$ gem install sinatra slim puma
```

Put the `slimview` file in your path and make it executable.

## Docker

```
$ docker run --rm -it -v $PWD:/docs -p 3000:3000 dannyben/slimview
```

[View image on Docker Hub](https://hub.docker.com/r/dannyben/slimview)

## Usage

Run `slimview` in a folder that contains `*.slim` templates, and open your
browser at [localhost:3000/page-name](http://localhost:3000) (without the
`.slim` extension).

Run `slimview save` to convert all `*.slim` files to HTML.
