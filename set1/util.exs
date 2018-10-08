use Bitwise

defmodule Util do
  def hex_to_base64(hexstr) do
    hexstr
    |> Base.decode16!(case: :lower)
    |> Base.encode64
  end

  def popcount(z, i \\ 0) do
    case z do
      0 -> i
      _ -> popcount(z &&& z-1, i+1)
    end
  end

  def hamming(x, y) when is_integer(x) and is_integer(y) do
    popcount(x ^^^ y)
  end

  def hamming(s1, s2) when is_binary(s1) and is_binary(s2) do
    [s1, s2]
    |> Enum.map(fn x -> :binary.bin_to_list(x) end)
    |> Enum.zip
    |> Enum.reduce(0, fn {a, b}, acc -> hamming(a, b) + acc end)
  end

  # distribution divergence from P to Q
  # takes a zipped list
  def kl_divergence(pq) when is_list(pq) do
    pq
    |> Enum.map(fn {pi, qi} -> pi * :math.log(pi/qi) end)
    |> Enum.sum
  end

  # distribution divergence from P to Q
  # takes two seperate lists
  def kl_divergence(p, q) when is_list(p) and is_list(q) do
    Enum.zip(p, q)
    |> kl_divergence
  end

  def ngrams(str, n) when is_binary(str) and is_integer(n) do
    0..String.length(str) - n
    |> Enum.map(&String.slice(str, &1, n))
  end

  def english_score(str, freqs) when is_binary(str) and is_map(freqs) do
    n = String.length(str)
    max_ngram = freqs
    |> Map.keys
    |> Enum.map(&String.length/1)
    |> Enum.max
    1..max_ngram
    |> Enum.map(&ngrams(String.downcase(str), &1))
    |> Enum.map(&Enum.filter(&1, fn x -> freqs[x] end))
    |> Enum.map(&Enum.map(&1, fn x -> freqs[x] end))
    |> Enum.with_index(1)
    |> Enum.map(fn {x, i} -> {x, i * (n - Enum.count(x))} end)
    |> Enum.map(fn {x, i} -> {Enum.reduce(x, 0, &(&1 + &2)), i} end)
    |> Enum.map(fn {x, i} -> :math.pow(i, 2) * x / (n * n) end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  def xor_hex(hexstr, n) do
    hexstr
    |> Base.decode16!(case: :lower)
    |> :binary.bin_to_list
    |> Enum.map(fn x -> x ^^^ n end)
    |> List.to_string
  end

  # Determine XOR key by matching output with regex
  def find_key(hexstr, regex, n \\ 255) do
    candidate = xor_hex(hexstr, n)
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

  # Determine XOR key by matching output with regex
  def find_key2(hexstr, freqs, n \\ 255) do
    0..n
    |> Enum.map(&xor_hex(hexstr, &1))
    |> Enum.map(&english_score(&1, freqs))
    |> Enum.with_index
    |> Enum.max_by(fn {x, _} -> x end)
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

defmodule IOUtil do
  def read_db_from_file(filename) do
    filename
    |> File.stream!
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [k, v] -> {k, String.to_float(v)} end)
    |> Enum.to_list
  end

  def read_db_from_files(filenames) do
    filenames
    |> Enum.map(&read_db_from_file/1)
    |> List.flatten
    |> Enum.into(%{})
  end
end
