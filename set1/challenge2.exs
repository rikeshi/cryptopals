use Bitwise

buffer1 = "1c0111001f010100061a024b53535009181c"
buffer2 = "686974207468652062756c6c277320657965"

[buffer1, buffer2]
  |> Enum.map(fn x -> Base.decode16!(x, case: :lower) end)
  |> Enum.map(fn x -> :binary.bin_to_list(x) end)
  |> Enum.zip
  |> Enum.map(fn {a, b} -> a ^^^ b end)
  |> List.to_string
  |> Base.encode16(case: :lower)
  |> IO.puts
