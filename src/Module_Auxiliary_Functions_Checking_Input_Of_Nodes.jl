# ============================================================================
# ============================================================================
# ========== Module_Auxiliary_Functions_Checking_Input_Of_Nodes.jl ===========
# ============================================================================
# ============================================================================

"""
    Module: Auxiliary_Functions_Checking_Input_Of_Nodes  

Author: Michelangelo Dondi
Date: 27-10-2023
Description: This module contains the function for checking if the input aimed to add a new node is valid.

Version: 3.5
License: MIT License 

Exported functions:
- 'check_if_inupt_is_valid(input::String, circuit::Circuit)::Bool': Checks if the input is valid. 
The input is valid if it is in the format 'integer x,y' (e.g. '1,-2') and if no node already exists
at the provided coordinates.

Notes:
- This module is called by 'Module_Gathering_Nodes.jl'
- This module is called by 'Module_Auxiliary_Functions_Modifying.jl'
"""

module Auxiliary_Functions_Checking_Input_Of_Nodes

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================
        
        # Invoke the function to check if the input is valid.
        export check_if_inupt_is_valid
    
    # ==============================================================================
    # ============================ Included Modules ================================
    # ==============================================================================

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: Node # Access the data structures

    # ==============================================================================
    # ====================== function check_if_inupt_is_valid ======================
    # ==============================================================================

        """
            check_if_inupt_is_valid(input::String, circuit)::Bool  

        Checks if the input is valid. The input is valid if it is in the format 'integer x,y' (e.g. '1,-2') 
        and if no node already exists at the provided coordinates.

        # Parameters:
        - input: The input provided by the user.
        - circuit: The primary data structure representing the circuit, including its nodes and components.
            
        # Returns:
        - true if the input is valid.
        - false otherwise.
            
        # Notes:
        - This function is called by `process_input`.
        - This function is called before the node is added to the circuit by `_add_node_to_circuit`.
            
        # Examples:
        ```julia-repl   
        julia> _check_if_inupt_is_valid("1,-2", circuit)
        true
        """
        function check_if_inupt_is_valid(input::String, circuit)::Bool

            # Try to parse the coordinates as integers.
            try 
                            
                # Split the input into its x and y coordinates.
                coords = split(input, ",")

                # Parse the coordinates as integers.
                x, y = parse(Int, coords[1]), parse(Int, coords[2])
                
                # Check if a node already exists at the provided coordinates.
                for node in circuit.nodes

                    # If a node already exists at the provided coordinates, print an error message and return false.
                    if node.x == x && node.y == y   

                        # Provide feedback to the user and return false.
                        println("\nThe node coordinates you have inserted cannot be accepted for the following reason:")
                        println("Node N",node.id," already exists at position ($x,$y).")
                        return false
                    end
                end

                # If no node already exists at the provided coordinates, return true.
                return true
            catch

                # If the coordinates couldn't be parsed as integers, print an error message and return false.
                println("\nInvalid input. Enter integer coordinates as 'x,y' (e.g. '1,-2').")
                return false
            end
        end
    end