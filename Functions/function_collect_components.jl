# This file contains the function collect_components(circuit::Circuit, edge_info::EdgeInfo) which is used to collect the components of the circuit from the user.

# ----------------- Imported Modules -----------------

    # Help functions from help_functions.jl
    using .Help_Functions: show_help

#########################################################
    # Begin of the function collect_components_from_cmd 
#########################################################    

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
                println("Enter your choice (y/n/help/exit):")
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
                elseif decision == "help"
                    show_help() 
                elseif decision == "exit"
                    println("Exiting the program.")
                    exit(0)
                else
                    println("Invalid choice. Please choose y (yes), n (no), help or exit.")
                end
            end
        end
    end

    function components_recap(circuit::Circuit)
        println("---------------------------------------------------")
        println("---------------------------------------------------")
        println()
        println("All components have been successfully added.")
        println("This is the list of the components present in the circuit: ")
        println()
        for i in 1:length(circuit.components)
            print("Component C$i is on edge E$(circuit.components[i].id)(N$(circuit.components[i].start_node)->N$(circuit.components[i].end_node)). ")
            println("C$i details are: \"$(circuit.components[i].details)\".")
        end
        println()
        println("---------------------------------------------------")
        println("---------------------------------------------------")
        println()
        println("Congrants: your circuit has been successfully created!")
        println("It will be displayed on screen in a few moments.")
        println()
        println("---------------------------------------------------")
        println("---------------------------------------------------")
        println()
    end
