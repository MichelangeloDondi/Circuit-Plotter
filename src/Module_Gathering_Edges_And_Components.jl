# ==============================================================================
# ==============================================================================
# ================= Module_Gathering_Edges_And_Components.jl ===================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Edges_And_Components

Author: Michelangelo Dondi
Date: 23-10-2023
Description:
    Dedicated to housing the functions for collecting edge details and component details.
    This module simplifies the main function definition process by providing a single function to call.

Version: 2.8
License: MIT License

Exported functions:
- `gather_edges_and_components(circuit::Circuit, edge_info::EdgeInfo)`: Systematically 
    assembles information about the edges and the components present within the circuit,
    utilizing direct inputs from the user. The accumulated data finds its place within 
    the `circuit` structure. Additionally, a recap of edge particulars and of components
    particulars is presented, followed by the graphical portrayal of the updated circuit.
"""
module Gathering_Edges_And_Components

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================

        # Invoke this function to gather the edges
        export collect_edges_and_components_from_cmd

    # ==============================================================================
    # ========================= Imported Data Structure ============================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit, EdgeInfo, Component

    # ==============================================================================
    # =========================== Required Packages ================================
    # ==============================================================================    

        # For graph data structures
        using LightGraphs
    
    # ==============================================================================
    # =========================== Included Modules =================================
    # ==============================================================================    

        # Module_Auxiliary_Functions_Geometry.jl provides functions for validating user input.
        include("Module_Auxiliary_Functions_Geometry.jl")
        using .Auxiliary_Functions_Geometry: overlapping_edges # Check if the new edge overlaps with existing edges

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_break # Handle special input such as 'help', 'recap', 'draw', 'exit', 'break'
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_yes_no # Handle special input such as 'help', 'recap', 'draw', 'exit' 'yes', 'no'

        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot

    # ==============================================================================
    # --------------- function collect_edges_and_components_from_cmd --------------
    # ==============================================================================
        
        """
            collect_edges_and_components_from_cmd(node_count::Int, circuit::Circuit, edge_info::EdgeInfo) -> nothing  

        Sequentially gathers edge details and component details from the user.

        Parameters:
        - node_count: The number of nodes in the circuit.
        - circuit: The primary structure amalgamating nodes, components, and their illustrative
                 representation within the circuit.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing
        """
        function collect_edges_and_components_from_cmd(circuit::Circuit, edge_info::EdgeInfo)

            # Number of nodes in the circuit.
            node_count = nv(circuit.graph)

            # Initialize the edge count.
            edge_count = 0

            # Start collecting edges and components.
            while true

                # Prompt the user for the next edge.
                println("\n===================================================")
                println("\nNumber of edges already present in the Circuit: $edge_count.")
                println("\nProvide the node indexes for the next edge (E$(edge_count + 1)) or type 'break' or 'b' to stop adding edges.")
                println("Format: i,j (Direction: Ni->Nj)")
                
                # Read the input from the user.
                input = readline()

                # Handle special input (e.g. 'help', 'recap', 'draw', 'exit', 'save', 'break').
                handle_result = handle_special_input_break(input, circuit, edge_info)

                # If the input was handled, continue to the next iteration.
                if handle_result == :handled
                    continue

                # If the input was to stop collecting edges, break out of the loop.
                elseif handle_result == :break

                    # Provide feedback to the user.
                    println("\nFinished adding edges to the circuit.")
                    break
                end

                # Split the input into the node indices.
                edge_nodes = split(input, ",")

                # Check if the input is valid.
                if length(edge_nodes) != 2

                    # Print an error message and continue to the next iteration.
                    println("\nInvalid input. Provide two node indices separated by a comma.")
                    continue
                end

                # Try adding the edge to the circuit.
                try

                    # Parse the node indices.
                    node1, node2 = parse(Int, edge_nodes[1]), parse(Int, edge_nodes[2])

                    # Check if the edge already exists.
                    if _edge_exists(node1, node2, edge_info)
                        continue

                    # Check if the edge tries to connect a node to itself.
                    elseif node1 == node2
                        println("\nThe edge cannot be added for the following reason:")
                        println("Self-loops are not allowed.")
                        continue
                    end

                    # Check if the edge tries to connect a node to a non-existent node.
                    if node1 < 1 || node1 > node_count || node2 < 1 || node2 > node_count
                        println("\nThe edge cannot be added for the following reason:")
                        println("Invalid node indices. Range: [1, $node_count].")
                        continue
                    end

                    # Check if the edge overlaps with existing edges
                    overlapping = overlapping_edges((node1, node2), edge_info.edges, circuit.nodes)
                    
                    # If the edge overlaps with existing edges, print the overlapping edges and continue to the next iteration.
                    if !isempty(overlapping)
                        overlaps_str = join(["E$(index)(N$(edge[1])->N$(edge[2]))" for (index, edge) in overlapping], ", ")
                        println("\nThe edge cannot be added for the following reason:")
                        println("Overlap detected with: $overlaps_str.")
                        continue
                    end

                    # Add the edge to the circuit.
                    push!(edge_info.edges, (node1, node2))
                    add_edge!(circuit.graph, node1, node2)

                    # Increase the edge count.
                    edge_count += 1

                    # Print a confirmation message.
                    println("\nEdge E$edge_count: N$node1 -> N$node2 added.")
                    
                    # Collect component for the edge if the edge is not a dummy edge.
                    collect_component_from_cmd(edge_count, circuit, edge_info)

                # Catch any errors.
                catch e
                    println("\nError: ", e)
                end
            end
        end
    
    # ==============================================================================
    # ---------------------- function collect_component_from_cmd -------------------
    # ==============================================================================

        function collect_component_from_cmd(edge_count::Int, circuit::Circuit, edge_info::EdgeInfo)

            # Start collecting components for the edge.
            while true 

                # Ask the user if they want to add a component to the edge
                println("\nDo you want to add a component to edge E$edge_count? Answer typing 'yes'/'y' or 'no'/'n'.")
                
                # Read the input from the user.
                input = readline()

                # Handle special input (e.g. 'help', 'draw', 'exit', 'stop').
                handle_result = handle_special_input_yes_no(input, circuit, edge_info)

                # If the input was handled, continue to the next iteration.
                if handle_result == :handled
                    continue

                # If the input was to not add a component, break out of the loop.
                elseif handle_result == :no
                    break

                # If the input was to add a component, prompt the user for the component details.
                elseif handle_result  == :yes

                    # Prompt the user for the component details.
                    println("\nProvide component details (e.g. 'R1 = 10 [Ω]'):")

                    # Read the input from the user.
                    component_details = readline()

                    # Add the component to the circuit 
                    push!(circuit.components, Main.Component(edge_count, edge_info.edges[edge_count][1], edge_info.edges[edge_count][2], component_details))

                    # Print a confirmation message.
                    println("\nComponent \"$component_details\" added to edge E$edge_count.")  
                    break
                    
                # If the input was not handled, print an error message and continue to the next iteration.
                else
                    println("\nInvalid input. Answer typing 'yes'/'y' or 'no'/'n'.")
                end
            end
        end

    # -------------------------------------------------------------------------------
    # -------------------------------- _edge_exists ---------------------------------
    # -------------------------------------------------------------------------------

        """
            _edge_exists(node1::Int, node2::Int, edge_info::EdgeInfo) -> Bool

        Checks if an edge already exists between two nodes.

        Parameters:
        - node1: The index of the first node.
        - node2: The index of the second node.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - true: if the edge already exists
        - false: otherwise
        """
        function _edge_exists(node1::Int, node2::Int, edge_info::EdgeInfo)::Bool
            for (index, existing_edge) in enumerate(edge_info.edges)

                # Check if the edge already exists
                if (node1, node2) == existing_edge
                    println("\nThe edge cannot be added for the following reason:")
                    println("Edge between nodes N$node1 and N$node2 already exists as E$index(N$node1->N$node2).")

                    # Return true to indicate that the edge already exists
                    return true
                    break
                    
                # Check if the edge already exists in the opposite direction
                elseif (node2, node1) == existing_edge
                    println("\nThe edge cannot be added for the following reason:")
                    println("Edge between nodes N$node1 and N$node2 already exists as E$index(N$node2->N$node1).")

                    # Return true to indicate that the edge already exists
                    return true
                    break
                end
            end

            # Return false to indicate that the edge does not already exist
            return false
        end
end