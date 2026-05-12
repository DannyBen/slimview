# Slimview

![repocard](https://repocard.dannyben.com/svg/slimview.svg)

A lightweight command-line tool and Ruby library for quickly previewing
[Slim](https://slim-template.github.io/) templates in a local web server
powered by [Sinatra](https://sinatrarb.com/).

## Features

- Instantly preview `.slim` templates in your browser
- Minimal setup - just point to a folder and go
- Create a starter workspace with `slimview init`
- Automatically reloads templates in development
- Configurable port, templates, assets, and components directories via flags or
  environment variables
- Automatically wraps views with `layout.slim` when present
- Render partial Slim templates via `== slim :other_template`
- Render component templates via `== component 'card', title: 'Hello'`


## Installation

```bash
gem install slimview
```

Or add it to your `Gemfile`:

```ruby
gem 'slimview'
```

### Docker

Slimview is also available as a docker image:

```shell
docker run --rm -it -v $PWD:/docs -p 3000:3000 dannyben/slimview
```

or as a docker compose service:

```yaml
services:
  web:
    build: .
    image: dannyben/slimview
    volumes: ["./:/docs"]
    ports: ["3000:3000"]
```

[View image on Docker Hub](https://hub.docker.com/r/dannyben/slimview)


## Command-Line Usage

```bash
$ slimview --help

Run a slim server

Usage:
  slimview [--port PORT] [--root PATH] [--assets PATH] [--components PATH]
  slimview init [PATH] [--force]

Commands:
  init
    Create a new baseline workspace

Options:
  -p --port PORT
    Set the port to run the server on (default: 3000)

  -r --root PATH
    Set the root templates directory (default: ./templates)

  -a --assets PATH
    Set the assets directory (default: <root>/assets)

  -c --components PATH
    Set the components directory (default: <root>/components)

  -f --force
    Copy files even when the target directory is not empty

  -h --help
    Show this help

  --version
    Show version number

Parameters:
  PATH
    The workspace directory to initialize (default: .)

Environment Variables:
  SLIMVIEW_PORT
    Set the port

  SLIMVIEW_ROOT
    Set the root templates directory

  SLIMVIEW_ASSETS
    Set the assets directory

  SLIMVIEW_COMPONENTS
    Set the components directory

```

Example:

```bash
# Create a minimal workspace in the current directory
slimview init

# Create a minimal workspace in another directory
slimview init docs

# Serve Slim templates from ./templates at http://localhost:3000
slimview

# Serve from another folder on port 8080
slimview --root app/views --port 8080

# Serve with a custom assets directory
slimview --root app/views --assets public/assets

# Serve with a custom components directory
slimview --root app/views --components app/components

# Use environment variables instead of flags
SLIMVIEW_ASSETS=public/assets SLIMVIEW_ROOT=app/views SLIMVIEW_COMPONENTS=app/components slimview
```

### Workspace Structure

By default, Slimview expects this structure:

```text
templates/
  index.slim
  layout.slim
  assets/
    style.css
  components/
    card.slim
```

`slimview init [PATH]` creates this structure for you. It refuses to initialize
a non-empty directory unless `--force` is passed.

`--root` sets the templates directory. `--assets` defaults to `<root>/assets`,
and `--components` defaults to `<root>/components`. Relative paths are resolved
from the directory where you run `slimview`.

### Components

Components are regular Slim templates rendered without the page layout. They are
loaded from the components directory and can receive locals:

```slim
/ templates/index.slim
== component 'card', title: 'Hello', body: 'Rendered from a component'
```

```slim
/ templates/components/card.slim
.card
  h2 = title
  p = body
```

## Ruby API Usage

You can also use Slimview programmatically from Ruby:

```ruby
require 'slimview'

# Start the server with default port 3000 and default 'templates' root
Slimview::Server.new.start

# Customize port and templates root
server = Slimview::Server.new port: 4000, root: 'views/slim'
server.start

# Override the assets directory
server = Slimview::Server.new root: 'views/slim', assets: 'public/assets'
server.start

# Override the components directory
server = Slimview::Server.new root: 'views/slim', components: 'views/components'
server.start

# Pass locals (available as variables inside your Slim templates)
server = Slimview::Server.new items: ['one', 'two'], title: 'Hello'
server.start
```


## Notes

- Templates are served from the directory specified by `--root`
  (or `SLIMVIEW_ROOT`).
- Static files (images, CSS, JS) can be placed in an `assets/` directory and
  overridden via `--assets` or `SLIMVIEW_ASSETS`.
- Component templates can be placed in a `components/` directory and overridden
  via `--components` or `SLIMVIEW_COMPONENTS`.
- Slim templates are automatically reloaded on each request in development mode.
- The tool is intended for **local development and previewing**, not for
  production use.
