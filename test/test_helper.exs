ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(Qujump.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)
