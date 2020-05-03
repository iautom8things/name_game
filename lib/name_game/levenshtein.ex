defmodule Levenshtein do
  def store_result(key, result, cache) do
    {result, Dict.put(cache, key, result)}
  end

  def distance(str1, str2) when is_binary(str1) and is_binary(str2) do
    cl1 = String.to_char_list(str1)
    cl2 = String.to_char_list(str2)
    distance(cl1, cl2)
  end

  def distance(string_1, string_2) do
    {list, _} = distance(string_1, string_2, HashDict.new())
    list
  end

  def distance(string_1, [] = string_2, cache) do
    store_result({string_1, string_2}, length(string_1), cache)
  end

  def distance([] = string_1, string_2, cache) do
    store_result({string_1, string_2}, length(string_2), cache)
  end

  def distance([x | rest1], [x | rest2], cache) do
    distance(rest1, rest2, cache)
  end

  def distance([_ | rest1] = string_1, [_ | rest2] = string_2, cache) do
    case Dict.has_key?(cache, {string_1, string_2}) do
      true ->
        {Dict.get(cache, {string_1, string_2}), cache}

      false ->
        {l1, c1} = distance(string_1, rest2, cache)
        {l2, c2} = distance(rest1, string_2, c1)
        {l3, c3} = distance(rest1, rest2, c2)
        min = :lists.min([l1, l2, l3]) + 1
        store_result({string_1, string_2}, min, c3)
    end
  end
end
