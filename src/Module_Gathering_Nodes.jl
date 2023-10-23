# ==============================================================================
# ==============================================================================
# ======================= Module_Gathering_Nodes.jl ============================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Nodes

Author: Michelangelo Dondi
Date: 23-10-2023
Description:    
    Dedicated to collecting nodes within the circuit.
    This module simplifies the collection process by providing a single function to call.

Version: 3.2
License: MIT License

Exported functions:
- `collect_nodes_from_cmd(circuit::Circuit, edgeinfo::EdgeInfo)`: Collects node coordinates 
from the user and adds them to the provided circuit. The user is prompted to input node
coordinates or type 'break' or 'b' to end the node collection. The user can also modify
or cancel existing nodes.
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
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: Node, EdgeInfo, Circuit # Access the data structures

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_break_modify_cancel # Handle the following special input: 'exit', 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel'

        # Module_Auxiliary_Functions_Circuit_Modifying.jl provides auxiliary functions for modifying the circuit.
        include("Module_Auxiliary_Functions_Circuit_Modifying.jl")
        using .Auxiliary_Functions_Circuit_Modifying: modify_existing_node # Modify existing nodes
        using .Auxiliary_Functions_Circuit_Modifying: delete_node_from_circuit # Delete existing nodes

    # ==============================================================================
    # ====================== function collect_nodes_from_cmd =======================
    # ==============================================================================
        
        """
            collect_nodes_from_cmd(circuit, edgeinfo) -> nothing

        Collects node coordinates from the user and adds them to the provided circuit.
        The user is prompted to input node coordinates or type 'break' or 'b' to end the node collection.

        # Parameters:
        - circuit: The primary data structure representing the circuit, including its nodes and components. 
        - edgeinfo: The data structure representing the edges of the circuit.

        # Returns:
        - nothing
        """
        function collect_nodes_from_cmd(circuit, edgeinfo)
            
            # Initialize the node_count to track the number of nodes added to the circuit.
            node_count = 0

            # Continuously prompt the user for node coordinates.
            while true  

                # Print the prompt message.
                print(""" 
                ===================================================

                Number of nodes already present in the Circuit: $node_count.

                Provide the coordinates of the next node (N$(node_count + 1))
                Format: integer x,y (e.g. '1,-2')
                
                Otherwise, you can call a general command (type 'help' or 'h' for more info)
                or one among of the following:

                - 'break'  or 'b' to stop collecting nodes.
                - 'modify' or 'm' to modify existing nodes.
                - 'cancel' or 'c' to cancel existing nodes.

                ===================================================

                Coordinates of the next node (N$(node_count + 1)) or ther command: """)
 
                # Read the input from the user.
                input = readline()

                # Handle special input ('exit', 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel').
                handle_result = handle_special_input_break_modify_cancel(input, circuit, edgeinfo)

                # If the input was handled, continue to the next iteration.
                if handle_result == :handled
                    continue

                # If the input was to stop collecting nodes, break out of the loop.
                elseif handle_result == :break

                    # If no nodes were added, print a message and continue to the next iteration.
                    if node_count == 0

                        # Provide feedback to the user and continue to the next iteration.
                        println("\nYour circuit has no nodes so far.")
                        println("You must add at least one node to the circuit to continue.")
                        continue

                    # If at least one node was added, break out of the loop.
                    else    

                        # Provide feedback to the user and break out of the loop.
                        println("\nFinished adding nodes to the circuit.")
                        break
                    end
                
                # If the input was to modify existing nodes, modify them.
                elseif handle_result == :modify 

                    # Modify the existing nodes.
                    modify_existing_node(circuit, edgeinfo)
                    
                # If the input was to cancel existing nodes, delete them.
                elseif handle_result == :cancel

                    # Delete the nodes and update the node count.
                    node_count = delete_node_from_circuit(node_count, circuit, edgeinfo)
                
                # Check if the node can be added to the circuit.
                elseif _check_if_inupt_is_valid(input, circuit)

                    # Add the node to the circuit.
                    _add_node_to_circuit(input, node_count + 1, circuit)
                    
                    # If the node was added, increase the node count.
                    node_count += 1
                end
            end
        end

    # ==============================================================================
    # --------------------- function _check_if_inupt_is_valid ----------------------
    # ==============================================================================

        """
            _check_if_inupt_is_valid(input::String, circuit)::Bool  

        Checks if the input is valid. The input is valid if it is in the format 'integer x,y' (e.g. '1,-2') 
        and if no node already exists at the provided coordinates.

        # Parameters:
        - input: The input provided by the user.
        - circuit: The primary data structure representing the circuit, including its nodes and components.
            
        # Returns:
        - true if the input is valid.
        - false otherwise.
        """
        function _check_if_inupt_is_valid(input::String, circuit)::Bool

            # Split the input into its x and y coordinates.
            coords = split(input, ",")

            # Try to parse the coordinates as integers.
            try 

                # Parse the coordinates as integers.
                x, y = parse(Int, coords[1]), parse(Int, coords[2])

                # Check if a node already exists at the provided coordinates.
                for node in circuit.nodes

                    # If a node already exists at the provided coordinates, print an error message and return false.
                    if node.x == x && node.y == y   

                        # Provide feedback to the user and return false.
                        println("\nThe node cannot be added for the following reason:")
                        println("Node N",node.id," already exists at position ($x,$y).")
                        return false
                    end
                end

                # If no node already exists at the provided coordinates, return true.
                return true
            catch

                # If the coordinates couldn't be parsed as integers, print an error message and return false.
                println("\nInvalid input. Enter integer coordinates as x,y (e.g. '1,-2').")
                return false
            end
        end

    # ==============================================================================
    # ------------------------ function _add_node_to_circuit -----------------------
    # ==============================================================================

        """
            _add_node_to_circuit(idx::Int, circuit) -> nothing

        Adds the node to the circuit.

        # Parameters:
        - idx: The index of the node to add.
        - circuit: The primary data structure representing the circuit, including its nodes and components.
            
        # Returns:
        - nothing
            
        # Notes:
        - This function is called by `collect_nodes_from_cmd`.
        - This function is called after the node has been checked for validity by `_check_if_node_can_be_added`.
        """
        function _add_node_to_circuit(input::String, idx::Int, circuit)

            # Split the input into its x and y coordinates.
            coords = split(input, ",")

            # Paese the coordinates as integers.
            x, y = parse(Int, coords[1]), parse(Int, coords[2])
                
            # Add the node to the circuit if it doesn't already exist.
            push!(circuit.nodes, Main.Main_Function.Circuit_Structures.Node(idx, x, y))
            add_vertex!(circuit.graph)

            # Provide feedback to the user and return true.
            println("\nNode N$idx successfully added at position ($x,$y).")
    end
    end