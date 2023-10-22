# ==============================================================================
# ==============================================================================
# ================= Module_Gathering_Edges_And_Components.jl ===================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Edges_And_Components

Author: Michelangelo Dondi
Date: 21-10-2023
Description:
    Dedicated to housing the functions for collecting edge details and component details.
    This module simplifies the main function definition process by providing a single function to call.

Version: 2.7
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
        export gather_edges_and_components

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

        # Module_Helping.jl provides helper functions for the main program.
        include("Module_Helping.jl")
        using .Helping: show_help # Help and instructions

        # Module_Auxiliary_Functions_Geometry.jl provides functions for validating user input.
        include("Module_Auxiliary_Functions_Geometry.jl")
        using .Auxiliary_Functions_Geometry: overlapping_edges # Check if the new edge overlaps with existing edges

        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_stop # Handle special input such as 'help', 'draw', 'exit', 'stop'
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_yn # Handle special input such as 'help', 'draw', 'exit', 'stop', 'y', 'n'
        
    # ==============================================================================
    # ======================== function gather_edges ===============================
    # ==============================================================================

        """
            gather_edges(circuit::Circuit, edge_info::EdgeInfo) -> nothing

        Systematically assembles information about the edges or connections present 
        within the circuit, utilizing direct inputs from the user. The accumulated 
        data finds its place within the `edge_info` structure. Additionally, a recap 
        of edge particulars is presented.

        Parameters:
        - circuit: The nucleus structure, encapsulating nodes, components, and their 
                pictorial representation in the circuit.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing
        """
        function gather_edges_and_components(circuit::Circuit, edge_info::EdgeInfo)
            _collect_edges_and_components_from_cmd(length(circuit.nodes), circuit, edge_info)
            _edges_recap(edge_info)
            _components_recap(circuit)
        end

    # ==============================================================================
    # --------------- function _collect_edges_and_components_from_cmd --------------
    # ==============================================================================
        
        """
            _collect_edges_and_components_from_cmd(node_count::Int, circuit::Circuit, edge_info::EdgeInfo) -> nothing  

        Sequentially gathers edge details and component details from the user.

        Parameters:
        - node_count: The number of nodes in the circuit.
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing
        """
        function _collect_edges_and_components_from_cmd(node_count::Int, circuit::Circuit, edge_info::EdgeInfo)
            
            # Initialize the edge count.
            edge_count = 0

            # Start collecting edges and components.
            while true

                # Prompt the user for the next edge.
                println("\n===================================================")
                println("\nNumber of edges already present in the Circuit: $edge_count.")
                println("\nType 'stop' to stop adding edges or provide the node indexes for the next edge (E$(edge_count + 1)).")
                println("Format: i,j (Direction: Ni->Nj)")
                
                # Read the input from the user.
                input = readline()

                # Handle special input (e.g. 'help', 'draw', 'exit', 'stop').
                handle_result = handle_special_input_stop(input, circuit)

                # If the input was handled, continue to the next iteration.
                if handle_result == :handled
                    continue

                # If the input was to stop collecting nodes, break out of the loop.
                elseif handle_result == :stop
                    break
                end

                # Split the input into the node indices.
                edge_nodes = split(input, ",")

                # Check if the input is valid.
                if length(edge_nodes) != 2
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

                    # Start collecting components for the edge.
                    while true 

                        # Ask the user if they want to add a component to the edge
                        println("\nDo you want to add component to edge E$edge_count? (y/n)")
                        
                        # Read the input from the user.
                        input = readline()

                        # Handle special input (e.g. 'help', 'draw', 'exit', 'stop').
                        handle_result = handle_special_input_yn(input, circuit)

                        # If the input was handled, continue to the next iteration.
                        if handle_result == :handled
                            continue

                        # If the input was to stop collecting nodes, break out of the loop.
                        elseif handle_result == :not_handle
                            break

                        # If the input was to add a component, prompt the user for the component details.
                        elseif handle_result  == "y"

                            # Prompt the user for the component details.
                            println("Provide component details (e.g. 'R1 = 10 [Ω]'):")
                            component_details = readline()

                            # Add the component to the circuit 
                            push!(circuit.components, Main.Component(edge_count, edge_info.edges[edge_count][1], edge_info.edges[edge_count][2], component_details))

                            # Print a confirmation message.
                            println("\nComponent \"$component_details\" added to edge E$edge_count.")  
                            break
                        end
                    end

                # Catch any errors.
                catch e
                    println("\nError: ", e)
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
                    return true
                    break
                    
                # Check if the edge already exists in the opposite direction
                elseif (node2, node1) == existing_edge
                    println("\nThe edge cannot be added for the following reason:")
                    println("Edge between nodes N$node1 and N$node2 already exists as E$index(N$node2->N$node1).")
                    return true
                    break
                end
            end
            return false
        end

    # ==============================================================================
    # --------------------------- function _edges_recap ----------------------------
    # ==============================================================================

        """
            _edges_recap(edge_info::EdgeInfo) -> nothing

        Displays a recap of the edges in the circuit.

        Parameters:
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing

        Notes:
        - The edges are displayed in the format Ei: Nj -> Nk, where i is the edge index, 
                j is the index of the first node, and k is the index of the second node.
        
        Example: 

        Edges in the Circuit:

            - E1: N1 -> N2
            - E2: N2 -> N3
            - E3: N3 -> N4
            - E4: N4 -> N1

        ===================================================
        """ 
        function _edges_recap(edge_info::EdgeInfo)
            println("\nEdges in the Circuit:\n")
            for i in 1:length(edge_info.edges)
                println("   - E$i: N$(edge_info.edges[i][1]) -> N$(edge_info.edges[i][2])")
            end
            println("\n===================================================")
        end
    
    # ==============================================================================
    # -------------------------- function _component_recap -------------------------
    # ==============================================================================
        
        """
            _components_recap(circuit::Circuit) -> nothing

        Displays a recap of the components in the circuit.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.

        Returns:
        - nothing

        Notes:
        - The recap is displayed in the console in the following format:
                - "Component details" on edge Ei (Nj -> Nk), where i is the edge index, 
                j is the index of the first node, and k is the index of the second node.

        Example:

        Components in the Circuit:

            - "R1 = 10 [Ω]" on edge E1 (N1 -> N2)
            - "R2 = 20 [Ω]" on edge E2 (N2 -> N3)
            - "R3 = 30 [Ω]" on edge E3 (N3 -> N4)
            - "R4 = 40 [Ω]" on edge E4 (N4 -> N1)

        ===================================================
        """
        function _components_recap(circuit::Circuit)
            println("\nComponents in the Circuit:\n")
            for comp in circuit.components
                println("   - \"$(comp.details)\" on edge  E$(comp.id) (N$(comp.start_node) -> N$(comp.end_node))")
            end
            println("\n===================================================")
        end
end