# ==============================================================================
# ==============================================================================
# =========================== Module: DeletingNodes ============================
# ==============================================================================
# ==============================================================================

"""
    Module: DeletingNodes

This module provides functions for modifying an existing node's coordinates in 
the circuit and for deleting an existing node from the circuit.

# Author: Michelangelo Dondi

# Date: 29-10-2023

# Version: 4.7

# License: MIT License

# Included modules:
    - 'DataStructure': Provides the data structures used by the Circuit Plotter Program.
    - 'CircuitRecap': Provides auxiliary functions for recapping the circuit.
    - 'HandlingSpecialInput': Provides auxiliary functions for input handling.

# Required packages:
    - 'LightGraphs': For graph data structures.

# Exported functions: 
    - `delete_node_from_circuit(circuit)`: Deletes an existing nodes from the circuit based on user input.  

# When the exported functions are invoked?
    - The function `delete_node_from_circuit(circuit)` is invoked by the function 
    `_process_input(input::String, node_count::Int, circuit, edgeinfo)' in module 'GatheringNodes'.

# Notes:
    - Funcion 'delete_node_from_circuit(circuit)' is the primary driver for user interaction when deling nodes.
"""
module DeletingNodes

    # ==============================================================================
    # =========================== Exported Functions ===============================
    # ==============================================================================

        # Invokes the delete_node_from_circuit function to delete an existing node from the circuit.
        export delete_node_from_circuit

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

    # ==============================================================================
    # ============================ Included Modules ================================
    # ==============================================================================

        # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
        include("../../datastructure.jl")
        using .DataStructure: EdgeInfo, Circuit # Access the data structures

        # Module 'CircuitRecap' provides auxiliary functions for recapping the circuit.
        include("../../functions_always_callable/circuit_recap.jl")
        using .CircuitRecap: show_nodes_recap # Recap the circuit    

        # Module 'HandlingSpecialInput' provides auxiliary functions for input handling.
        include("../../functions_always_callable/handling_special_input.jl")
        using .HandlingSpecialInput: handle_special_input_break # Handle special input ('help', 'recap', 'draw', 'exit', 'break')

    # ==============================================================================
    # ================ Function: delete_node_from_circuit(circuit) =================
    # ==============================================================================

        """
            delete_node_from_circuit(circuit)

        Allows the user to delete an existing node from the circuit based on user input.

        # Parameters:
            - circuit: The primary data structure representing the circuit, including its nodes and components.
            - edgeinfo: The data structure containing the edge information for the circuit.

        # Returns:
            - nothing

        # Function logic:
            - Continuously prompt the user for node coordinates to delete.
            - Display instructions for the user.
            - Process the user's input.
            - If the user wants to stop modifying, break the loop.
            - Return the decreased node counter.

        # When the function is invoked?
            - The function is invoked by the function `_process_input(input::String, node_count::Int, circuit, edgeinfo)' in module 'GatheringNodes'.
        
        # Notes:
            - The function is the primary driver for user interaction when deling nodes.
        """
        function delete_node_from_circuit(node_count, circuit, edgeinfo)

            # Continuously prompt the user for node coordinates to delete.
            while true

                # Display instructions for the user.
                input = _prompt_deleting_node_instructions(circuit) 

                # Process the user's input.
                node_count, action = _process_user_input(node_count, input, circuit, edgeinfo)

                # If the user wants to stop modifying, break the loop.
                if action == :break
                    break
                end    
            end

            # Return the decreased node counter.
            return node_count
        end

    # ==============================================================================
    # ----------- Function: _prompt_deleting_node_instructions(circuit) ------------
    # ==============================================================================

        """
            _prompt_deleting_node_instructions(circuit)

        Displays the instructions for the user to delete an existing node from the circuit.

        # Parameters:
            - circuit: The primary data structure representing the circuit, including its nodes and components.
            
        # Returns:
            - input: The input provided by the user.
        
        # Function logic:
            - Display the instructions for the user.
            - Show the circuit recap.
            - Prompt the user for the node ID.
            - Read the node ID from the user.
        
        # When the function is invoked?
            - The function is invoked by the function 'delete_node_from_circuit(circuit)' in module 'DeletingNodes'.
        
        # Notes:
            - The function is used by the function 'delete_node_from_circuit(circuit)' to display the instructions for the user.
        """
        function _prompt_deleting_node_instructions(circuit)

            # Display the instructions for the user.
            println("""\033[36m
            You can delete an existing node from the circuit by entering its ID.

            Here there is a recap of the nodes in the circuit for your convenience: \033[0m""")

            # Show the circuit recap.
            show_nodes_recap(circuit)

            # Prompt the user for the node ID.
            print("\n\033[36mEnter the ID (e.g. '2') of the node you want to delete or type 'break' or 'b' to finish deleting nodes: \033[0m")

            # Read the node ID from the user.
            input = readline()

            return input
        end

    # ==============================================================================
    # ------- Function: _process_user_input(input::String, circuit, edgeinfo) ------
    # ==============================================================================

        """
            _process_user_input(node_count, input::String, circuit, edgeinfo)

        Processes the user's input and returns a symbol indicating the action to be taken.

        # Parameters:
            - node_count: The number of nodes in the circuit before the deletion.
            - input: The input provided by the user.
            - circuit: The primary data structure representing the circuit, including its nodes and components.
            - edgeinfo: The data structure containing the edge information for the circuit.

        # Returns:
            - node_count: The number of nodes in the circuit after the deletion.
            - :continue if the user wants to continue deleting nodes.
            - :break if the user wants to stop deleting nodes.

        # Function logic:
            - Check if the user entered special commands.
            - If the command was handled (e.g., exit, recap), continue to the next iteration.
            - If the user wants to stop deleting, break the loop.
            - Try to parse the user's input as an integer.
            - Handle potential errors (e.g., invalid input format).
            - Continue to the next iteration.
        
        # When the function is invoked?
            - The function is invoked by the function 'delete_node_from_circuit(circuit)' in module 'DeletingNodes'.

        # Notes:
            - The function is used by the function 'delete_node_from_circuit(circuit)' to process the user's input.
            - The function is used by the function 'delete_node_from_circuit(circuit)' to return a symbol indicating the action to be taken.
            - The function is used by the function 'delete_node_from_circuit(circuit)' to return the decreased node counter.
        """
        function _process_user_input(node_count, input::String, circuit, edgeinfo)

            # Check if the user entered special commands.
            handle_result = handle_special_input_break(input, circuit, edgeinfo)

            # If the command was handled (e.g., exit, recap), continue to the next iteration.
            if handle_result == :handled
                return node_count, :continue

            # If the user wants to stop deleting, break the loop.
            elseif handle_result == :break

                # Provide feedback to the user and break the loop.
                println("\n\033[32mFinished deleting nodes. \033[0m")
                return node_count, :break
            else
            
                # Try to parse the user's input as an integer.
                try

                    # Parse the input as an integer.
                    node_count = _parse_input_as_integer(node_count, input, circuit)

                # Handle potential errors (e.g., invalid input format).
                catch e

                    # Provide feedback to the user.
                    println("\n\033[31mInvalid input: $e. Please retry.\n\033[0m")
                end

                # Continue to the next iteration.
                return node_count, :continue
            end
        end
        
    # ------------------------------------------------------------------------------
    # ---------- Function: _parse_input_as_integer(input::String, circuit) ---------
    # ------------------------------------------------------------------------------

        """
            _parse_input_as_integer(node_count, input::String, circuit)

        Parses the user's input as an integer and deletes the node with the given ID from the circuit.

        # Parameters:
            - input: The input provided by the user.
            - circuit: The primary data structure representing the circuit, including its nodes and components.
            - edgeinfo: The data structure containing the edge information for the circuit.

        # Returns:
            - node_count: The number of nodes in the circuit after the deletion.

        # Function logic:
            - Convert the input to an integer.
            - Find the node with the given ID.
            - If the node was not found, print an error message and continue to the next iteration.
            - Delete the node from the circuit and provide feedback to the user.
            - Update the node_count.
            - Update the IDs of nodes after the deleted node.
            - Rebuild the entire graph from the updated circuit.nodes array.

        # When the function is invoked?
            - The function is invoked by the function '_process_user_input(input::String, circuit, edgeinfo)' in module 'DeletingNodes'.
            
        # Notes:
            - The function is used by the function '_process_user_input(input::String, circuit, edgeinfo)' to parse the user's input as an integer.
            - The function is used by the function '_process_user_input(input::String, circuit, edgeinfo)' to delete the node with the given ID from the circuit.
            - The function is used by the function '_process_user_input(input::String, circuit, edgeinfo)' to update the node IDs after the deleted node.
            - The function is used by the function '_process_user_input(input::String, circuit, edgeinfo)' to rebuild the entire graph from the updated circuit.nodes array.
        """
        function _parse_input_as_integer(node_count, input::String, circuit)

            # Convert the input to an integer.
            node_id = parse(Int, input)

            # Find the node with the given ID.
            found_node_idx = findfirst(node -> node.id == node_id, circuit.nodes)

            # Check if the node was found.
            if found_node_idx === nothing   

                # If the node was not found, print an error message and continue to the next iteration.
                println("""
                \033[31m
                Node with ID N$node_id not found. \033[36m
                Please consider that node IDs must be integers and that the node must exist in the circuit.\033[0m """)
                return node_count
            end

            # Delete the node from the circuit and provide feedback to the user.
            deleteat!(circuit.nodes, found_node_idx)
            println("\n\033[32mNode N$node_id successfully deleted.\033[0m")

            # Update the node_count.
            node_count -= 1

            # Update the IDs of nodes after the deleted node.
            for i in found_node_idx:length(circuit.nodes)
                circuit.nodes[i].id -= 1
            end

            # Rebuild the entire graph from the updated circuit.nodes array.
            circuit.graph = SimpleGraph(length(circuit.nodes))

            return node_count
        end
end
