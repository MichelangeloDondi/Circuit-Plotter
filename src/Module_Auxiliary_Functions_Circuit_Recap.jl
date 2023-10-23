# ==============================================================================
# ==============================================================================
# =================== Module_Auxiliary_Functions_Recap.jl ======================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Recap

Author: Michelangelo Dondi
Date: 23-10-2023
Description: 
    Dedicated to providing auxiliary functions for recapping the circuit. 
    This module simplifies the recap process by providing a single file to call.    
 
Version: 2.8
License: MIT License

Exported functions: 
- `show_circuit_recap(circuit::Circuit, edge_info::EdgeInfo)`: Displays a recap 
of the circuit in the console. The recap includes a summary of the nodes, edges,
and components present within the circuit.

Notes:
- The recap is displayed in the console in the following format:
    - Nodes in the Circuit:
        - Ni at (xi,yi), where i is the index of the node.
    - Edges in the Circuit:
        - Ei: Nj -> Nk, where i is the edge index, j is the index of the first node, 
        and k is the index of the second node.
    - Components in the Circuit:
        - "Component details" on edge Ei (Nj -> Nk), where i is the edge index, 
        j is the index of the first node, and k is the index of the second node.

Example:

---------------------------------------------------
Begin of circuit recap
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
End of circuit recap
---------------------------------------------------
"""
module Auxiliary_Functions_Circuit_Recap

    # ==============================================================================
    # ============================== Exported Function =============================
    # ==============================================================================
            
        # Invoke this function to export the recap function
        export show_circuit_recap

    # ==============================================================================
    # =========================== Imported Data Structure ==========================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit, EdgeInfo

    # ==============================================================================
    # ======================== function show_circuit_recap =========================
    # ==============================================================================
        
        function show_circuit_recap(circuit::Circuit, edge_info::EdgeInfo)

            println("\n---------------------------------------------------")
            println("BEGIN OF CIRCUIT RECAP")
            println("---------------------------------------------------\n")

            # Display a recap of the nodes in the circuit
            _nodes_recap(circuit)
                
            # Display a recap of the edges in the circuit
            _edges_recap(edge_info)

            # Display a recap of the components in the circuit
            _components_recap(circuit)  

            println("\n---------------------------------------------------")
            println("ENE OF CIRCUIT RECAP")
            println("---------------------------------------------------\n")
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
        - If there are no nodes in the circuit, a message to that effect is displayed.
        - The recap is displayed in the console in the following format:
            - Ni at (xi,yi), where i is the index of the node.
        Example:

        There are 4 nodes in the circuit:

            - N1 at (0,0)
            - N2 at (0,1)
            - N3 at (1,0)
            - N4 at (1,1)

        ---------------------------------------------------
        """
        function _nodes_recap(circuit::Circuit)

            # Display a recap of the nodes in the circuit
            if isempty(circuit.nodes)   

                # If there are no nodes in the circuit, display a message to that effect.
                println("\nThere are no nodes in the circuit.")
            else    

                # Otherwise, display the number of nodes in the circuit.
                println("\nThere are $(length(circuit.nodes)) nodes in the circuit:\n")

                # Display the details of each node in the circuit
                for node in circuit.nodes

                    # Display the details of the node in the format Ni at (xi,yi), where i is the index of the node.
                    println("   - N$(node.id) at ($(node.x),$(node.y))")
                end
            end
            println("\n---------------------------------------------------")
        end
    
    # ==============================================================================
    # --------------------------- function _edges_recap ----------------------------
    # ==============================================================================

        """
            _edges_recap(edge_info::EdgeInfo) -> nothing

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

        ---------------------------------------------------
        """ 
        function _edges_recap(edge_info::EdgeInfo)
            
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
            println("\n---------------------------------------------------")
        end

    # ==============================================================================
    # -------------------------- function _component_recap -------------------------
    # ==============================================================================

        """
            _components_recap(circuit::Circuit) -> nothing

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
        function _components_recap(circuit::Circuit)
                
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
