function collect_nodes_from_cmd(node_count, circuit::Circuit)
    for i in 1:node_count
        while true
            println("\n$(i-1) of $(node_count) nodes have been inserted up to now.")
            println("Enter the coordinates of the next node, which will be called N$i (format: x$i,y$i): ")
            println()
            flush(stdout)
            input = readline()
        
            coords = split(input, ",")
            try
                x, y = parse(Int, coords[1]), parse(Int, coords[2])
                push!(circuit.nodes, Node(i, x, y))
                add_vertex!(circuit.graph)
                println()
                println("---------------------------------------------------")
                println()
                println("Node N$i successfully inserted at position ($x, $y).")
                println()
                println("---------------------------------------------------")
                break
            catch
                println("\nInvalid input. Ensure you're entering valid pair of integer coordinates (x,y).")
            end
        end
    end

end