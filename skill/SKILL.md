---
name: slimview
description: Build, inspect, and debug Slim template previews with the Slimview CLI. Use when working in a project that uses Slimview templates, components, context.rb data, or the slimview command to verify rendering, render HTML, or start a local preview server.
---

# Slimview

Use Slimview to preview and validate Slim template work through the project CLI.

## Core Workflow

1. Verify renderability first:

   ```bash
   slimview check
   ```

   Use `check` when the goal is to confirm that the page renders. It exits nonzero on render failure and does not print the rendered HTML.

2. Render HTML only when needed:

   ```bash
   slimview render
   slimview render output/index.html
   ```

   Use `render` when the user needs the generated HTML or when inspecting the rendered document is useful.

3. Start the server only for browser preview:

   ```bash
   slimview
   ```

   Use the server for visual review or interactive browser inspection. Do not start it just to check whether templates compile.

## Paths

- By default, Slimview uses `templates` as the templates directory.
- Use `--root PATH` only when the templates directory is not `templates`.
- Use `--assets PATH` when static assets are outside `<root>/assets`.
- Use `--components PATH` when component templates are outside `<root>/components`.
- Prefer passing these flags over moving project files around.

## Template Data

- Use `context.rb` in the templates directory for trusted local Ruby data setup.
- Variables defined in `context.rb` become template locals.
- Keep template-specific data shaping in `context.rb` instead of hardcoding generated HTML.

## Errors

- Treat `slimview check` and `slimview render` failures as Ruby/Slim render errors.
- Fix the source template, layout, component, or `context.rb`.
- Do not parse Sinatra HTML error pages; CLI rendering raises compact exceptions for agent use.

## Agent Defaults

- For code changes: run `slimview check` before reporting success.
- For visual/layout changes: start the server only if browser inspection is needed.
- For generated artifacts: use `slimview render FILE --root templates`.
