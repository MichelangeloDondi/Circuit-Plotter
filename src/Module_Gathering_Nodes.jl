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

Version: 2.8
License: MIT License

Exported functions:
- `gather_nodes(circuit::Circuit)`: Systematically assembles information about the nodes
        present within the circuit, utilizing direct inputs from the user. The accumulated 
        data finds its place within the `circuit` structure. Additionally, a recap of node 
        particulars is presented, followed by the graphical portrayal of the updated circuit.
"""
module Gathering_Nodes

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================

        # Invoke this function to gather the nodes
        export collect_nodes_from_cmd

    # ==============================================================================
    # ========================= Imported Data Structure ============================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit, Node, EdgeInfo

    # ==============================================================================
    # =========================== Required Packages ================================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

    # ==============================================================================
    # =========================== Included Modules =================================
    # ==============================================================================  

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_break # Handle special input such as 'help', 'recap', 'draw', 'exit', 'break'

    # ==============================================================================
    # ---------------------- function _collect_nodes_from_cmd ----------------------
    # ==============================================================================
        
        """
            _collect_nodes_from_cmd(circuit::Circuit, edgeinfo::EdgeInfo) -> nothing

        Collects node coordinates from the user and adds them to the provided circuit.
        The user is prompted to input node coordinates or type 'stop' to end the node collection.

        # Parameters:
        - circuit: The primary data structure representing the circuit, including its nodes and components.

        # Returns:
        - nothing
        """
        function collect_nodes_from_cmd(circuit::Circuit, edgeinfo::EdgeInfo)
            
            # Initialize the node_count to track the number of nodes added to the circuit.
            node_count = 0

            # Continuously prompt the user for node coordinates.
            while true  

                # Print the prompt message.
                println("\n===================================================")
                println("\nNumber of nodes already present in the Circuit: $node_count.")
                println("\nProvide the coordinates of the next node (N$(node_count + 1)) or type 'break' or 'b' to finish adding nodes.")
                println("Format: x,y (coordinates must be integers):")
 
                # Read the input from the user.
                input = readline()

                # Handle special input (e.g. 'exit', 'help', 'recap', 'draw', 'save', 'break').
                handle_result = handle_special_input_break(input, circuit, edgeinfo)

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
                    else    

                        # Provide feedback to the user and break out of the loop.
                        println("\nFinished adding nodes to the circuit.")
                        break
                    end
                end
                
                # If the input isn't a special command, try adding the node to the circuit; increase count if successful.
                if _add_node_to_circuit(input, node_count + 1, circuit)
                    
                    # If the node was added, increase the node count.
                    node_count += 1
                end
            end
        end

    # ------------------------------------------------------------------------------
    # ------------------------ function _add_node_to_circuit -----------------------
    # ------------------------------------------------------------------------------

        """
            _add_node_to_circuit(input::String, idx::Int, circuit::Circuit)::Bool

        Adds a node to the circuit.

        Parameters:
        - input: The input provided by the user.
        - idx: The index of the node.
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.

        Returns:
        - true if the node was added, false otherwise.

        Raises:
        - Invalid input: If the input provided by the user is invalid.

        Notes:
        - The input is expected to be in the format x,y.
        """
        function _add_node_to_circuit(input::String, idx::Int, circuit::Circuit)::Bool
            
            # Split the input into its x and y coordinates.
            coords = split(input, ",")

            # Try to parse the coordinates as integers.
            try
                x, y = parse(Int, coords[1]), parse(Int, coords[2])

                # Check if a node already exists at the provided coordinates.
                for node in circuit.nodes
                    if node.x == x && node.y == y
                        println("\nNode N",node.id," already exists at position ($x,$y).")
                        return false
                    end
                end

                # Add the node to the circuit if it doesn't already exist.
                push!(circuit.nodes, Main.Node(idx, x, y))
                add_vertex!(circuit.graph)
                println("\nNode N$idx added at position ($x,$y).")
                return true
            catch

                # If the coordinates couldn't be parsed as integers, print an error message and return false.
                println("\nInvalid input. Enter integer coordinates as x,y.")
                return false
            end
        end
    end