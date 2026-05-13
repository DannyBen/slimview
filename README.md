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
- Load Ruby context data for templates from `context.rb`
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
  slimview save [PATH] [--root PATH] [--assets PATH] [--components PATH]

Commands:
  init
    Create a new baseline workspace

  save
    Save rendered HTML to a file

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
    The workspace directory to initialize, or HTML file to save (default: stdout)

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

# Print the rendered index page HTML
slimview save

# Save the rendered index page to another file
slimview save dist/index.html

# Print the rendered index page HTML explicitly
slimview save -

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
  context.rb
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

### Context

Add `context.rb` to your templates directory when templates need shared data.
Slimview evaluates this file before rendering each request, and local variables
defined there become available in your Slim templates.

```ruby
# templates/context.rb
cards = [
  { title: 'Hello', body: 'Rendered from Ruby context' }
]
```

The variables are then available directly by name:

```slim
/ templates/index.slim
- cards.each do |card|
  == component 'card', title: card[:title], body: card[:body]
```

This is useful as a Ruby-powered alternative to static data files. For example,
you can load YAML and reshape it before rendering:

```ruby
# templates/context.rb
require 'yaml'

site = YAML.load_file('data/site.yml')
pages = site.fetch('pages').sort_by { |page| page.fetch('title') }
```

You can also define small classes or helper objects when a template needs richer
data than plain hashes:

```ruby
# templates/context.rb
class Page
  attr_reader :title, :path

  def initialize(title, path)
    @title = title
    @path = path
  end
end

pages = [
  Page.new('Home', '/'),
  Page.new('About', '/about')
]
```

`context.rb` is trusted project Ruby, not a sandboxed configuration format. It
can require libraries, read files, and define constants. For larger context
objects, prefer project-specific names or modules to avoid top-level class name
conflicts.

When Slimview is used through the Ruby API, locals passed to
`Slimview::Server.new` override locals with the same name from `context.rb`.

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
