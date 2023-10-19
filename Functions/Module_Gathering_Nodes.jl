# ==============================================================================
# ==============================================================================
# ======================= Module_Gathering_Nodes.jl ============================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Nodes

Author: Michelangelo Dondi
Date: 19-10-2023
Description:    
    Dedicated to collecting nodes within the circuit.
    This module simplifies the collection process by providing a single function to call.

Version: 2.1
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

        # For housing the data structures used by the Circuit Visualization Tool
        import Main: Circuit, Node

    # ==============================================================================
    # =========================== Required Packages ===============================
    # ==============================================================================

        # For graph representation of the circuit
        using LightGraphs

    # ==============================================================================
    # =========================== Imported Modules ===============================
    # ==============================================================================  
        
        # For housing the data structures used by the Circuit Visualization Tool    
        #include("Module_Data_Structure.jl")
        #using .Data_Structure: Circuit, Node

        # For assisting the user
        include("Module_Helping.jl") 
        using .Helping: show_help  

        # For user input validation
        include("Module_Auxiliary_Functions.jl")
        using .Auxiliary_Functions_Input_Validation: get_positive_integer_input

        # For drawing the circuit
        include("Module_Plotting.jl")
        using .Plotting: draw_plot

    # ==============================================================================
    # ======================== function gather_nodes ================================
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
            node_count = get_positive_integer_input("How many nodes does your circuit have? ")
            collect_nodes_from_cmd(node_count, circuit)
            nodes_recap(circuit)
            draw_plot(circuit)
        end

        # ==============================================================================
        # ============================ Helper Functions ================================
        # ==============================================================================

            """
                collect_nodes_from_cmd(node_count::Int, circuit::Circuit) -> nothing

            Sequentially gathers node details from the user.

            Parameters:
            - node_count: The number of nodes in the circuit.
            - circuit: The primary structure amalgamating nodes, components, and their 
                    illustrative representation within the circuit.

            Returns:
            - nothing
            """
            function collect_nodes_from_cmd(node_count::Int, circuit::Circuit)
                for i in 1:node_count
                    while true
                        println("\n===================================================")
                        println("Node # $i/$node_count: Enter coordinates (format: x,y):")

                        input = readline()
                        if !_handle_special_input(input) && _add_node_to_circuit(input, i, circuit)
                            break
                        end
                    end
                end
            end

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

            """
                _node_exists_at_position(x::Int, y::Int, circuit::Circuit)::Bool

            Checks if a node exists at the given position.

            Parameters:
            - x: The x-coordinate of the node.
            - y: The y-coordinate of the node.
            - circuit: The primary structure amalgamating nodes, components, and their 
                    illustrative representation within the circuit.

            Returns:
            - true if a node exists at the given position, false otherwise.
            """
            function _node_exists_at_position(x::Int, y::Int, circuit::Circuit)::Bool
                return findfirst(n -> n.x == x && n.y == y, circuit.nodes) !== nothing
            end

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
                    
                    if _node_exists_at_position(x, y, circuit)
                        println("\nNode already exists at position ($x, $y).")
                        return false
                    end
                    
                    push!(circuit.nodes, Main.Node(idx, x, y))
                    add_vertex!(circuit.graph)
                    println("\nNode N$idx added at position ($x, $y).")
                    return true
                catch
                    println("\nInvalid input. Enter coordinates as x,y.")
                    return false
                end
            end

        # ==============================================================================
        # ======================== function nodes_recap =================================
        # ==============================================================================

            """
                nodes_recap(circuit::Circuit) -> nothing

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
                N1 at (0, 0)
                N2 at (0, 1)
                N3 at (1, 0)
                ===================================================
            """
            function nodes_recap(circuit::Circuit)
                println("\n===================================================")
                println("Nodes in the Circuit:")
                for node in circuit.nodes
                    println("N$(node.id) at ($(node.x), $(node.y))")
                end
                println("===================================================")
            end
    end