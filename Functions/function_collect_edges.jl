# User input for edges


# ----------------- Imported Modules -----------------
    
    # Auxiliary functions from auxiliary_functions2.jl
    using .Auxiliary_Functions: overlapping_edges 

    # Help functions from help_functions.jl
    using .Help_Functions: show_help
    
#########################################################
    # Begin of the function collect_edges_from_cmd
#########################################################

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
        
            if input == "help"
                show_help()
                continue
            elseif input == "exit"
                println("Exiting the program.")
                exit(0)
            elseif input == ""
                break
            end

            edge_nodes = split(input, ",")
            
            # Check if the input has exactly two items
            if length(edge_nodes) != 2
                println("\nInvalid format. Ensure you enter the input in the format 'i,j'.")
                continue
            end
            
            try
                node1, node2 = parse(Int, edge_nodes[1]), parse(Int, edge_nodes[2])

                # Check if the edge already exists
                found_existing_edge = false
                for (index, existing_edge) in enumerate(edge_info.edges)
                    # Check of both directions of the edge
                    if (node1, node2) == existing_edge 
                        println("\nThe nodes N$node1 and N$node2 are already connected with the edge E$index(N$node1->N$node2).\n")
                        found_existing_edge = true
                        break
                    elseif (node2, node1) == existing_edge
                        println("\nThe nodes N$node1 and N$node2 are already connected with the edge E$index(N$node2->N$node1).\n")
                        found_existing_edge = true
                        break
                    end
                end

                # Continue to the next iteration if the edge was already defined
                if found_existing_edge
                    continue
                end

                # Check if the nodes are valid
                if node1 < 1 || node1 > node_count
                    println("\nNode $node1 is out of bounds. Please enter a value between 1 and $node_count.")
                    continue
                elseif node2 < 1 || node2 > node_count
                    println("\nNode $node2 is out of bounds. Please enter a value between 1 and $node_count.")
                    continue
                elseif node1 == node2
                    println("\nInvalid input. Node indices must be distinct.")
                    continue
                end

                # Check for overlapping edges only if the edge has not been defined already
                overlapping = overlapping_edges((node1, node2), edge_info.edges, circuit.nodes)
                if !isempty(overlapping)
                    overlaps_str = join(["E$(index)(N$(edge[1])->N$(edge[2]))" for (index, edge) in overlapping], ", ")
                    println("\nEdge between nodes $node1 and $node2 overlaps with the existing edge(s): $overlaps_str.\n")
                    continue
                end

                if !found_existing_edge
                    push!(edge_info.edges, (node1, node2))
                    add_edge!(circuit.graph, node1, node2)
                    edge_count += 1
                    println("\n---------------------------------------------------")
                    println("\nThe edge between nodes $node1 and $node2 has been successfully added as E$edge_count(N$node1->N$node2).\n ")
                end

            catch e
                if isa(e, ArgumentError)
                    println("\nInvalid input. Ensure you are entering two valid integer node indexes separated by a comma.")
                else
                    println("\nUnexpected error: ", e)
                end
            end
        end
    end

# Confirming that all edges have been successfully inserted and providing a list of them    
function edges_recap(edge_info::EdgeInfo)
    println("---------------------------------------------------")
    println("---------------------------------------------------")
    println()
    println("All edges have been successfully added.")
    println("This is the list of the edges present in the circuit: ")
    println()
    for i in 1:length(edge_info.edges)
        println("Edge E$i starts from node N$(edge_info.edges[i][1]) and arrives in node N$(edge_info.edges[i][2])")
    end
    println()
    println("---------------------------------------------------")
end    