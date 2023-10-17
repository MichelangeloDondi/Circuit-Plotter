function collect_components_from_cmd(circuit::Circuit, edge_info::EdgeInfo)
    # User input for circuit components
    for i in 1:length(edge_info.edges)
        while true
            println("---------------------------------------------------")
            println()
            println("Do you want to add a component to E$i(N$(edge_info.edges[i][1])->N$(edge_info.edges[i][2]))?")
            println()
            print("If you choose not to add a component, the edge will be considered to be a section of wire ")
            println("(note that no more then one component can be added for each edge).")
            println("Enter your choice (y/n):")
            println()
            flush(stdout)
            decision = readline(stdin)
            println()

            if decision == "y"
                println("\nEnter details for component on Edge $i (e.g. 'R1 = 10 [Ω]'):\n")
                flush(stdout)
                component_details = readline(stdin)
                println()
                push!(circuit.components, Component(i, edge_info.edges[i][1], edge_info.edges[i][2], component_details))
                break
            elseif decision == "n"
                break
            else
                println("Invalid choice. Please choose y (yes), n (no).")
            end
        end
    end
end
