# Slimview

A lightweight command-line tool and Ruby library for quickly previewing
[Slim](https://slim-template.github.io/) templates in a local web server
powered by [Sinatra](https://sinatrarb.com/).

## Features

- Instantly preview `.slim` templates in your browser
- Minimal setup - just point to a folder and go
- Automatically reloads templates in development
- Configurable port and root directory via flags or environment variables


## Installation

```bash
gem install slimview
```

Or add it to your `Gemfile`:

```ruby
gem 'slimview'
```


## Command-Line Usage

```bash
$ slimview --help

Usage: slimview [options]

Options:
  --port PORT       Set the port to run the server on (default: 3000)
  --root PATH       Set the root templates directory (default: ./templates)
  --assets PATH     Set the assets directory (default: <root>/assets)
  --help, -h        Show this help message
  --version, -v     Print version info

Environment Variables:
  SLIMVIEW_PORT     Set the port
  SLIMVIEW_ROOT     Set the root templates directory
  SLIMVIEW_ASSETS   Set the assets directory

```

Example:

```bash
# Serve Slim templates from ./templates at http://localhost:3000
slimview

# Serve from another folder on port 8080
slimview --root app/views --port 8080

# Serve with a custom assets directory
slimview --root app/views --assets public/assets

# Use environment variables instead of flags
SLIMVIEW_ASSETS=public/assets SLIMVIEW_ROOT=app/views slimview
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

# Pass locals (available as variables inside your Slim templates)
server = Slimview::Server.new items: ['one', 'two'], title: 'Hello'
server.start
```


## Notes

- Templates are served from the directory specified by `--root`
  (or `SLIMVIEW_ROOT`).
- Static files (images, CSS, JS) can be placed in an `assets/` directory and
  overridden via `--assets` or `SLIMVIEW_ASSETS`.
- Slim templates are automatically reloaded on each request in development mode.
- The tool is intended for **local development and previewing**, not for
  production use.


## License

MIT License © 2025
