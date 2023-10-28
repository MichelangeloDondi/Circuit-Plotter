# ==============================================================================
# ==============================================================================
# ================= Module_Gathering_Edges_And_Components.jl ===================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Edges_And_Components

Author: Michelangelo Dondi
Date: 28-10-2023
Description:
    Dedicated to housing the functions for collecting edge details and component details.
    This module simplifies the main function definition process by providing a single function to call.

Version: 4.1
License: MIT License

Exported functions:
- `gather_edges_and_components(circuit, edge_info)`: Systematically 
    assembles information about the edges and the components present within the circuit,
    utilizing direct inputs from the user. The accumulated data finds its place within 
    the `circuit` structure. Additionally, a recap of edge particulars and of components
    particulars is presented, followed by the graphical portrayal of the updated circuit.

Notes:
- The module is included in Module_Main_Function.jl.
- The module requires the following modules to be included:
    - Module_Circuit_Structures.jl
    - Module_Auxiliary_Functions_Geometry.jl
    - Module_Auxiliary_Functions_Handle_Special_Input.jl
    - Module_Gathering_Edges_And_Components.jl
"""
module Gathering_Edges_And_Components

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================

        # Invoke this function to gather the edges
        export collect_edges_and_components_from_cmd

    # ==============================================================================
    # =========================== Required Packages ================================
    # ==============================================================================    

        # For graph data structures
        using LightGraphs
    
    # ==============================================================================
    # =========================== Included Modules =================================
    # ==============================================================================    

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: EdgeInfo, Component, Circuit # Access the data structures

        # Module_Auxiliary_Functions_Geometry.jl provides functions for validating user input.
        include("Module_Auxiliary_Functions_Geometry.jl")
        using .Auxiliary_Functions_Geometry: overlapping_edges # Check if the new edge overlaps with existing edges

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_break # Handle special input such as 'help', 'recap', 'draw', 'exit', 'break'
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_yes_no # Handle special input such as 'help', 'recap', 'draw', 'exit' 'yes', 'no'

    # ==============================================================================
    # =============== function collect_edges_and_components_from_cmd ===============
    # ==============================================================================

        """
            collect_edges_and_components_from_cmd(circuit, edge_info) -> nothing

        Sequentially gathers edge details and component details from the user.
        The function aims to achieve the following: 

            1.  Prompt the user for the next edge.
            2.  Handle special input ('help', 'recap', 'draw', 'exit', 'save', 'break').
            3.  Split the input into the node indices.
            4.  Validate the input.  
            5.  Parse the node indices.
            6.  Try adding the edge to the circuit.
            7.  If the edge was added successfully, prompt the user for the component details.
            8.  Handle special input ('help', 'recap', 'draw', 'exit', 'stop').
            9.  If the input was to not add a component, break out of the loop.
            10. If the input was to add a component, prompt the user for the component details.
            11. Add the component to the circuit.
            12. Print a confirmation message.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their illustrative
                 representation within the circuit.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing

        Notes:  
        The function is called by the main function.
        The function calls the following functions:
        - `_get_edge_input(edge_count::Int)::String`: Prompt the user for the next edge.
        - `_validate_edge_input(edge_nodes::Vector{String}, node_count::Int, edge_info, circuit) -> Bool`: Validate user-provided input for defining an edge in the circuit.
        - `_add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit) -> Bool`: Add an edge between two nodes in the circuit.
        - `_collect_component_from_cmd(edge_count::Int, circuit, edge_info) -> nothing`: Sequentially gathers component details from the user.
        - `handle_special_input_break(input, circuit, edge_info)`: Handle special input ('help', 'recap', 'draw', 'exit', 'save', 'break').
        - `handle_special_input_yes_no(input, circuit, edge_info)`: Handle special input ('help', 'recap', 'draw', 'exit', 'yes', 'no').      
        """
        function collect_edges_and_components_from_cmd(circuit, edge_info)

            # Number of nodes in the circuit.
            node_count = nv(circuit.graph)

            # Initialize the edge count.
            edge_count = 0

            # Start collecting edges and components.
            while true  

                # Prompt the user for the next edge.
                input = _get_edge_input(edge_count)
                    
                # Handle special input ('help', 'recap', 'draw', 'exit', 'save', 'break').
                handle_result = handle_special_input_break(input, circuit, edge_info)

                # If the input was handled, continue to the next iteration.
                if handle_result == :handled
                    continue    

                # If the input was to stop collecting edges, break out of the loop.
                elseif handle_result == :break
                    println("\n\033[32mFinished adding edges and components to the circuit.\033[0m")
                    break
                end

                # Split the input into the node indices.
                edge_nodes = split(input, ",")

                # Check if the input is valid.
                if _validate_edge_input(edge_nodes, node_count, edge_info, circuit)

                    # Parse the node indices.
                    node1, node2 = parse(Int, edge_nodes[1]), parse(Int, edge_nodes[2]) 

                    # Try adding the edge to the circuit.
                    if add_edge_to_circuit(node1, node2, edge_info, circuit)

                        # Update the edge count and print a confirmation message.
                        edge_count += 1
                        println("\n\033[32mEdge E$edge_count: N$node1 -> N$node2 successfully added.\033[0m")

                        # Collect component for the edge if the edge is not a dummy edge.
                        _collect_component_from_cmd(edge_count, circuit, edge_info)
                    end
                end
            end
        end

    # ==============================================================================
    # ------------------------- function _get_edge_input ----------------------------
    # ==============================================================================

        """
            _get_edge_input(edge_count::Int)::String

        Prompt the user for the next edge.

        Parameters:
        - edge_count: The number of edges in the circuit.
            
        Returns:
        - The user's input as a string.
        """
        function _get_edge_input(edge_count::Int)::String
            println("""\n===================================================
            \033[33m
            Number of edges already present in the Circuit: $edge_count.
            \033[36m
            Provide the node indexes for the next edge (E$(edge_count + 1)) or type 'break' or 'b' to stop adding edges.
            Format: i,j (Direction: Ni->Nj) \033[0m
            """)
            return readline()
        end

    # ==============================================================================
    # ------------------------- function _validate_edge_input ----------------------
    # ==============================================================================

        """
            _validate_edge_input(edge_nodes::Vector{String}, node_count::Int, edge_info, circuit) -> Bool

        Validate user-provided input for defining an edge in the circuit.

        # Parameters:

        - `edge_nodes`: A vector containing the two nodes (as strings) defining the edge.
        - `node_count`: The total number of nodes in the circuit.
        - `edge_info`: A data structure containing information about the circuit's edges.
        - `circuit`: The primary data structure representing the circuit's nodes and components.

        # Returns:

        - `true` if the input is valid. However, this does not imply that the edge can be added to the circuit 
            (e.g., it may overlap with existing edges or be a self-loop). This is checked in the `add_edge_to_circuit` function.
        - `false` otherwise, indicating an invalid input

        # Notes:
        The function checks the following:
        - If the input contains exactly two nodes.
        - If the provided node indices are valid integers within the circuit's node range.
        """
        function _validate_edge_input(edge_nodes::Vector{SubString{String}}, node_count::Int, edge_info, circuit)::Bool

            # Ensure there are only two nodes in the input.
            if length(edge_nodes) != 2
                println("\n\033[31mInvalid input.")
                println("\033[36mProvide two node indices separated by a comma (e.g. '3,2').\033[0m")
                return false
            end

            # Parse the node indices and ensure they are valid integers.
            try
                node1, node2 = parse(Int, edge_nodes[1]), parse(Int, edge_nodes[2])
            catch e
                println("\n\033[31mError while parsing node indices: $e\033[0m")
                return false
            end
            
            # Rertun true if the input is valid.
            return true
        end

    # ==============================================================================
    # ------------------------- function add_edge_to_circuit -----------------------
    # ==============================================================================

        """
            add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit) -> Bool

        Add an edge between two nodes in the circuit.

        # Parameters:

        - `node1`: The starting node of the edge (as an integer).
        - `node2`: The ending node of the edge (as an integer).
        - `edge_info`: A data structure containing information about the circuit's edges.
        - `circuit`: The primary data structure representing the circuit's nodes and components.

        # Returns:

        - `true` if the edge is successfully added to the circuit.
        - `false` otherwise, indicating that the edge could not be added.

        # Notes:

        The function aims to achieve the following:

        1. Verify if the edge can be added (e.g., it does not already exist, does npt overlap, is not a self-loop, etc.).
        2. Add the edge to the relevant data structures.
        3. Update any counters or other related data.
        """
        function add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit)::Bool

            # Number of nodes in the circuit.
            node_count = nv(circuit.graph)

            # Check if the edge already exists.
            if _edge_exists(node1, node2, edge_info)
                return false
            end

            # Check if the edge tries to connect a node to itself.
            if node1 == node2
                println("\n\033[31mThe edge cannot be added for the following reason:")
                println("\033[33mSelf-loops are not allowed.\033[0m")
                return false
            end

            # Check if the edge tries to connect a node to a non-existent node.
            if node1 < 1 || node1 > node_count || node2 < 1 || node2 > node_count
                println("\n\033[31mThe edge cannot be added for the following reason:")
                println("\033[33mInvalid node indices. Range: [1, $node_count].\033[0m")
                return false
            end

            # Check if the edge overlaps with existing edges.
            overlapping = overlapping_edges((node1, node2), edge_info.edges, circuit.nodes)
            if !isempty(overlapping)
                overlaps_str = join(["E$(index)(N$(edge[1])->N$(edge[2]))" for (index, edge) in overlapping], ", ")
                println("\n\033[31mThe edge cannot be added for the following reason:")
                println("\033[33mOverlap detected with: $overlaps_str.\033[0m")
                return false
            end

            # Add the edge to the circuit.
            push!(edge_info.edges, (node1, node2))
            add_edge!(circuit.graph, node1, node2)

            # Return true to indicate that the edge was successfully added.
            return true
        end

    # ==============================================================================
    # ---------------------- function _collect_component_from_cmd -------------------
    # ==============================================================================

        """
            _collect_component_from_cmd(edge_count::Int, circuit, edge_info) -> nothing

        Sequentially gathers component details from the user.

        Parameters:
        - edge_count: The number of edges in the circuit.
        - circuit: The primary structure amalgamating nodes, components, and their illustrative
                 representation within the circuit.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing
        """
        function _collect_component_from_cmd(edge_count::Int, circuit, edge_info)

            # Start collecting components for the edge.
            while true 

                # Ask the user if they want to add a component to the edge
                println("\nDo you want to add a component to edge E$edge_count?")
                println("\033[36mAnswer typing 'yes'/'y' or 'no'/'n'.\033[0m")
                
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
                    println("\n\033[36mProvide component details (e.g. 'R1 = 10 [Ω]'):\033[0m")

                    # Read the input from the user.
                    component_details = readline()

                    # Add the component to the circuit 
                    push!(circuit.components, Main.Main_Function.Circuit_Structures.Component(edge_count, edge_info.edges[edge_count][1], edge_info.edges[edge_count][2], component_details))

                    # Print a confirmation message.
                    println("\n\033[32mComponent \"$component_details\" successfully added to edge E$edge_count.\033[0m")  
                    break
                    
                # If the input was not handled, print an error message and continue to the next iteration.
                else
                    println("\n\033[31mInvalid input.")
                    println("\033[36mAnswer typing 'yes'/'y' or 'no'/'n'.\033[0m")
                end
            end
        end

    # -------------------------------------------------------------------------------
    # -------------------------------- _edge_exists ---------------------------------
    # -------------------------------------------------------------------------------

        """
            _edge_exists(node1::Int, node2::Int, edge_info) -> Bool

        Checks if an edge already exists between two nodes.

        Parameters:
        - node1: The index of the first node.
        - node2: The index of the second node.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - true: if the edge already exists
        - false: otherwise
        """
        function _edge_exists(node1::Int, node2::Int, edge_info)::Bool
            for (index, existing_edge) in enumerate(edge_info.edges)

                # Check if the edge already exists
                if (node1, node2) == existing_edge  

                    # Print an error message and return true.
                    println("\n\033[31mThe edge cannot be added for the following reason:")
                    println("\033[33mEdge between nodes N$node1 and N$node2 already exists as E$index(N$node1->N$node2).\033[0m")

                    # Return true to indicate that the edge already exists and break the loop
                    return true
                    break
                    
                # Check if the edge already exists in the opposite direction
                elseif (node2, node1) == existing_edge

                    # Print an error message and return true to indicate that the edge already exists
                    println("\n\033[31mThe edge cannot be added for the following reason:")
                    println("\033[33mEdge between nodes N$node1 and N$node2 already exists as E$index(N$node2->N$node1).\033[0m")

                    # Return true to indicate that the edge already exists and break the loop
                    return true
                    break
                end
            end

            # Return false to indicate that the edge does not already exist
            return false
        end
end