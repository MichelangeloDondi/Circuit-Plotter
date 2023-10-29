# ==============================================================================
# ==============================================================================
# =========================== Module: GatheringNodes ===========================
# ==============================================================================
# ==============================================================================

"""
    Module: GatheringNodes

Dedicated to housing the functions for collecting node details from the user.
This module simplifies the main function definition process by providing a single file to call.

# Author: Michelangelo Dondi

# Date: 29-10-2023

# Version: 4.7

# License: MIT License

# Required packages:
    - `LightGraphs`: For graph data structures

# Included modules:
    - `DataStructure`: Provides the data structures used by the Circuit Plotter Program.
    - `HandlingSpecialInput`: Provides auxiliary functions for input handling.
    - `CheckingNodesInput`: Provides auxiliary functions for checking the input of nodes.
    - `ModifyingNodes`: Provides auxiliary functions for modifying the circuit.
    - `DeletingNodes`: Provides auxiliary functions for deleting nodes from the circuit.

# Exported functions:
    - `collect_nodes(circuit, edgeinfo)`: Main function to collect node coordinates from
        the user. The user is prompted to input node coordinates or type 'break' or 'b' 
        to end the node collection. The user can also modify or cancel existing nodes.

# When are the exported functions invoked?
    - Function `collect_nodes(circuit, edgeinfo)` is invoked by function `main(circuit, edge_info)` in module 'MainFunction'.

# Notes:
    - This module is called after the user has been greeted and instructed by `show_initial_greetings` in the main function.
"""
module GatheringNodes

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================

        # Invoke this function to collect the nodes
        export collect_nodes

    # ==============================================================================
    # =========================== Required Packages ================================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

    # ==============================================================================
    # =========================== Included Modules =================================
    # ==============================================================================  

        # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
        include("../data_structure.jl")
        using .DataStructure: Node, EdgeInfo, Circuit # Access the data structures

        # Module 'HandlingSpecialInput' provides auxiliary functions for input handling.
        include("../functions_always_callable/handling_special_input.jl")
        using .HandlingSpecialInput: handle_special_input_break_modify_cancel # Handle the following special input: 'exit', 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel'

        # Module 'CheckingNodesInput' provides auxiliary functions for checking the input of nodes.
        include("helper_functions_collecting_nodes/checking_nodes_input.jl")
        using .CheckingNodesInput: check_if_input_is_valid # Check if the node can be added to the circuit.

        # Module 'ModifyingNodes' provides auxiliary functions for modifying the circuit.
        include("helper_functions_collecting_nodes/modifying_nodes.jl")
        using .ModifyingNodes: modify_existing_node # Modify existing nodes

        # Module 'DeletingNodes' provides auxiliary functions for deleting nodes from the circuit.
        include("helper_functions_collecting_nodes/deleting_nodes.jl")
        using .DeletingNodes: delete_node_from_circuit # Delete existing nodes

    # ==============================================================================
    # ================= Function: collect_nodes(circuit, edgeinfo) =================
    # ==============================================================================
        
        """
            collect_nodes(circuit, edgeinfo)
        
        The main function to collect node coordinates. 
        
        # Parameters:
            - circuit: The primary data structure representing the circuit.
            - edgeinfo: Data structure representing the edges of the circuit.
        
        # Returns:
            - Nothing. Modifies the circuit and edgeinfo in-place.

        # Function logic:
            - Continuously prompt the user for node coordinates until a break command is given.
            - Process the input.
            - If the action is to break, break out of the loop.
            - If the action is to stop collecting nodes, break out of the loop.
            - If the action is to modify existing nodes, modify them.
            - If the action is to cancel existing nodes, delete them.
            - Check if the node can be added to the circuit.
            - Add the node to the circuit.
            - If the node was added, increase the node count and continue to the next iteration.
            - If the input was invalid, continue to the next iteration.

        # Invoked functions:
            - Function '_prompt_for_coordinates(node_count::Int)::String' is invoked by function 
                `collect_nodes(circuit, edgeinfo)` in module 'GatheringNodes':
                    - Print the prompt message.
                    - Return the input string provided by the user.
            - Function '_process_input(input::String, node_count::Int, circuit, edgeinfo)' is 
                invoked by function `collect_nodes(circuit, edgeinfo)` in module 'GatheringNodes':
                    - Process the user input to either add, modify, or delete nodes.

        # When is this function invoked?
            - This function is invoked by function `main(circuit, edge_info)` in module 'MainFunction'.

        # Notes:
            - Function 'collect_nodes_from_cmd' is the primary function for collecting nodes.
            - This function is called after the user has been greeted and instructed by function `show_initial_greetings()`.
        """
        function collect_nodes(circuit, edgeinfo)

            node_count = 0
            
            # Continuously prompt the user for node coordinates until a break command is given
            while true

                # Prompt the user for node coordinates.
                input = _prompt_for_coordinates(node_count)

                # Process the input.
                node_count, action = _process_input(input, node_count, circuit, edgeinfo)

                # If the action is to break, break out of the loop.
                if action == :break
                    break
                end
            end
        end

    # ==============================================================================
    # --------- Function: _prompt_for_coordinates(node_count::Int)::String ---------
    # ==============================================================================

        """
            _prompt_for_coordinates(node_count::Int)::String
        
        Prompt the user for node coordinates or a special command.
        
        # Parameters:
            - node_count::Int: The number of nodes already present in the circuit.
        
        # Returns:
            - The input string provided by the user.
        
        # Function logic:
            - Print the prompt message.
            - Return the input string provided by the user.

        # Invoked functions:
            - Function 'readline()' is invoked by function `_prompt_for_coordinates(node_count::Int)::String` in module 'GatheringNodes':
                - Read the input string provided by the user.

        # When is this function invoked?
            - Function '_prompt_for_coordinates(node_count::Int)::String' is invoked by function `collect_nodes(circuit, edgeinfo)` in module 'GatheringNodes'.

        # Notes:
            - This function is called by `collect_nodes_from_cmd`.
        """
        function _prompt_for_coordinates(node_count::Int)::String

            # Print the prompt message.
            print(""" 
            ===================================================
        
            \033[33mNumber of nodes already present in the Circuit: $node_count.\033[0m
        
            \033[36mProvide the coordinates of the next node (N$(node_count + 1))
            Format: integer x,y (e.g. '1,-2')
            
            Otherwise, you can call a general command (type 'help' or 'h' for more info)
            or one among of the following:
        
            - 'break'  or 'b' to stop collecting nodes.
            - 'modify' or 'm' to modify existing nodes.
            - 'cancel' or 'c' to cancel existing nodes.\033[0m
        
            ===================================================
        
            Coordinates of the next node (N$(node_count + 1)) or other command: """)
        
            return readline()
        end
    
    # ==============================================================================
    # ------------------------ function _process_input ------------------------------
    # ==============================================================================
        
        """
            _process_input(input::String, node_count::Int, circuit, edgeinfo) -> Int, Symbol
        
        Process the user input to either add, modify, or delete nodes.
        
        # Parameters:
            - input: The input string provided by the user.
            - node_count: The number of nodes already present in the circuit.
            - circuit: The primary data structure representing the circuit.
            - edgeinfo: Data structure representing the edges of the circuit.
        
        # Returns:
            - The updated node_count after processing the input.
            - A symbol indicating the action to be taken after processing (:continue, :break).

        # Function logic:
            - Handle special input ('exit', 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel').
            - If the input was handled, continue to the next iteration.
            - If the input was to stop collecting nodes, break out of the loop.
            - If the input was to modify existing nodes, modify them.
            - If the input was to cancel existing nodes, delete them.
            - Check if the node can be added to the circuit.
            - Add the node to the circuit.
            - If the node was added, increase the node count and continue to the next iteration.
            - If the input was invalid, continue to the next iteration.

        # Invoked functions:
            - Function 'handle_special_input_break_modify_cancel(input, circuit, edgeinfo)' is invoked by function 
            `_process_input(input::String, node_count::Int, circuit, edgeinfo)` in module 'GatheringNodes':
                - Handle the following special input: 'exit', 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel'.
            - Function 'check_if_input_is_valid(input, circuit)' is invoked by function 
            `_process_input(input::String, node_count::Int, circuit, edgeinfo)` in module 'GatheringNodes':
                - Check if the node can be added to the circuit.
            - Function '_add_node_to_circuit(input::String, node_count::Int, circuit)' is invoked by function 
            `_process_input(input::String, node_count::Int, circuit, edgeinfo)` in module 'GatheringNodes':
                - Add the node to the circuit.

        # When is this function invoked?
            - Function '_process_input(input::String, node_count::Int, circuit, edgeinfo)' is invoked by function 
            `collect_nodes(circuit, edgeinfo)` in module 'GatheringNodes'.

        # Notes:
            - This function is called by `collect_nodes(circuit, edgeinfo)` in module 'GatheringNodes'.
        """
        function _process_input(input::String, node_count::Int, circuit, edgeinfo)

            # Handle special input ('exit', 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel').
            handle_result = handle_special_input_break_modify_cancel(input, circuit, edgeinfo)

            # If the input was handled, continue to the next iteration.
            if handle_result == :handled
                return node_count, :continue

            # If the input was to stop collecting nodes, break out of the loop.
            elseif handle_result == :break

                # If no nodes were added, print a message and continue to the next iteration.
                if node_count == 0

                    # Provide feedback to the user and continue to the next iteration.
                    println("\n\033[31mYour circuit has no nodes so far.")
                    println("You must add at least one node to the circuit to continue.\033[0m")
                    return node_count, :continue

                # If at least one node was added, break out of the loop.
                else    

                    # Provide feedback to the user and break out of the loop.
                    println("\n\033[33mFinished adding nodes to the circuit.\033[0m")
                    return node_count, :break
                end
            
            # If the input was to modify existing nodes, modify them.
            elseif handle_result == :modify 

                # Modify the existing nodes.
                modify_existing_node(circuit, edgeinfo)
                return node_count, :continue
                
            # If the input was to cancel existing nodes, delete them.
            elseif handle_result == :cancel

                # Delete the nodes and update the node count.
                node_count_decreased_n_times = delete_node_from_circuit(node_count, circuit, edgeinfo)
                return node_count_decreased_n_times, :continue
            
            # Check if the node can be added to the circuit.
            elseif check_if_input_is_valid(input, circuit)

                # Add the node to the circuit.
                _add_node_to_circuit(input, node_count + 1, circuit)
                
                # If the node was added, increase the node count and continue to the next iteration.
                return node_count + 1, :continue
            end        
            
            # If the input was invalid, continue to the next iteration.
            return node_count, :continue
        end

    # ------------------------------------------------------------------------------
    # ------------------------ function _add_node_to_circuit -----------------------
    # ------------------------------------------------------------------------------

        """
            _add_node_to_circuit(idx::Int, circuit) -> nothing

        Adds the node to the circuit.

        # Parameters:
        - idx: The index of the node to add.
        - circuit: The primary data structure representing the circuit, including its nodes and components.
            
        # Returns:
        - nothing
            
        # Notes:
        - This function is called by `process_input`.
        - This function is called after the node has been checked for validity by `_check_if_node_can_be_added`.
        """
        function _add_node_to_circuit(input::String, idx::Int, circuit)

            # Split the input into its x and y coordinates.
            coords = split(input, ",")

            # Paese the coordinates as integers.
            x, y = parse(Int, coords[1]), parse(Int, coords[2])
                
            # Add the node to the circuit if it doesn't already exist.
            push!(circuit.nodes, Main.MainFunction.DataStructure.Node(idx, x, y))
            add_vertex!(circuit.graph)

            # Provide feedback to the user and return true.
            println("\n\033[32mNode N$idx successfully added at position ($x,$y).\033[0m")
        end
    end