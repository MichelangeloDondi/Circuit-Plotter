function collect_edges_from_cmd(node_count::Int, circuit::Circuit, edge_info::EdgeInfo)
    
    edge_count = 0
    while true
        println("---------------------------------------------------")
        println()
        println("$edge_count edges have been inserted up to now.")
        println("If all the edges have already been inserted, press Enter to finish.")
        println()
        println("Otherwise, if another edge is present (in this case it will be called E", edge_count + 1, "), enter the indexes of its node ends.")
        println("Give as input the indexes of the node ends in the format: i,j")
        println("(the direction of the edge is considered to be Ni->Nj)")
        println()
    
        flush(stdout)
        input = readline()
    
        if input == ""
            break
        end

        edge_nodes = split(input, ",")
        
        try
            node1, node2 = parse(Int, edge_nodes[1]), parse(Int, edge_nodes[2])
            push!(edge_info.edges, (node1, node2))
            add_edge!(circuit.graph, node1, node2)
            edge_count += 1
            println("\n---------------------------------------------------")
            println("\nThe edge between nodes $node1 and $node2 has been successfully added as E$edge_count(N$node1->N$node2).\n ")

        catch e
            if isa(e, ArgumentError)
                println("\nInvalid input. Ensure you are entering two valid integer node indexes separated by a comma.")
            else
                println("\nUnexpected error: ", e)
            end
        end
    end
end
