# ==============================================================================
# ==============================================================================
# ============= Module_Auxiliary_Functions_Circuit_Deleting.jl ================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Circuit_Deleting

Author: Michelangelo Dondi
Date: 28-10-2023
Description: 
    This module provides functions for modifying an existing node's coordinates in 
    the circuit and for deleting an existing node from the circuit.

Version: 4.1
License: MIT License

Exported functions: 
- `delete_node_from_circuit(circuit)`: Deletes an existing nodes from the circuit based on user input.  

Notes:
- The module is included in Module_Gathering_Nodes.jl.  
- The module requires the following modules to be included:
    - Module_Circuit_Structures.jl
    - Module_Auxiliary_Functions_Circuit_Recap.jl
    - Module_Auxiliary_Functions_Handle_Special_Input.jl    
"""
module Auxiliary_Functions_Circuit_Deleting

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

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: EdgeInfo, Circuit # Access the data structures

        # Module_Auxiliary_Functions_Circuit_Recap.jl provides auxiliary functions for recapping the circuit.
        include("Module_Auxiliary_Functions_Circuit_Recap.jl")
        using .Auxiliary_Functions_Circuit_Recap: show_nodes_recap # Recap the circuit    

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_break # Handle special input ('help', 'recap', 'draw', 'exit', 'break')

    # ==============================================================================
    # ====================== function delete_node_from_circuit =====================
    # ==============================================================================

        """
            delete_node_from_circuit(circuit) -> nothing

        Allows the user to delete an existing node from the circuit based on user input.

        # Parameters:
        - circuit: The primary data structure representing the circuit, including its nodes and components.
        - edgeinfo: The data structure containing the edge information for the circuit.

        # Returns:
        - nothing
        """
        function delete_node_from_circuit(node_count, circuit, edgeinfo)

            # Continuously prompt the user for node coordinates to delete.
            while true

                # Display instructions for the user.
                input = _prompt_deleting_node_instructions(circuit, edgeinfo) 

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
    # ----------------- function _prompt_deleting_node_instructions ----------------
    # ==============================================================================

        function _prompt_deleting_node_instructions(circuit, edgeinfo)

            # Display the instructions for the user.
            println("""\033[36m
            You can delete an existing node from the circuit by entering its ID.

            Here there is a recap of the nodes in the circuit for your convenience: \033[0m""")

            # Show the circuit recap.
            show_nodes_recap(circuit, edgeinfo)

            # Prompt the user for the node ID.
            print("\n\033[36mEnter the ID (e.g. '2') of the node you want to delete or type 'break' or 'b' to finish deleting nodes: \033[0m")

            # Read the node ID from the user.
            input = readline()

            return input
        end

    # ==============================================================================
    # --------------------- function _process_user_input ---------------------------
    # ==============================================================================

        """
            _process_user_input(input::String, circuit, edgeinfo)::Symbol

        Processes the user's input and returns a symbol indicating the action to be taken.

        # Parameters:
        - input: The input provided by the user.
        - circuit: The primary data structure representing the circuit, including its nodes and components.
        - edgeinfo: The data structure containing the edge information for the circuit.

        # Returns:
        - :continue if the user's input was processed successfully and the program should continue.
        - :break if the user's input was processed successfully and the program should break.
        
        # Notes:
        - The function is used by the delete_node_from_circuit function to process the user's input.
        - This function is the primary driver for user interaction when modifying nodes.
        It leverages the other helper functions to simplify its logic.
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
    # ------------------------- function _parse_input_as_integer -------------------
    # ------------------------------------------------------------------------------

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
