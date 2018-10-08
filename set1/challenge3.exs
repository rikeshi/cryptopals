Code.require_file("util.exs")

f1 = "resources/1grams.csv"
f2 = "resources/1punct.csv"
f3 = "resources/2grams.csv"
f4 = "resources/3grams.csv"

db = IOUtil.read_db_from_files([f1, f2, f3, f4])

hex = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

Util.find_key2(hex, db)
  |> (fn {_, k} -> Util.xor_hex(hex, k) end).() |> IO.puts
    #~r/^[A-Z][A-Za-z',. ]+$/) |> IO.puts


