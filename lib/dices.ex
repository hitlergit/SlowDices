defmodule Dices do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.reduce(0, fn x, acc -> Task.await(x) + acc end)
  end
  
  def main(file) do
    # File.stream!(file) |> Stream.map( &(String.split("d", &1)) ) |> Enum.each(&(List.to_tuple &1)) |> Stream.map(&(dices/1)) |> Enum.each(&IO.inspect/1)
    String.split(File.read!(file), "\n") |> Enum.drop(-1) |> pmap(&dices(String.split(&1, "d") )) |> IO.puts
    # File.open!(file) |> IO.stream(:line) |> Enum.map(&(String.trim_trailing(&1))) |> pmap(&(dices(&1))) |> Enum.sum
  end

  def dices([a | [b | []]]) do
    Enum.reduce(1 .. (String.to_integer(a)), 0, fn(_, acc) -> Enum.random(1..(String.to_integer b)) + acc end)
    # (for i <- 1 .. (String.to_integer(a)), i > 1, do: Enum.random(1..(String.to_integer b))) |> Enum.sum
  end
end
