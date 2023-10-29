# ==============================================================================
# ==============================================================================
# =========================== Module: ModifyingNodes ===========================
# ==============================================================================
# ==============================================================================

"""
    Module: ModifyingNodes

This module provides functions for modifying an existing node's coordinates in the circuit.

# Author: Michelangelo Dondi

# Date: 29-10-2023

# Version: 4.7

# License: MIT License

# Required packages:
    - 'LightGraphs' for graph data structures

# Included modules:
    - 'DataStructure' provides the data structures used by the Circuit Plotter Program.
    - 'CircuitRecap' provides auxiliary functions for recapping the circuit.
    - 'HandlingSpecialInput' provides auxiliary functions for input handling.
    - 'CheckingNodesInput' provides auxiliary functions for checking the input of nodes.

# Exported functions: 
    - `modify_existing_node(circuit)`: Modifies an existing nodes's coordinates in the circuit based on user input.

# When exported functions are invoked?
    - Function `modify_existing_node(circuit)` is invoked by the function `collect_nodes(circuit, edgeinfo)` in module 'GatheringNodes'.

# Notes:
    - Function `modify_existing_node(circuit)` is the primary driver for user interaction when modifying nodes. 
"""
module ModifyingNodes

    # ==============================================================================
    # =========================== Exported Functions ===============================
    # ==============================================================================

        # Invokes the modify_existing_node function to modify an existing node's coordinates in the circuit.
        export modify_existing_node

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

    # ==============================================================================
    # ============================ Included Modules ================================
    # ==============================================================================

        # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
        include("../../data_structure.jl")
        using .DataStructure: EdgeInfo, Circuit # Access the data structures

        # Module 'CircuitRecap' provides auxiliary functions for recapping the circuit.
        include("../../functions_always_callable/circuit_recap.jl")
        using .CircuitRecap: show_nodes_recap # Recap the circuit    

        # Module 'HandlingSpecialInput' provides auxiliary functions for input handling.
        include("../../functions_always_callable/handling_special_input.jl")
        using .HandlingSpecialInput: handle_special_input_break # Handle special input ('help', 'recap', 'draw', 'exit', 'break')

        # Module 'CheckingNodesInput' provides auxiliary functions for checking the input of nodes.
        include("checking_nodes_input.jl")
        using .CheckingNodesInput: check_if_input_is_valid # Check if the node can be added to the circuit.
        
    # ==============================================================================
    # ============== Function: modify_existing_node(circuit, edgeinfo) =============
    # ==============================================================================

        """
            modify_existing_node(circuit, edgeinfo)

        Allows the user to modify an existing node's coordinates in the circuit based on input.

        # Parameters:
            - circuit: The primary data structure representing the circuit's nodes and components.
            - edgeinfo: Additional information about the edges of the circuit.

        # Returns:
            - nothing

        # Function Logic:
            - Keep prompting the user until they decide to exit.
            - Display instructions for the user.
            - Process the user's input.
            - If the user wants to stop modifying, break the loop.
            - If the user wants to modify a node, prompt them for the ID of the node they wish to modify.

        # Invoked functions:
            - Function `_prompt_modify_node_instructions(circuit)::String` from module 'ModifyingNodes': 
                prompts the user for the ID of the node they wish to modify.
            - Function `_process_user_input(input::String, circuit, edgeinfo)::Symbol` from module 'ModifyingNodes': 
                processes the user's input when modifying a node's coordinates.
            - Function `_parse_input_as_integer(input::String, circuit)` from module 'ModifyingNodes':
                parses the user's input as an integer and modifies the node's coordinates.
            - Function `_get_node_by_id(node_id::Int, circuit)::Node` from module 'ModifyingNodes':
                retrieves a specific node from the circuit using its ID.
            - Function `_update_node_coordinates(node, x::Int, y::Int)` from module 'ModifyingNodes':
                updates the x and y coordinates of a given node.

        # When is this function invoked?
            - This function is invoked by the function `collect_nodes(circuit, edgeinfo)` in module 'GatheringNodes'.

        # Notes:
            - This function is the primary driver for user interaction when modifying nodes.
        """
        function modify_existing_node(circuit, edgeinfo)

            # Keep prompting the user until they decide to exit.
            while true

                # Display instructions for the user.
                input = _prompt_modify_node_instructions(circuit) 

                # Process the user's input.
                action = _process_user_input(input, circuit, edgeinfo)

                # If the user wants to stop modifying, break the loop.
                if action == :break
                    break
                end    
            end
        end

    # ==============================================================================
    # --------- Function: _prompt_modify_node_instructions(circuit)::String --------
    # ==============================================================================

        """
            _prompt_modify_node_instructions(circuit)::String

        Prompts the user for the ID of the node they wish to modify.

        # Parameters:
            - circuit: The primary data structure representing the circuit's nodes and components.
            
        # Returns:
            - The user's input as a string.
            
        # Function logic:
            - Display the instructions for the user.
            - Show the current state of the circuit to aid user decision.
            - Ask the user for the ID of the node they wish to modify.
            - Return the user's input.

        # Invoked functions:
            - Function `show_nodes_recap(circuit)` from module 'CircuitRecap': 
                shows the current state of the circuit to aid user decision.
            
        # When is this function invoked?
            - This function is invoked by the function `modify_existing_node(circuit)` in module 'ModifyingNodes'.    

        # Notes:
            - This function is used by the function 'modify_existing_node(circuit, edgeinfo)' to prompt the user 
                for the ID of the node they wish to modify.
        """
        function _prompt_modify_node_instructions(circuit)::String

            # Display the instructions for the user.
            println("""
            \033[36m
            You can modify the coordinates of an existing node by typing its ID and providing the new coordinates.

            Here there is a recap of the nodes in the circuit for your convenience:\033[0m""")

            # Show the current state of the circuit to aid user decision.
            show_nodes_recap(circuit)

            # Ask the user for the ID of the node they wish to modify.
            print("\n\033[36mEnter the ID (e.g. '2') of the node you want to modify or type 'break' or 'b' to finish modifying nodes: \033[0m")
            
            # Return the user's input.
            return readline()
        end

    # ==============================================================================
    # --- Function: _process_user_input(input::String, circuit, edgeinfo)::Symbol ---
    # ==============================================================================

        """
            _process_user_input(input::String, circuit, edgeinfo)::Symbol

        Processes the user's input when modifying a node's coordinates.

        # Parameters: 
            - input: The user's input.
            - circuit: The primary data structure representing the circuit's nodes and components.
            - edgeinfo: Additional information about the edges of the circuit.

        # Returns:
            - :continue if the user's input was processed successfully and the program should continue.
            - :break if the user's input was processed successfully and the program should break out of the loop.

        # Function logic:
            - Check if the user entered special commands.
            - If the command was handled (e.g., exit, recap), continue to the next iteration.
            - If the user wants to stop modifying, break the loop.
            - Try to parse the user's input as an integer.
            - Handle potential errors (e.g., invalid input format).
            - Inform the user of the error and continue to the next iteration.
            - Parse the user's input as an integer.
            - Get the node with the given ID.
            - If no such node exists, inform the user.
            - Ask the user for the new coordinates.
            - Get the user's input.
            - Check if the new coordinates are valid.
            - Split the input into its x and y coordinates.
            - Parse the coordinates as integers.
            - Update the node's coordinates with the new values.
            - Confirm to the user that the node's coordinates were successfully modified.
            - Return :continue to continue the loop.

        # Invoked functions:
            - Function `handle_special_input_break(input, circuit, edgeinfo)` from module 'HandlingSpecialInput': 
                checks if the user entered special commands.
            - Function `_parse_input_as_integer(input::String, circuit)` from module 'ModifyingNodes':
                parses the user's input as an integer and modifies the node's coordinates.
            - Function `_get_node_by_id(node_id::Int, circuit)::Node` from module 'ModifyingNodes':
                retrieves a specific node from the circuit using its ID.
            - Function `_update_node_coordinates(node, x::Int, y::Int)` from module 'ModifyingNodes':
                updates the x and y coordinates of a given node.

        # When is this function invoked?
            - This function is invoked by the function `modify_existing_node(circuit, edgeinfo)` in module 'ModifyingNodes'.

        # Notes:
            - The function is used by the modify_existing_node function to process the user's input when modifying a node's coordinates.
            - This function is the primary driver for user interaction when modifying nodes.
            It leverages the other helper functions to simplify its logic.
        """
        function _process_user_input(input::String, circuit, edgeinfo)::Symbol

            # Check if the user entered special commands.
            handle_result = handle_special_input_break(input, circuit, edgeinfo)

            # If the command was handled (e.g., exit, recap), continue to the next iteration.
            if handle_result == :handled
                return :continue

            # If the user wants to stop modifying, break the loop.
            elseif handle_result == :break
                println("\n\033[32mFinished modifying nodes.\033[0m")
                return :break
            end
            
            # Try to parse the user's input as an integer.
            try

                # Parse the user's input as an integer.
                _parse_input_as_integer(input, circuit)
                return :continue

            # Handle potential errors (e.g., invalid input format).
            catch e

                # Inform the user of the error and continue to the next iteration.
                println("\n\033[31mInvalid input: $e. Please try again with a valid input.\033[0m")
                return :continue
            end
        end
        
    # ------------------------------------------------------------------------------
    # --------- Function: _parse_input_as_integer(input::String, circuit) ----------
    # ------------------------------------------------------------------------------

        """
            _parse_input_as_integer(input::String, circuit)
        
        Parses the user's input as an integer and modifies the node's coordinates.

        # Parameters:
            - input: The user's input.
            - circuit: The primary data structure representing the circuit's nodes and components.

        # Returns:
            - :continue if the user's input was processed successfully and the program should continue.

        # Function logic:
            - Convert the user's input to an integer to retrieve the node ID.
            - Get the node with the given ID.
            - If no such node exists, inform the user.
            - Ask the user for the new coordinates.
            - Get the user's input.
            - Check if the new coordinates are valid.
            - Split the input into its x and y coordinates.
            - Parse the coordinates as integers.
            - Update the node's coordinates with the new values.
            - Confirm to the user that the node's coordinates were successfully modified.
            - Return :continue to continue the loop.

        # Invoked functions:
            - Function `_get_node_by_id(node_id::Int, circuit)::Node` from module 'ModifyingNodes':
                retrieves a specific node from the circuit using its ID.
            - Function `_update_node_coordinates(node, x::Int, y::Int)` from module 'ModifyingNodes':
                updates the x and y coordinates of a given node.

        # When is this function invoked?
            - This function is invoked by the function `_process_user_input(input::String, circuit, edgeinfo)::Symbol` in module 'ModifyingNodes'.

        # Notes:
            - The function is used by the process_user_input function to parse the user's input as an integer and modify the node's coordinates.
        """            
        function _parse_input_as_integer(input::String, circuit)

            # Convert the user's input to an integer to retrieve the node ID.
            node_id = parse(Int, input)

            # Get the node with the given ID.
            found_node = _get_node_by_id(node_id, circuit)

            # If no such node exists, inform the user.
            if found_node === nothing
                println("""\n\033[31mNode with ID N$node_id not found. \033[36m
                Please ensure node IDs are integers and the node exists in the circuit.\033[30m""")
                return :continue
            end

            # Ask the user for the new coordinates.
            print("\n\033[36mProvide the new coordinates for node N$node_id in the format 'x,y' (coordinates must be integers): \033[0m")

            # Get the user's input.
            input = readline()

            # Check if the new coordinates are valid.
            if check_if_input_is_valid(input, circuit)

                # Split the input into its x and y coordinates.
                coords = split(input, ",")

                # Parse the coordinates as integers.
                x, y = parse(Int, coords[1]), parse(Int, coords[2])
                
                # Update the node's coordinates with the new values.
                _update_node_coordinates(found_node, x, y)

                # Confirm to the user that the node's coordinates were successfully modified.
                println("\n\033[32mNode N$node_id successfully modified to position ($x,$y). \033[0m")
                return :continue

            end
        end

    # -------------- Function: _get_node_by_id(node_id::Int, circuit) --------------

        """
            _get_node_by_id(node_id::Int, circuit)

        Retrieve a specific node from the circuit using its ID.

        # Parameters:
            - node_id: The unique identifier for the node.
            - circuit: The primary data structure representing the circuit's nodes and components.

        # Returns:
            - The Node with the specified ID or nothing if not found.

        # Function logic:
            - Iterate over all nodes in the circuit.
            - If the current node's ID matches the provided ID, return the node.
            - If no node with the given ID was found, return nothing.

        # Invoked functions:
            - Function `nodes(circuit)` from module 'DataStructure': 
                retrieves all nodes in the circuit.

        # When is this function invoked?
            - This function is invoked by the function `_parse_input_as_integer(input::String, circuit)` in module 'ModifyingNodes'.

        # Notes:
            - It's essential for node IDs to be unique to retrieve the correct node.
        """
        function _get_node_by_id(node_id::Int, circuit)

            # Iterate over all nodes in the circuit.
            for node in circuit.nodes

                # If the current node's ID matches the provided ID, return the node.
                if node.id == node_id
                    return node
                end
            end

            # If no node with the given ID was found, return nothing.
            return nothing
        end

    # ----------- function _update_node_coordinates(node, x::Int, y::Int) ----------
            
        """
            _update_node_coordinates(node, x::Int, y::Int)

        Update the x and y coordinates of a given node.

        # Parameters:
            - node: The node whose coordinates are to be updated.
            - x: The new x-coordinate value.
            - y: The new y-coordinate value.

        # Returns:
            - nothing

        # Function logic:
            - Update the node's coordinates.

        # Invoked functions:
            - none

        # When is this function invoked?
            - This function is invoked by the function `_parse_input_as_integer(input::String, circuit)` in module 'ModifyingNodes'.

        # Notes:
            - Directly modifies the x and y attributes of the node. 
            - The function is used by the process_user_input function to update the x and y coordinates of a given node.
        """
        function _update_node_coordinates(node, x::Int, y::Int)

            # Update the node's coordinates.
            node.x = x
            node.y = y
        end
end
