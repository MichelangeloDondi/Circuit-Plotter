# ----------------- Imported Modules -----------------

    using .Help_Functions: show_help

#########################################################
    # Begin of the function collect_nodes_from_cmd
#########################################################

    function collect_nodes_from_cmd(node_count, circuit::Circuit)
        for i in 1:node_count
            while true
                println("\n$(i-1) of $(node_count) nodes have been inserted up to now.")
                println("Enter the (integer) coordinates of the next node, which will be called N$i (format: x$i,y$i): ")
                println()
                flush(stdout)
                input = readline()
            
                if input == "help"
                    show_help()
                    continue
                elseif input == "exit"
                    println("Exiting the program.")
                    exit(0)
                end
            
                coords = split(input, ",")
                try
                    x, y = parse(Int, coords[1]), parse(Int, coords[2])

                    # Check if the node is already defined at the given position
                    existing_node_index = findfirst(n -> n.x == x && n.y == y, circuit.nodes)
                    if existing_node_index !== nothing
                        println("\nNode already defined at position ($x, $y). It is node N$(circuit.nodes[existing_node_index].id).")
                        continue  # Skip the rest of the loop and prompt again
                    end

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

    # Confirming that all nodes have been successfully inserted and providing a list of them
    function nodes_recap(circuit::Circuit)
        println("---------------------------------------------------")
        println()
        println("All nodes have been successfully inserted.")
        println("This is the list of nodes present in the circuit: ")
        println()
        for i in 1:length(circuit.nodes)
            println("Node N$(circuit.nodes[i].id) is at position ($(circuit.nodes[i].x), $(circuit.nodes[i].y))")
        end
        println()
        println("---------------------------------------------------")
    end