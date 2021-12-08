a = :item2
case a do
  nil -> 
    IO.puts "null"
    IO.puts "play again"
  a when a in [:item, :value] -> 
    IO.inspect a
    IO.puts "play again"
  _ ->
    IO.puts "not found"
end
