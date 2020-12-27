# Mazes

A maze generator. Deployed at [mazes.angelika.me](https://mazes.angelika.me/).

## Setup

To start your Phoenix server:

  * Install Elixir, Erlang, and NodeJS with `asdf install`
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:5000`](http://localhost:5000) from your browser.

## Tests

The unit tests require a HTMl validator server running at `localhost:8888` (see [vnu-elixir](https://github.com/angelikatyborska/vnu-elixir)). Start it with:
```
docker run -it --rm -p 8888:8888 validator/validator:latest
```
