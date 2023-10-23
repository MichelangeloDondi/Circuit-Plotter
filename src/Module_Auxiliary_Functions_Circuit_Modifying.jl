# ==============================================================================
# ==============================================================================
# ============= Module_Auxiliary_Functions_Circuit_Modifying.jl ================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Circuit_Modifying

Author: Michelangelo Dondi
Date: 23-10-2023
Description: 

Version: 3.1
License: MIT License

Exported functions: 

"""
module Auxiliary_Functions_Circuit_Modifying

    # ==============================================================================
    # =========================== Exported Functions ===============================
    # ==============================================================================

        # Invokes the modify_existing_node function to modify an existing node's coordinates in the circuit.
        export modify_existing_node

        # Invokes the delete_node_from_circuit function to delete an existing node from the circuit.
        export delete_node_from_circuit

    # ==============================================================================
    # ========================= Imported Data Structure ============================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit, EdgeInfo

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

    # ==============================================================================
    # ============================ Included Modules ================================
    # ==============================================================================

        # Module_Auxiliary_Functions_Circuit_Recap.jl provides auxiliary functions for recapping the circuit.
        include("Module_Auxiliary_Functions_Circuit_Recap.jl")
        using .Auxiliary_Functions_Circuit_Recap: show_circuit_recap # Recap the circuit    

        # Module_Auxiliary_Functions_Handle_Special_Input.jl provides auxiliary functions for input handling.
        include("Module_Auxiliary_Functions_Handle_Special_Input.jl")
        using .Auxiliary_Functions_Handle_Special_Input: handle_special_input_break # Handle special input such as 'help', 'recap', 'draw', 'exit', 'break'
        
    # ==============================================================================
    # ======================== function modify_existing_node =======================
    # ==============================================================================

        """
            modify_existing_node(circuit::Circuit) -> nothing

        Modifies an existing nodes's coordinates in the circuit based on user input.

        # Parameters:
        - circuit: The primary data structure representing the circuit, including its nodes and components.
        - edgeinfo: The data structure containing the edge information for the circuit.

        # Returns:
        - nothing
        """
        function modify_existing_node(circuit::Circuit, edgeinfo::EdgeInfo)

            # Continuously prompt the user for node coordinates to modify.
            while true

                # Provide instructions to the user.
                println("\nYou can modify the coordinates of an existing node by typing its ID and providing the new coordinates.")
                println("Here there is a recap of the current circuit for you convenience:")

                # Show the circuit recap.
                show_circuit_recap(circuit, edgeinfo)

                # Prompt the user for the node ID.
                println("\nEnter the ID (e.g. 2) of the node you want to modify or type 'break' or 'b' to finish modifying nodes:")

                # Read the input from the user.
                input = readline()

                # Handle special input (e.g. 'exit', 'help', 'recap', 'draw', 'save', 'break').
                handle_result = handle_special_input_break(input, circuit, edgeinfo)

                # If the input was handled, continue to the next iteration.
                if handle_result == :handled
                    continue

                # If the input was to stop collecting nodes, break out of the loop.
                elseif handle_result == :break

                    # Provide feedback to the user and break out of the loop.
                    println("\nFinished modifying nodes.")                
                    break
                end

                # If the input is not a special command, try to parse it as an integer.
                #if _modify_node
                # Try to parse the node ID as an integer.
                try

                    # Convert node ID to integer.
                    node_id = parse(Int, input)

                    # Initialize the found_node to track the node with the given ID.
                    found_node = nothing

                    # Find the node with the given ID.
                    for node in circuit.nodes

                        # If the node was found, break out of the loop.
                        if node.id == node_id   

                            # Update the found_node.
                            found_node = node
                            break
                        end
                    end

                    # Check if the node was found.
                    if found_node === nothing

                        # If the node wasn't found, print an error message and continue to the next iteration.
                        println("""\nNode with ID N$node_id not found. 
                        Please consider that node IDs must be integers and that the node must exist in the circuit.
                        The circuit recap is shown below for your convenience.
                        """)
                        continue
                    end

                    # Prompt user for new coordinates.
                    println("\nProvide the new coordinates for Node N$node_id in the format x,y (coordinates must be integers):")
                    input_coords = readline()

                    # Split the input and parse coordinates.
                    coords = split(input_coords, ",")
                    x, y = parse(Int, coords[1]), parse(Int, coords[2])

                    # Update node coordinates.
                    found_node.x = x
                    found_node.y = y

                    # Provide feedback to the user.
                    println("\nNode N$node_id modified to position ($x,$y).")
                catch e

                    # If the node ID couldn't be parsed as an integer, print an error message and continue to the next iteration.
                    println("\nInvalid input: $e. Please retry with a valid node ID.")
                    continue
                end
            end
        end

    # ==============================================================================
    # --------------------- function _check_if_inupt_is_valid ----------------------
    # ==============================================================================

        """
            _check_if_inupt_is_valid(input::String, circuit::Circuit)::Bool

        Checks if the input provided by the user is valid. The input is the coordinates of a new node. 
        The input is valid if it is in the format x,y (e.g. '1-2') and if no node already exists at the provided coordinates.

        # Parameters:
        - input: The input provided by the user.
        - circuit: The primary data structure representing the circuit, including its nodes and components.
            
        # Returns:
        - true if the input is valid.
        - false otherwise.

        # Notes:
        - The function is used by the collect_nodes_from_cmd function to check if the input provided by the user is valid.
        """
        function _check_if_inupt_is_valid(input::String, circuit::Circuit)::Bool

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
                        println("\nNode N",node.id," already exists at position ($x,$y).")
                        return false
                    end
                end

                # If no node already exists at the provided coordinates, return true.
                return true
            catch

                # If the coordinates could not be parsed as integers, print an error message and return false.
                println("\nInvalid input. Enter integer coordinates as x,y (e.g. '1,-2').")
                return false
            end
        end
        
    # ==============================================================================
    # ====================== function delete_node_from_circuit =====================
    # ==============================================================================

        """
            delete_node_from_circuit(circuit::Circuit) -> nothing

        Deletes an existing nodes from the circuit based on user input.

        # Parameters:
        - circuit: The primary data structure representing the circuit, including its nodes and components.
        - edgeinfo: The data structure containing the edge information for the circuit.

        # Returns:
        - nothing
        """
        function delete_node_from_circuit(node_count::Int, circuit::Circuit, edgeinfo::EdgeInfo)

            # Continuously prompt the user for node coordinates to delete.
            while true

                # Show the circuit recap.
                show_circuit_recap(circuit, edgeinfo)

                # Prompt the user for the node ID.
                println("\nEnter the ID of the node you want to delete or type 'break' or 'b' to finish deleting nodes:")

                # Read the node ID from the user.
                node_id_input = readline()

                if node_id_input in ["break", "b"]
                    println("\nFinished deleting nodes.")
                    break
                end

                # Try to parse the node ID as an integer.
                try

                    # Convert node ID to integer.
                    node_id = parse(Int, node_id_input)

                    # Find the node with the given ID.
                    found_node_idx = findfirst(node -> node.id == node_id, circuit.nodes)

                    # Check if the node was found.
                    if found_node_idx === nothing   

                        # If the node wasn't found, print an error message and continue to the next iteration.
                        println("\nNode with ID N$node_id not found.")
                        continue
                    end
        
                    # Delete the node from the circuit and provide feedback to the user.
                    deleteat!(circuit.nodes, found_node_idx)
                    println("\nNode N$node_id deleted.")
        
                    # Update the node_count.
                    node_count -= 1

                    # Update the IDs of nodes after the deleted node.
                    for i in found_node_idx:length(circuit.nodes)
                        circuit.nodes[i].id -= 1
                    end

                    # Rebuild the entire graph from the updated circuit.nodes array.
                    circuit.graph = SimpleGraph(length(circuit.nodes))

                catch e
                    println("\nInvalid input: $e")
                    continue
                end
            end

            # Return the updated node_count.
            return node_count
        end
end
