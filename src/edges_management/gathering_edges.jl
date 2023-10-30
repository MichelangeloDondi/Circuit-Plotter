# ==============================================================================
# ==============================================================================
# =========================== Module: GatheringEdges ===========================
# ==============================================================================
# ==============================================================================

"""
    Module: GatheringEdges

Dedicated to housing the functions for collecting edge details.
This module simplifies the main function definition process by providing a single function to call.
    
# Author: Michelangelo Dondi

# Date: 30-10-2023

# Version: 4.8

# License: MIT License

# Required packages:
    - `LightGraphs`: For graph data structures

# Included modules:
    - `DataStructure`: For housing the data structures used by the Circuit Plotter Program
    - `OverlappingCheck`: For providing functions for checking if an edge overlaps with existing edges
    - `HandlingSpecialInput`: For providing auxiliary functions for input handling

# Exported functions:
    - `gather_edges(circuit, edge_info)`: Systematically assembles information about 
        the edges present within the circuit, utilizing direct inputs from the user. 
        The accumulated data finds its place within the `circuit` structure. 

# When is the exported function invoked?
    - Function `gather_edges(circuit, edge_info)` is invoked by the function `main(circuit, edge_info)` in module 'MainFunction'.

# Notes:
    - Function `gather_edges(circuit, edge_info)` is the primary function for collecting edge details.
"""
module GatheringEdges

    # ==============================================================================
    # ============================= Exported Function ==============================
    # ==============================================================================

        # Invoke this function to gather the edges
        export collect_edges

    # ==============================================================================
    # ============================== Required Packages =============================
    # ==============================================================================    

        # For graph data structures
        using LightGraphs
    
    # ==============================================================================
    # ============================== Included Modules ==============================
    # ==============================================================================    

        # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
        include("../data_structure.jl")
        using .DataStructure: EdgeInfo, Component, Circuit # Access the data structures

        # Module 'OverlappingCheck' provides functions for checking if an edge overlaps with existing edges.
        include("helper_functions_collecting_edges/overlapping_check.jl")
        using .OverlappingCheck: overlapping_edges # Check if the new edge overlaps with existing edges

        # Module 'HandlingSpecialInput' provides auxiliary functions for input handling.
        include("../functions_always_callable/handling_special_input.jl")
        using .HandlingSpecialInput: handle_special_input_break # Handle the following special input: 'exit', 'help', 'recap', 'draw', 'save', 'break'
        using .HandlingSpecialInput: handle_special_input_yes_no # Handle the following special input: 'exit', 'help', 'recap', 'draw', 'save', 'yes', 'no'
        
    # ==============================================================================
    # ================= Function: collect_edges(circuit, edge_info) ================
    # ==============================================================================

        """
            collect_edges(circuit, edge_info)

        Sequentially gathers edge details from the user.

        # Parameters:
            - circuit: The primary structure amalgamating nodes, components, and their illustrative
                representation within the circuit.
            - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        #Returns:
            - nothing

        # Function logic:
            - Number of nodes in the circuit.
            - Initialize the edge count.
            - Start collecting edges and components.
            - Prompt the user for the next edge.
            - Handle special input ('help', 'recap', 'draw', 'exit', 'save', 'break').
            - Split the input into the node indices.
            - Check if the input is valid.
            - Parse the node indices.
            - Try adding the edge to the circuit.
            - If the edge was added successfully, prompt the user for the component details.
            - Handle special input ('help', 'recap', 'draw', 'exit', 'stop').
            - If the input was to not add a component, break out of the loop.
            - If the input was to add a component, prompt the user for the component details.
            - Add the component to the circuit.
            - Print a confirmation message. 

        # Invoked functions:
            - `_get_edge_input(edge_count::Int)::String`: 
                Prompt the user for the next edge.
            - `_validate_edge_input(edge_nodes::Vector{String}, node_count::Int, edge_info, circuit)::Bool`: 
                Validate user-provided input for defining an edge in the circuit.
            - `_add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit)::Bool`: 
                Add an edge between two nodes in the circuit.
            - `_collect_component_from_cmd(edge_count::Int, circuit, edge_info)`: 
                Sequentially gathers component details from the user.
            - `handle_special_input_break(input, circuit, edge_info)`: 
                Handle special input ('help', 'recap', 'draw', 'exit', 'save', 'break').
            - `handle_special_input_yes_no(input, circuit, edge_info)`: 
                Handle special input ('help', 'recap', 'draw', 'exit', 'yes', 'no').      
        
        # When is the function invoked?
            - The function is invoked by the function `main(circuit, edge_info)` in module 'MainFunction'.

        # Notes:  
            - The function aims to achieve the following: 
                1.  Prompt the user for the next edge.
                2.  Handle special input ('help', 'recap', 'draw', 'exit', 'save', 'break').
                3.  Split the input into the node indices.
                4.  Validate the input.  
                5.  Parse the node indices.
                6.  Try adding the edge to the circuit.
                7.  If the edge was added successfully, prompt the user for the component details.
                8.  Handle special input ('help', 'recap', 'draw', 'exit', 'break').
                9.  If the input was to not add a component, break out of the loop.
                10. If the input was to add a component, prompt the user for the component details.
                11. Add the component to the circuit.
                12. Print a confirmation message.    
        """
        function collect_edges(circuit, edge_info)

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
                        _collect_component(edge_count, circuit, edge_info)
                    end
                end
            end
        end

    # ==============================================================================
    # ------------- Function: _get_edge_input(edge_count::Int)::String -------------
    # ==============================================================================

        """
            _get_edge_input(edge_count::Int)::String

        Prompt the user for the next edge.

        # Parameters:
            - edge_count::Int: The number of edges in the circuit.
            
        # Returns:
            - The user's input as a string.

        # Function logic:
            - Print the number of edges already present in the Circuit.
            - Prompt the user for the next edge (E(edge_count + 1)) or type 'break' or 'b' to stop adding edges.
            - Return the user's input as a string.

        # Invoked functions:
            - `readline()`: Read the user's input.
            
        # When is the function invoked?
            - The function is invoked by the function `collect_edges(circuit, edge_info)` in module 'GatheringEdges'.

        # Notes:
            - The function aims to achieve the following:
                1. Print the number of edges already present in the Circuit.
                2. Prompt the user for the next edge (E(edge_count + 1)) or type 'break' or 'b' to stop adding edges.
                3. Return the user's input as a string.
        """
        function _get_edge_input(edge_count::Int)::String
            print("""\n===================================================
            \033[33m
            Number of edges already present in the Circuit: $edge_count.
            \033[36m
            Provide the node indexes for the next edge (E$(edge_count + 1)) or type 'break' or 'b' to stop adding edges.
            Format: i,j (Direction: Ni->Nj) \033[0m""")
            return readline()
        end

    # ==============================================================================
    # --- Function: _validate_edge_input(edge_nodes::Vector{SubString{String}}, node_count::Int, edge_info, circuit)::Bool ---
    # ==============================================================================

        """
            _validate_edge_input(edge_nodes::Vector{String}, node_count::Int, edge_info, circuit)::Bool

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

        # Function logic:
            - Ensure there are only two nodes in the input.
            - Parse the node indices and ensure they are valid integers.
            - Return true if the input is valid.

        # Invoked functions:
            - `parse(Int, edge_nodes[1])` from module 'GatheringEdges':
                - Parse the first node index.
            - `parse(Int, edge_nodes[2])` from module 'GatheringEdges':
                - Parse the second node index.

        # When is the function invoked?
            - The function is invoked by the function `collect_edges(circuit, edge_info)` in module 'GatheringEdges'.

        # Notes:
            - The function calls the following functions:
                - `parse(Int, edge_nodes[1])`: Parse the first node index.
                - `parse(Int, edge_nodes[2])`: Parse the second node index.
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
    # --- Function: add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit)::Bool ---
    # ==============================================================================

        """
            add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit)::Bool

        Add an edge between two nodes in the circuit and update the relevant data structures.

        # Parameters:
            - `node1`: The starting node of the edge (as an integer).
            - `node2`: The ending node of the edge (as an integer).
            - `edge_info`: A data structure containing information about the circuit's edges.
            - `circuit`: The primary data structure representing the circuit's nodes and components.

        # Returns:
            - `true` if the edge is successfully added to the circuit.
            - `false` otherwise, indicating that the edge could not be added.

        # Function logic:
            - Number of nodes in the circuit.
            - Check if the edge already exists.
            - Check if the edge tries to connect a node to itself.
            - Check if the edge tries to connect a node to a non-existent node.
            - Check if the edge overlaps with existing edges.
            - Add the edge to the circuit.
            - Return true to indicate that the edge was successfully added.

        # Invoked functions:
            - `overlapping_edges((node1, node2), edge_info.edges, circuit.nodes)` from module 'OverlappingCheck':
                - Check if the new edge overlaps with existing edges.

        # When is this function invoked?    
            - The function is invoked by the function `collect_edges(circuit, edge_info)` in module 'GatheringEdges'.

        # Notes:
            - The function aims to achieve the following:
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
    # ----- Function: _collect_component(edge_count::Int, circuit, edge_info) ------
    # ==============================================================================

        """
            _collect_component(edge_count::Int, circuit, edge_info) -> nothing

        Sequentially gathers component details from the user.

        # Parameters:
            - edge_count: The number of edges in the circuit.
            - circuit: The primary structure amalgamating nodes, components, and their illustrative
                 representation within the circuit.
            - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        # Returns:
            - nothing

        # Function logic:
            - Start collecting components for the edge.
            - Ask the user if they want to add a component to the edge.
            - Read the input from the user.
            - Handle special input (e.g. 'help', 'draw', 'exit', 'stop').
            - If the input was handled, continue to the next iteration.
            - If the input was to not add a component, break out of the loop.
            - If the input was to add a component, prompt the user for the component details.
            - Read the input from the user.
            - Add the component to the circuit.
            - Print a confirmation message.

        # Invoked functions:
            - `handle_special_input_yes_no(input, circuit, edge_info)`: Handle special input ('help', 'recap', 
                'draw', 'exit', 'yes', 'no').

        # When is the function invoked?
            - The function is invoked by the function `collect_edges(circuit, edge_info)` in module 'GatheringEdges'.

        # Notes:
            - Function `collect_edges(circuit, edge_info)` is the primary function for collecting component details.
        """
        function _collect_component(edge_count::Int, circuit, edge_info)

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
                    push!(circuit.components, Main.MainFunction.DataStructure.Component(edge_count, edge_info.edges[edge_count][1], edge_info.edges[edge_count][2], component_details))

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
    # ------------ _edge_exists(node1::Int, node2::Int, edge_info)::Bool ------------
    # -------------------------------------------------------------------------------

        """
            _edge_exists(node1::Int, node2::Int, edge_info)::Bool

        Checks if an edge already exists between two nodes.

        # Parameters:
            - node1: The index of the first node.
            - node2: The index of the second node.
            - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        # Returns:
            - true: if the edge already exists
            - false: otherwise

        # Function logic:
            - For each edge in the circuit:
                - Check if the edge already exists.
                - Check if the edge already exists in the opposite direction.
            - Return false to indicate that the edge does not already exist.

        # Invoked functions:    
            - `add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit)::Bool` from module 'GatheringEdges':
                - Add an edge between two nodes in the circuit and update the relevant data structures.

        # When is the function invoked?
            - The function is invoked by the function `add_edge_to_circuit(node1::Int, node2::Int, edge_info, circuit)::Bool` 
                in module 'GatheringEdges'.

        # Notes:
            - The function aims to achieve the following:
                1. Check if the edge already exists.
                2. Check if the edge already exists in the opposite direction.
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