# ==============================================================================
# ==============================================================================
# ======================== Module_Gathering_Edges.jl ===========================
# ==============================================================================
# ==============================================================================

"""
    Module: Gathering_Edges

Author: Michelangelo Dondi
Date: 20-10-2023
Description:
    Dedicated to collecting edges within the circuit.
    This module simplifies the collection process by providing a single function to call.   

Version: 2.4
License: MIT License

Exported functions:
- `gather_edges(circuit::Circuit, edge_info::EdgeInfo)`: 
        Systematically assembles information about the edges or connections present 
        within the circuit, utilizing direct inputs from the user. The accumulated 
        data finds its place within the `edge_info` structure. Additionally, a recap 
        of edge particulars is presented, followed by the graphical portrayal of 
        the updated circuit.   
"""
module Gathering_Edges

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================

        # Invoke this function to gather the edges
        export gather_edges

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================

        # For accessing the data structures 
        include("Module_CircuitStructures.jl")
        using .CircuitStructures

        # Use these variables to access the data structures used by the Circuit Visualization Tool
        import Main: Circuit, EdgeInfo

    # ==============================================================================
    # =========================== Required Packages ================================
    # ==============================================================================    

        # For graph representation of the circuit
        using LightGraphs
    
    # ==============================================================================
    # =========================== Imported Modules =================================
    # ==============================================================================  
    
        # For assisting the user
        include("Module_Helping.jl") 
        using .Helping: show_help  

        # For checking edge overlaps
        include("Module_Auxiliary_Functions_Geometry.jl")
        using .Auxiliary_Functions_Geometry: overlapping_edges

        # For drawing the circuit
        include("Module_Plotting.jl")
        using .Plotting: draw_plot

    # ==============================================================================
    # ======================== function gather_edges ===============================
    # ==============================================================================

        """
            gather_edges(circuit::Circuit, edge_info::EdgeInfo) -> nothing

            Systematically assembles information about the edges or connections present 
            within the circuit, utilizing direct inputs from the user. The accumulated 
            data finds its place within the `edge_info` structure. Additionally, a recap 
            of edge particulars is presented, followed by the graphical portrayal of 
            the updated circuit.

            Parameters:
            - circuit: The nucleus structure, encapsulating nodes, components, and their 
                    pictorial representation in the circuit.
            - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

            Returns:
            - nothing
        """
        function gather_edges(circuit::Circuit, edge_info::EdgeInfo)
            collect_edges_from_cmd(length(circuit.nodes), circuit, edge_info)
            edges_recap(edge_info)
            draw_plot(circuit)
        end

    # ==============================================================================
    # ======================== Helper Functions ====================================
    # ==============================================================================

        """
            _handle_special_input(input::String) -> Bool

        Handles special inputs, such as "help" and "exit".

        Parameters:
        - input: The input provided by the user.

        Returns:
        - true: if the input is a special input
        - false: otherwise
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
            _add_edge_to_circuit(input::String, edge_count::Int, circuit::Circuit, edge_info::EdgeInfo) -> Bool

        Adds an edge to the circuit.

        Parameters:
        - input: The input provided by the user.
        - edge_count: The number of edges in the circuit.
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - true: if the edge was added successfully
        - false: otherwise
        """
        function _edge_exists(node1::Int, node2::Int, edge_info::EdgeInfo)::Bool
            for (index, existing_edge) in enumerate(edge_info.edges)
                if (node1, node2) == existing_edge
                    println("\nThe edge cannot be added for the following reason:")
                    println("Edge between nodes N$node1 and N$node2 already exists as E$index(N$node1->N$node2).")
                    return true
                    break
                elseif (node2, node1) == existing_edge
                    println("\nThe edge cannot be added for the following reason:")
                    println("Edge between nodes N$node1 and N$node2 already exists as E$index(N$node2->N$node1).")
                    return true
                    break
                end
            end
            return false
        end

    # ==============================================================================
    # ======================= function collect_edges_from_cmd ======================
    # ==============================================================================
        
        """
            collect_edges_from_cmd(node_count::Int, circuit::Circuit, edge_info::EdgeInfo) -> nothing  

        Sequentially gathers edge details from the user.

        Parameters:
        - node_count: The number of nodes in the circuit.
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing
        """
        function collect_edges_from_cmd(node_count::Int, circuit::Circuit, edge_info::EdgeInfo)
            edge_count = 0
            while true
                println("\n===================================================")
                println("\nCurrent edges: $edge_count. Press Enter to finish or provide nodes for the next edge (E$(edge_count + 1)).")
                println("Format: i,j (Direction: Ni->Nj)")

                input = readline()

                if input == ""
                    break        
                elseif _handle_special_input(input)
                    continue
                end

                edge_nodes = split(input, ",")
                if length(edge_nodes) != 2
                    println("\nInvalid input. Provide two node indices separated by a comma.")
                    continue
                end

                try
                    node1, node2 = parse(Int, edge_nodes[1]), parse(Int, edge_nodes[2])

                    if _edge_exists(node1, node2, edge_info)
                        continue
                    elseif node1 == node2
                        println("\nThe edge cannot be added for the following reason:")
                        println("Self-loops are not allowed.")
                        continue
                    end

                    if node1 < 1 || node1 > node_count || node2 < 1 || node2 > node_count
                        println("\nThe edge cannot be added for the following reason:")
                        println("Invalid node indices. Range: [1, $node_count].")
                        continue
                    end

                    overlapping = overlapping_edges((node1, node2), edge_info.edges, circuit.nodes)
                    if !isempty(overlapping)
                        overlaps_str = join(["E$(index)(N$(edge[1])->N$(edge[2]))" for (index, edge) in overlapping], ", ")
                        println("\nThe edge cannot be added for the following reason:")
                        println("Overlap detected with: $overlaps_str.")
                        continue
                    end

                    push!(edge_info.edges, (node1, node2))
                    add_edge!(circuit.graph, node1, node2)
                    edge_count += 1
                    println("\nEdge E$edge_count: N$node1 -> N$node2 added.")

                catch e
                    println("\nError: ", e)
                end
            end
        end

    # ==============================================================================
    # ======================== function edges_recap ================================
    # ==============================================================================

        """
            edges_recap(edge_info::EdgeInfo) -> nothing

        Displays a recap of the edges in the circuit.

        Parameters:
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing

        Notes:
        - The edges are displayed in the format Ei: Nj -> Nk, where i is the edge index, 
                j is the index of the first node, and k is the index of the second node.
        
        Example: 
        E1: N1 -> N2
        E2: N2 -> N3
        E3: N3 -> N4
        E4: N4 -> N1
        """ 
        function edges_recap(edge_info::EdgeInfo)
            println("===================================================")
            println("Edges in the Circuit:")
            for i in 1:length(edge_info.edges)
                println("E$i: N$(edge_info.edges[i][1]) -> N$(edge_info.edges[i][2])")
            end
            println("===================================================")
        end
    end