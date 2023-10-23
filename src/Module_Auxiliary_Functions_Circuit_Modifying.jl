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

                # Show the circuit recap.
                show_circuit_recap(circuit, edgeinfo)

                # Prompt the user for the node ID.
                println("\nEnter the ID of the node you want to modify or type 'break' or 'b' to finish modifying nodes:")
                
                # Read the node ID from the user.
                node_id_input = readline()

                # Handle special input (e.g. 'exit', 'help', 'recap', 'draw', 'save', 'break').
                if node_id_input == "break" || node_id_input == "b"

                    # Provide feedback to the user and break out of the loop.
                    println("\nFinished modifying nodes.")
                    break
                end

                # Try to parse the node ID as an integer.
                try

                    # Convert node ID to integer.
                    node_id = parse(Int, node_id_input)

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
                        println("\nNode with ID N$node_id not found.")
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
                    println("\nInvalid input: $e")
                    continue
                end
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
