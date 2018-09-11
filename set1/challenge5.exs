Code.require_file("util.exs")

text = "Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal"

Util.repeated_xor_encrypt(text, "ICE")
  |> Base.encode16(case: :lower)
  |> IO.puts
