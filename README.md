# Clothingstore

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

Seed the database with with `mix run priv/repo/seeds.exs`

# Postgres

To start the postgres server:
  * run `docker compose -f db/docker-compose.yml up -d`
Or run natively with username and password as `postgres`.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Developed with
`Erlang/OTP 26 [erts-14.2.5.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]`
`Elixir 1.14.0 (compiled with Erlang/OTP 24)`