Code.require_file("util.exs")

File.stream!("data/challenge4-data.txt")
  |> Enum.map(fn x -> String.trim_trailing(x) end)
  |> Enum.map(fn x -> Util.find_key(x, ~r/^[A-Z][A-Za-z',. ]+$/) end)
  |> (fn z ->
      [
        "Line : #{Enum.find_index(z, fn x -> x != "" end)}\n",
        Enum.find(z, fn x -> x != "" end)
      ]
      end).()
  |> IO.puts
