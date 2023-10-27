# ==============================================================================
# ==============================================================================
# ============= Module_Auxiliary_Functions_Circuit_Modifying.jl ================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Circuit_Modifying

Author: Michelangelo Dondi
Date: 27-10-2023
Description: 
    This module provides functions for modifying an existing node's coordinates in 
    the circuit.

Version: 3.5
License: MIT License

Exported functions: 
- `modify_existing_node(circuit)`: Modifies an existing nodes's coordinates in the circuit based on user input.

Notes:
- The module is included in Module_Gathering_Nodes.jl.  
- The module requires the following modules to be included:
    - Module_Circuit_Structures.jl
    - Module_Auxiliary_Functions_Circuit_Recap.jl
    - Module_Auxiliary_Functions_Handle_Special_Input.jl    
"""
module Auxiliary_Functions_Circuit_Modifying

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

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: EdgeInfo, Circuit # Access the data structures

        # Module_Auxiliary_Functions_Circuit_Recap.jl provides auxiliary functions for recapping the circuit.
        include("Module_Auxiliary_Functions_Circuit_Recap.jl")
        using .Auxiliary_Functions_Circuit_Recap: show_circuit_recap # Recap the circuit    

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_break # Handle special input ('help', 'recap', 'draw', 'exit', 'break')

        # Module_Auxiliary_Functions_Checking_Input_Of_Nodes provides auxiliary functions for checking the input of nodes.
        include("Module_Auxiliary_Functions_Checking_Input_Of_Nodes.jl")
        using .Auxiliary_Functions_Checking_Input_Of_Nodes: check_if_input_is_valid # Check if the node can be added to the circuit.
        
    # ==============================================================================
    # ======================== function modify_existing_node =======================
    # ==============================================================================

        """
            modify_existing_node(circuit, edgeinfo)

        Allows the user to modify an existing node's coordinates in the circuit based on input.

        # Parameters:
        - circuit: The primary data structure representing the circuit's nodes and components.
        - edgeinfo: Additional information about the edges of the circuit.

        # Notes:
        - The function is used by the collect_nodes_from_cmd function to modify an existing node's coordinates in the circuit.
        - This function is the primary driver for user interaction when modifying nodes.
        It leverages the other helper functions to simplify its logic.
        """
        function modify_existing_node(circuit, edgeinfo)

            # Keep prompting the user until they decide to exit.
            while true

                # Display instructions for the user.
                input = _prompt_modify_node_instructions(circuit, edgeinfo) 

                # Process the user's input.
                action = _process_user_input(input, circuit, edgeinfo)

                # If the user wants to stop modifying, break the loop.
                if action == :break
                    break
                end    
            end
        end

    # ==============================================================================
    # ------------------ function _prompt_modify_node_instructions -----------------
    # ==============================================================================

        """
            _prompt_modify_node_instructions(circuit, edgeinfo)::String

        Prompts the user for the ID of the node they wish to modify.

        # Parameters:
        - circuit: The primary data structure representing the circuit's nodes and components.
        - edgeinfo: Additional information about the edges of the circuit.
            
        # Returns:
        - The user's input as a string.
            
        # Notes:
        - The function is used by the modify_existing_node function to prompt the user for the ID of the node they wish to modify.
        """
        function _prompt_modify_node_instructions(circuit, edgeinfo)

            # Display the instructions for the user.
            println("""

            You can modify the coordinates of an existing node 
            by typing its ID and providing the new coordinates.

            Here there is a recap of the circuit for your convenience:""")

            # Show the current state of the circuit to aid user decision.
            show_circuit_recap(circuit, edgeinfo)

            # Ask the user for the ID of the node they wish to modify.
            print("\nEnter the ID (e.g. '2') of the node you want to modify or type 'break' or 'b' to finish modifying nodes: ")
            
            # Return the user's input.
            return readline()
        end

    # ==============================================================================
    # ------------------------ function _process_user_input ------------------------
    # ==============================================================================

        """
            _process_user_input(input::String, circuit)::Symbol 

        Processes the user's input when modifying a node's coordinates.

        # Parameters:
        - input: The user's input.
        - circuit: The primary data structure representing the circuit's nodes and components.

        # Returns:
        - :continue if the user's input was processed successfully and the program should continue.
        - :break if the user's input was processed successfully and the program should break out of the loop.

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
                println("\nFinished modifying nodes.")
                return :break
            end
            
            # Try to parse the user's input as an integer.
            try

                # Parse the user's input as an integer.
                _parse_input_as_integer(input, circuit)
                return :continue

            # Handle potential errors (e.g., invalid input format).
            catch e
                println("\nInvalid input: $e. Please retry.")
                return :continue
            end
        end
        
    # ------------------------------------------------------------------------------
    # ------------------------- function _parse_input_as_integer -------------------
    # ------------------------------------------------------------------------------

        """
            _parse_input_as_integer(input::String, circuit)::nothing
        
        Parses the user's input as an integer and modifies the node's coordinates.

        # Parameters:
        - input: The user's input.
        - circuit: The primary data structure representing the circuit's nodes and components.

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
                println("""\nNode with ID N$node_id not found. 
                Please ensure node IDs are integers and the node exists in the circuit.""")
                return :continue
            end

            # Ask the user for the new coordinates.
            println("\nProvide the new coordinates for node N$node_id in the format 'x,y' (coordinates must be integers): ")

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
                println("\nNode N$node_id successfully modified to position ($x,$y).")
                return :continue

            end
        end

    # ------------------------- function _get_node_by_id ---------------------------

        """
            _get_node_by_id(node_id::Int, circuit)::Node

        Retrieve a specific node from the circuit using its ID.

        # Parameters:
        - node_id: The unique identifier for the node.
        - circuit: The primary data structure representing the circuit's nodes and components.

        # Returns:
        - The Node with the specified ID or nothing if not found.

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

    # ---------------------- function _update_node_coordinates ---------------------
            
        """
            _update_node_coordinates(node, x::Int, y::Int)

        Update the x and y coordinates of a given node.

        # Parameters:
        - node: The node whose coordinates are to be updated.
        - x: The new x-coordinate value.
        - y: The new y-coordinate value.

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
