# ==============================================================================
# ==============================================================================
# =================== Module_Auxiliary_Functions_Recap.jl ======================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Recap

Author: Michelangelo Dondi
Date: 27-10-2023
Description: 
    Dedicated to providing auxiliary functions for recapping the circuit. 
    This module simplifies the recap process by providing a single file to call.    
 
Version: 3.6
License: MIT License

Exported functions: 
- `show_circuit_recap(circuit, edge_info)`: Displays a recap 
of the circuit in the console. The recap includes a summary of the nodes, edges,
and components present within the circuit.
- `show_nodes_recap(circuit)`: Displays a recap of the nodes in the circuit.

Notes:
- The nodes recap is displayed in the console in the following format:
    - 'Ni at (xi,yi)', where i is the index of the node.
- The edges  recap is displayed in the console in the following format:
    - 'Ei: Nj -> Nk', where i is the edge index, j is the index of the first node, 
    and k is the index of the second node.
- The components recap is displayed in the console in the following format:
    - '"Component details" on edge Ei (Nj -> Nk)', where i is the edge index, 
    j is the index of the first node, and k is the index of the second node.
"""
module Auxiliary_Functions_Circuit_Recap

    # ==============================================================================
    # ============================== Exported Function =============================
    # ==============================================================================
            
        # Invoke this function to export the recap function
        export show_circuit_recap

        # Invoke this function to export the nodes recap function
        export show_nodes_recap

    # ==============================================================================
    # ============================== Included Modules ==============================
    # ==============================================================================

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: EdgeInfo, Circuit # Access the data structures

    # ==============================================================================
    # ======================== function show_circuit_recap =========================
    # ==============================================================================

        """
            show_circuit_recap(circuit, edge_info) -> nothing

        Displays a recap of the circuit in the console. The recap includes a summary of the nodes, edges,
        and components present within the circuit.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing

        Notes:

        Example:

        ---------------------------------------------------
                        BEGIN OF CIRCUIT RECAP
        ---------------------------------------------------

        There are 4 nodes in the circuit:

            - N1 at (0,0)
            - N2 at (0,1)
            - N3 at (1,0)
            - N4 at (1,1)

        ---------------------------------------------------

        There are 4 edges in the circuit:

            - E1: N1 -> N2
            - E2: N2 -> N3
            - E3: N3 -> N4
            - E4: N4 -> N1

        ---------------------------------------------------

        There are 4 components in the circuit:

            - "R1 = 10 [Ω]" on edge E1 (N1 -> N2)
            - "R2 = 20 [Ω]" on edge E2 (N2 -> N3)
            - "R3 = 30 [Ω]" on edge E3 (N3 -> N4)
            - "R4 = 40 [Ω]" on edge E4 (N4 -> N1)

        ---------------------------------------------------
                        END OF CIRCUIT RECAP
        ---------------------------------------------------
        """
        function show_circuit_recap(circuit, edge_info)

            println("\n\033[33m---------------------------------------------------")
            println("               BEGIN OF CIRCUIT RECAP")
            println("---------------------------------------------------\n")

            # Display a recap of the nodes in the circuit
            _nodes_recap(circuit)
            println("\n---------------------------------------------------")    

            # Display a recap of the edges in the circuit
            _edges_recap(edge_info)
            println("\n---------------------------------------------------")

            # Display a recap of the components in the circuit
            _components_recap(circuit)  

            println("\n---------------------------------------------------")
            println("               END OF CIRCUIT RECAP")
            println("---------------------------------------------------\n\033[0m")
        end
        
    # ==============================================================================
    # ========================= function show_nodes_recap ==========================
    # ==============================================================================
        
        """
            show_nodes_recap(circuit) -> nothing

        Displays a recap of the nodes in the circuit.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.

        Returns:
        - nothing

        Notes:
        - If there are no nodes in the circuit, a message to that effect is displayed.
        - The recap is displayed in the console in the following format:
        - Ni at (xi,yi), where i is the index of the node.

        Example:

        ---------------------------------------------------
                        BEGIN OF NODES RECAP
        ---------------------------------------------------

        There are 4 nodes in the circuit:

            - N1 at (0,0)
            - N2 at (0,1)
            - N3 at (1,0)
            - N4 at (1,1)

        ---------------------------------------------------
                        END OF NODES RECAP
        ---------------------------------------------------

        """
        function show_nodes_recap(circuit)

            println("\n\033[36m---------------------------------------------------")
            println("                BEGIN OF NODES RECAP")
            println("---------------------------------------------------\n")

            # Display a recap of the nodes in the circuit
            _nodes_recap(circuit)

            println("\n---------------------------------------------------")
            println("               END OF NODES RECAP")
            println("---------------------------------------------------\033[0m\n")
        end    

    # ==============================================================================
    # ---------------------------- function _nodes_recap ---------------------------
    # ==============================================================================

        """
            _nodes_recap(circuit) -> nothing

        Displays a recap of the nodes in the circuit.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.

        Returns:
        - nothing

        Notes:
        - If there are no nodes in the circuit, a message to that effect is displayed.
        - The recap is displayed in the console in the following format:
        - Ni at (xi,yi), where i is the index of the node.

        Example:

        There are 4 nodes in the circuit:

            - N1 at (0,0)
            - N2 at (0,1)
            - N3 at (1,0)
            - N4 at (1,1)
        """
        function _nodes_recap(circuit)

            # Display a recap of the nodes in the circuit
            if isempty(circuit.nodes)   

                # If there are no nodes in the circuit, display a message to that effect.
                println("There are no nodes in the circuit.")
            else    

                # Otherwise, display the number of nodes in the circuit.
                println("There are $(length(circuit.nodes)) nodes in the circuit:\n")

                # Display the details of each node in the circuit
                for node in circuit.nodes

                    # Display the details of the node in the format Ni at (xi,yi), where i is the index of the node.
                    println("   - N$(node.id) at ($(node.x),$(node.y))")
                end
            end
        end
    
    # ==============================================================================
    # --------------------------- function _edges_recap ----------------------------
    # ==============================================================================

        """
            _edges_recap(edge_info) -> nothing

        Displays a recap of the edges in the circuit.

        Parameters:
        - edge_info: A dedicated structure to chronicle the specifics of node-to-node connectivity.

        Returns:
        - nothing

        Notes:
        - The edges are displayed in the format Ei: Nj -> Nk, where i is the edge index, 
                j is the index of the first node, and k is the index of the second node.

        Example: 

        There are 4 edges in the circuit:

            - E1: N1 -> N2
            - E2: N2 -> N3
            - E3: N3 -> N4
            - E4: N4 -> N1
        """ 
        function _edges_recap(edge_info)
            
            # Display a recap of the edges in the circuit
            if isempty(edge_info.edges)

                # If there are no edges in the circuit, display a message to that effect.
                println("\nThere are no edges in the circuit.")
            else    

                # Otherwise, display the number of edges in the circuit.
                println("\nThere are $(length(edge_info.edges)) edges in the circuit:\n")            

                # Display the details of each edge in the circuit
                for i in 1:length(edge_info.edges)

                    # Display the details of the edge in the format Ei: Nj -> Nk, where i is the edge index,
                    println("   - E$i: N$(edge_info.edges[i][1]) -> N$(edge_info.edges[i][2])")
                end
            end
        end

    # ==============================================================================
    # -------------------------- function _component_recap -------------------------
    # ==============================================================================

        """
            _components_recap(circuit) -> nothing

        Displays a recap of the components in the circuit.

        Parameters:
        - circuit: The primary structure amalgamating nodes, components, and their 
                illustrative representation within the circuit.

        Returns:
        - nothing

        Notes:
        - The recap is displayed in the console in the following format:
                - "Component details" on edge Ei (Nj -> Nk), where i is the edge index, 
                j is the index of the first node, and k is the index of the second node.

        Example:

        There are 4 components in the circuit:

            - "R1 = 10 [Ω]" on edge E1 (N1 -> N2)
            - "R2 = 20 [Ω]" on edge E2 (N2 -> N3)
            - "R3 = 30 [Ω]" on edge E3 (N3 -> N4)
            - "R4 = 40 [Ω]" on edge E4 (N4 -> N1)
        """
        function _components_recap(circuit)
                
            # Display a recap of the components in the circuit
            if isempty(circuit.components)  

                # If there are no components in the circuit, display a message to that effect.
                println("\nThere are no components in the circuit.")
            else

                # Otherwise, display the number of components in the circuit.
                println("\nThere are $(length(circuit.components)) components in the circuit:\n")
            
                # Display the details of each component in the circuit
                for comp in circuit.components  

                    # Display the details of the component in the format "Component details" on edge Ei (Nj -> Nk),
                    println("   - \"$(comp.details)\" on edge  E$(comp.id) (N$(comp.start_node) -> N$(comp.end_node))")
                end 
            end
        end
end
