use Bitwise

defmodule Util do
  def hex_to_base64(hexstr) do
    hexstr
    |> Base.decode16!(case: :lower)
    |> Base.encode64
  end

  defp find_key_helper(hexstr, n) do
    hexstr
    |> Base.decode16!(case: :lower)
    |> :binary.bin_to_list
    |> Enum.map(fn x -> x ^^^ n end)
    |> List.to_string
  end

  # Determine XOR key by matching output with regex
  def find_key(hexstr, regex, n \\ 255) do
    candidate = find_key_helper(hexstr, n)
    cond do
      n - 1 == 0 ->
        ""
      String.match?(candidate, regex) ->
        "Hex  : #{hexstr}\n" <>
        "Text : #{String.trim(candidate)}\n" <>
        "Key  : #{Integer.to_string(n)}"
      true ->
        find_key(hexstr, regex, n - 1)
    end
  end

  def repeated_xor_encrypt(str, key) do
    size = div(String.length(str), String.length(key)) + 1
    ext = String.duplicate(key, size)
    [str, ext]
    |> Enum.map(fn x -> :binary.bin_to_list(x) end)
    |> Enum.zip
    |> Enum.map(fn {a, b} -> a ^^^ b end)
    |> List.to_string
  end
end
