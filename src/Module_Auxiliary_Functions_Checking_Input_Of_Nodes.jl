# ============================================================================
# ============================================================================
# =========== Module: Auxiliary_Functions_Checking_Input_Of_Nodes ============
# ============================================================================
# ============================================================================

"""
    Module: Auxiliary_Functions_Checking_Input_Of_Nodes  

Author: Michelangelo Dondi
Date: 27-10-2023
Description: This module contains the function for checking if the input aimed to add a new node is valid.

Version: 3.7
License: MIT License 

Exported functions:
- 'check_if_input_is_valid(input::String, circuit::Circuit)::Bool': Checks if the input is valid. 
The input is valid if it is in the format 'integer x,y' (e.g. '1,-2') and if no node already exists
at the provided coordinates.

Submodules: 
- 'Input_Format_Check': Checks if the input is in the format 'integer x,y' (e.g. '1,-2').
- 'Coordinate_Availability_Check': Checks if no node already exists at the provided coordinates.

Notes:
- This module is called by 'Module_Gathering_Nodes.jl'
- This module is called by 'Module_Auxiliary_Functions_Modifying.jl'
"""
module Auxiliary_Functions_Checking_Input_Of_Nodes

    # ==============================================================================
    # =========================== Exported function ================================
    # ==============================================================================
        
        # Invoke the function to check if the input of the coordinates of the new node is valid.
        export check_if_input_is_valid
    
    # ==============================================================================
    # ============================ Included modules ================================
    # ==============================================================================

        # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
        include("Module_Circuit_Structures.jl")
        using .Circuit_Structures: Node, Circuit # Access the data structures

    # ==============================================================================
    # ====================== Function: check_if_input_is_valid =====================
    # ==============================================================================

        """
            check_if_input_is_valid(input::String, circuit)::Bool  

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
        true # If the input is valid.
        false # If the input is not valid.
        """
        function check_if_input_is_valid(input::String, circuit)::Bool

            # Check if the input is valid format and if the input is valid free coordinates.
            if Input_Format_Check.is_valid_format(input) 
                
                # If the input is valid format, check if the input is valid free coordinates.
                if Coordinate_Availability_Check.is_coordinate_available(input, circuit)

                    # If the input is valid, return true.    
                    return true
                else

                    # If the input is not valid, return false.
                    return false
                end
  
            end
        end
        
    # ==============================================================================
    # ==============================================================================
    # ---------------------- Submodule: Input_Format_Check -------------------------
    # ==============================================================================
    # ==============================================================================

    """
        Submodule: Input_Format_Check

    Description: This submodule contains the function for checking if the input is in the format 'integer x,y' (e.g. '1,-2').
        
    Exported functions:
    - 'is_valid_format(input::String)::Bool': Checks if the input is in the format 'integer x,y' (e.g. '1,-2').
        
    Notes:
    - This module is a submodule of 'Module_Auxiliary_Functions_Checking_Input_Of_Nodes.jl'.
    """
    module Input_Format_Check

        # ==============================================================================
        # =========================== Exported Function ================================
        # ==============================================================================
            
            # Invoke the function to check if the input is in the format 'integer x,y' (e.g. '1,-2').
            export is_valid_format

        # ==============================================================================
        # ====================== Function: is_valid_format =============================
        # ==============================================================================

            """
                is_valid_format(input::String)::Bool

            Checks if the input is in the format 'integer x,y' (e.g. '1,-2').

            # Parameters:
            - input: The input provided by the user.
                
            # Returns:
            - true if the input is in the format 'integer x,y' (e.g. '1,-2').
            - false otherwise.
                
            # Notes:
            - This function is called by `check_if_input_is_valid`.
            - This function is called before the node is added to the circuit by `_add_node_to_circuit`.
            """
            function is_valid_format(input::String)::Bool

                # Try to parse the coordinates as integers.
                try 
                                
                    # Split the input into its x and y coordinates.
                    coords = split(input, ",")

                    # Check if the input is in the format 'integer x,y' (e.g. '1,-2').
                    if length(coords) != 2

                        # If the input is not in the format 'integer x,y' (e.g. '1,-2'), print an error message and return false.
                        println("\nInvalid input: you are not providing a pair of numbers. Enter integer coordinates as 'x,y' (e.g. '1,-2').")
                        return false
                    else

                        # Parse the coordinates as integers.
                        x, y = parse(Int, coords[1]), parse(Int, coords[2])
                        
                        # Check if a node already exists at the provided coordinates.
                        return true
                    end
                catch

                    # If the coordinates couldn't be parsed as integers, print an error message and return false.
                    println("\nInvalid input. Enter integer coordinates as 'x,y' (e.g. '1,-2').")
                    return false
                end
            end
    end

    # ==============================================================================
    # ==============================================================================
    # ----------------- Submodule: Coordinate_Availability_Check -------------------
    # ==============================================================================
    # ==============================================================================
    
    """
        Submodule: Coordinate_Availability_Check

    Description: This submodule contains the function for checking if the coordinates are available.

    Exported functions:
    - '_is_coordinate_available(input::String, circuit::Circuit)::Bool': Checks if the coordinates are available.
    The coordinates are available if no node already exists at the provided coordinates.

    Notes:
    - This module is a submodule of 'Module_Auxiliary_Functions_Checking_Input_Of_Nodes.jl'.
    """
    module Coordinate_Availability_Check

        # ==============================================================================
        # =========================== Exported function ================================
        # ==============================================================================

            # Invoke the function to check if the coordinates are available.
            export is_coordinate_available

        # ==============================================================================
        # ============================ Included modules ================================
        # ==============================================================================

            # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
            include("Module_Circuit_Structures.jl")
            using .Circuit_Structures: Node, Circuit # Access the data structures

        # ==============================================================================
        # ===================== Function: _is_coordinate_available =====================
        # ==============================================================================

            """
                is_coordinate_available(input::String, circuit::Circuit)::Bool  

            Checks if the coordinates are available. The coordinates are available 
            if no node already exists at the provided coordinates.

            # Parameters:
            - input: The input provided by the user.
            - circuit: The primary data structure representing the circuit, including its nodes and components.
                
            # Returns:
            - true if no node already exists at the provided coordinates.
            - false otherwise (if a node already exists at the provided coordinates).
                
            # Notes:
            - This function is called by `check_if_input_is_valid`.
            - This function is called before the node is added to the circuit by `_add_node_to_circuit`.
            """
            function is_coordinate_available(input::String, circuit)::Bool

                # Split the input into its x and y coordinates.
                coords = split(input, ",")

                # Parse the coordinates as integers.
                x, y = parse(Int, coords[1]), parse(Int, coords[2])
                
                # Iterate over the nodes in the circuit.
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
            end
    end
end
