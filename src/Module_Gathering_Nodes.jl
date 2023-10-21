# ==============================================================================
# ==============================================================================
# ======================= Module_Gathering_Nodes.jl ============================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Nodes

Author: Michelangelo Dondi
Date: 21-10-2023
Description:    
    Dedicated to collecting nodes within the circuit.
    This module simplifies the collection process by providing a single function to call.

Version: 2.6
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
        export gather_nodes

    # ==============================================================================
    # ========================= Imported Data Structure ============================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit, Node

    # ==============================================================================
    # =========================== Required Packages ================================
    # ==============================================================================

        # For graph data structures
        using LightGraphs

    # ==============================================================================
    # =========================== Included Modules =================================
    # ==============================================================================  

        # Module_Helping.jl provides helper functions for the main program.
        include("Module_Helping.jl")
        using .Helping: show_help # Help and instructions

        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot

    # ==============================================================================
    # ======================== function gather_nodes ===============================
    # ==============================================================================

        """
            gather_nodes(circuit::Circuit) -> nothing

        Diligently fetches the specifics pertaining to the nodes in the circuit,
        sourcing directly from the user. The acquired nodes are securely housed
        within the `circuit` structure. As an auxiliary utility, the function renders
        a concise summary of the node particulars and visually maps the circuit's
        current configuration.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their
                illustrative representation within the circuit.

        Returns:
        - nothing
        """
        function gather_nodes(circuit::Circuit)
            _collect_nodes_from_cmd(circuit)
            _nodes_recap(circuit)
            draw_plot(circuit)
        end

    # ==============================================================================
    # ---------------------- function _collect_nodes_from_cmd ----------------------
    # ==============================================================================
        
        """
            _collect_nodes_from_cmd(node_count::Int, circuit::Circuit) -> nothing

        Sequentially gathers node details from the user.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.

        Returns:
        - nothing
        """
        function _collect_nodes_from_cmd(circuit::Circuit)
            node_count = 0
            while true
                println("\n===================================================")
                println("\nNumber of nodes already present in the Circuit: $node_count.")
                println("Type 'stop' to stop adding nodes or provide the
                      coordinates of the next node (N$(node_count + 1)).")
                println("Format: x,y (coordinates must be integer):")

                input = readline()
                if input == "stop"
                    break
                elseif !_handle_special_input(input) && _add_node_to_circuit(input, node_count + 1, circuit)
                    node_count += 1
                end
            end
        end

    # ------------------------------------------------------------------------------
    # ----------------------- function _handle_special_input -----------------------
    # ------------------------------------------------------------------------------
        
        """
            _handle_special_input(input::String)::Bool

        Handles special input from the user.

        Parameters:
        - input: The input provided by the user.

        Returns:
        - true if the input was handled, false otherwise.
        """
        function _handle_special_input(input::String)::Bool
            if input == "help"
                show_help()
                return true
            elseif input == "exit"
                println("Exiting the program.")
                exit(0)
            end
            return false
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
            coords = split(input, ",")

            try
                x, y = parse(Int, coords[1]), parse(Int, coords[2])
                for node in circuit.nodes
                    if node.x == x && node.y == y
                        println("\nNode N",node.id," already exists at position ($x,$y).")
                        return false
                    end
                end
                
                push!(circuit.nodes, Main.Node(idx, x, y))
                add_vertex!(circuit.graph)
                println("\nNode N$idx added at position ($x,$y).")
                return true
            catch
                println("\nInvalid input. Enter integer coordinates as x,y.")
                return false
            end
        end
        
    # ==============================================================================
    # ---------------------------- function _nodes_recap ---------------------------
    # ==============================================================================

        """
            _nodes_recap(circuit::Circuit) -> nothing

        Displays a recap of the nodes in the circuit.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.

        Returns:
        - nothing

        Notes:
        - The recap is displayed in the following format:
            ===================================================
            Nodes in the Circuit:
            N1 at (0,0)
            N2 at (0,1)
            N3 at (1,0)
            ===================================================
        """
        function _nodes_recap(circuit::Circuit)
            println("\n===================================================")
            println("Nodes in the Circuit:")
            for node in circuit.nodes
                println("N$(node.id) at ($(node.x),$(node.y))")
            end
            println("===================================================")
        end
    end