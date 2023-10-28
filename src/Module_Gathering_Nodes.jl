# ==============================================================================
# ==============================================================================
# ======================== Module: Gathering_Nodes =============================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Nodes

Author: Michelangelo Dondi
Date: 28-10-2023
Description:    
    Dedicated to housing the functions for collecting node details from the user.
    This module simplifies the main function definition process by providing a single file to call.

Version: 4.2
License: MIT License

Exported functions:
- `collect_nodes_from_cmd(circuit, edgeinfo)`: Main function to collect node coordinates 
from the user. The user is prompted to input node coordinates or type 'break' or 'b' to 
end the node collection. The user can also modify or cancel existing nodes.

Notes:
- This module is called by `Module_Main_Function.jl`.
- This module is called after the user has been greeted and instructed by `Module_Helping.jl`.
- This module is called before the user is prompted to input component details by `Module_Gathering_Components.jl`.
- The module requires the following modules to be included: 
    - Module_Circuit_Structures.jl 
    - Module_Auxiliary_Functions_Handle_Special_Input.jl 
    - Module_Auxiliary_Functions_Circuit_Modifying.jl
    - Module_Auxiliary_Functions_Circuit_Deleting.jl
"""
module Gathering_Nodes

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================

        # Invoke this function to gather the nodes
        export collect_nodes_from_cmd

    # ==============================================================================
    # =========================== Required Packages ================================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

    # ==============================================================================
    # =========================== Included Modules =================================
    # ==============================================================================  

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("datastructure.jl")
        using .DataStructure: Node, EdgeInfo, Circuit # Access the data structures

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_break_modify_cancel # Handle the following special input: 'exit', 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel'

        # Module_Auxiliary_Functions_Checking_Input_Of_Nodes provides auxiliary functions for checking the input of nodes.
        include("Module_Auxiliary_Functions_Checking_Input_Of_Nodes.jl")
        using .Auxiliary_Functions_Checking_Input_Of_Nodes: check_if_input_is_valid # Check if the node can be added to the circuit.

        # Module_Auxiliary_Functions_Circuit_Modifying.jl provides auxiliary functions for modifying the circuit.
        include("Module_Auxiliary_Functions_Circuit_Modifying.jl")
        using .Auxiliary_Functions_Circuit_Modifying: modify_existing_node # Modify existing nodes

        # Module_Auxiliary_Functions_Circuit_Deleting.jl provides auxiliary functions for deleting nodes from the circuit.
        include("Module_Auxiliary_Functions_Circuit_Deleting.jl")
        using .Auxiliary_Functions_Circuit_Deleting: delete_node_from_circuit # Delete existing nodes

    # ==============================================================================
    # ======================= function collect_nodes_from_cmd ======================
    # ==============================================================================
        
        """
            collect_nodes_from_cmd(circuit, edgeinfo)
        
        Main function to collect node coordinates from the user. 
        The user is prompted to input node coordinates or type 'break' or 'b' to end the node collection. 
        The user can also modify or cancel existing nodes.
        
        # Parameters:
        - circuit: The primary data structure representing the circuit.
        - edgeinfo: Data structure representing the edges of the circuit.
        
        # Returns:
        - Nothing. Modifies the circuit and edgeinfo in-place.

        # Notes:
        - This function is called by `main`.
        - This function is called after the user has been greeted and instructed by `show_initial_greetings`.
        """
        function collect_nodes_from_cmd(circuit, edgeinfo)

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
    # ---------------------- function _prompt_for_coordinates ----------------------
    # ==============================================================================

        """
            _prompt_for_coordinates(node_count::Int) -> String
        
        Prompt the user for node coordinates or a special command.
        
        # Parameters:
        - node_count: The number of nodes already present in the circuit.
        
        # Returns:
        - The input string provided by the user.

        # Notes:
        - This function is called by `collect_nodes_from_cmd`.
        """
        function _prompt_for_coordinates(node_count::Int)

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

        # Notes:
        - This function is called by `collect_nodes_from_cmd`.
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