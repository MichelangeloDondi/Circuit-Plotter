# ============================================================================
# ============================================================================
# ======================== Module: CheckingNodesInput ========================
# ============================================================================
# ============================================================================

"""
    Module: CheckingNodesInput 

This module contains the function for checking if the input aimed to add a new node is valid.

# Author: Michelangelo Dondi

# Date: 29-10-2023

# Version: 4.7

# License: MIT License 

# Required packages: 
    - none

# Included modules: 
    - 'DataStructure': Provides the data structures used by the Circuit Plotter Program.

# Submodules: 
    - 'InputFormatCheck': Checks if the input is in the format 'integer x,y' (e.g. '1,-2').
    - 'Coordinate_AvailabilityCheck': Checks if no node already exists at the provided coordinates.

# Exported functions:
    - 'check_if_input_is_valid(input::String, circuit::Circuit)::Bool': Checks if the input is valid. 
        The input is valid if it is in the format 'integer x,y' (e.g. '1,-2') and if no node already 
        exists at the provided coordinates.

# When are the exported functions invoked?
    - Function 'check_if_input_is_valid(input::String, circuit::Circuit)::Bool' is invoked by 
        function 'process_input' in Module GatheringNodes.
    - Function 'check_if_input_is_valid(input::String, circuit::Circuit)::Bool' is invoked by 
        function 'process_input' in Module ModifyingNodes.

# Notes:
    - Function 'check_if_input_is_valid(input::String, circuit::Circuit)::Bool' is the primary function 
        for checking if the input aimed to add a new node is valid.
"""
module CheckingNodesInput

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================
        
        # Invoke the function to check if the input of the coordinates of the new node is valid.
        export check_if_input_is_valid
    
    # ==============================================================================
    # ============================ Included Modules ================================
    # ==============================================================================

        # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
        include("../../data_structure.jl")
        using .DataStructure: Node, Circuit # Access the data structures

    # ==============================================================================
    # ====== Function: check_if_input_is_valid(input::String, circuit)::Bool =======
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
            
        # Function logic:
            - Check if the input is in the format 'integer x,y' (e.g. '1,-2').
            - If the input is in the format 'integer x,y' (e.g. '1,-2'), check if the coordinates are available.
            - If the input is in the format 'integer x,y' (e.g. '1,-2') and if the coordinates are available, return true.
            - If the input is not in the format 'integer x,y' (e.g. '1,-2') or if the coordinates are not available, return false.

        # When is this function invoked?
            - Function 'check_if_input_is_valid(input::String, circuit::Circuit)::Bool' is invoked by 
                function 'process_input' in Module GatheringNodes.
            - Function 'check_if_input_is_valid(input::String, circuit::Circuit)::Bool' is invoked by 
                function 'process_input' in Module ModifyingNodes.

        # Notes:
            - This function is exported.
            - This function is the primary function for checking if the input aimed to add a new node is valid.
        """
        function check_if_input_is_valid(input::String, circuit)::Bool

            println("\n\033[36mChecking if the input is valid...\033[0m")
            # Check if the input is valid format and if the input is valid free coordinates.
            if InputFormatCheck.is_valid_format(input) 

                # If the input is valid format, print a message and check if the input is valid free coordinates.
                println("\033[32mThe input is in the correct format. \n\033[36mChecking if the coordinates are available...\033[0m")
                
                # If the input is valid format, check if the input is valid free coordinates.
                if CoordinateAvailabilityCheck.is_coordinate_available(input, circuit)

                    # If the input is valid format and if the input is valid free coordinates, return true.
                    println("\033[32mThe coordinates are available.\033[0m")   
                    return true
                else
                    
                    # If the input is valid format but if the input is not valid free coordinates, return false.
                    println("\033[31mThe coordinates are not available.\033[0m")
                    return false
                end                
            else
                    
                # If the input is not in the format 'integer x,y' (e.g. '1,-2'), print an error message and return false.
                println("\n\033[31mInvalid input: you are not providing a pair of integer numbers.") 
                println("\033[36mEnter integer coordinates as 'x,y' (e.g. '1,-2').\033[0m")                
                return false
            end
        end
        
    # ==============================================================================
    # ==============================================================================
    # ----------------------- Submodule: InputFormatCheck --------------------------
    # ==============================================================================
    # ==============================================================================

        """
            Submodule: InputFormatCheck

        This submodule contains the function for checking if the input is in the format 'integer x,y' (e.g. '1,-2').
            
        # Author: Michelangelo Dondi

        # Date: 29-10-2023
        
        # Version: 4.7
        
        # License: MIT License 

        # Required packages: 
            - none
        
        # Included modules: 
            - none
        
        # Exported functions:
            - 'is_valid_format(input::String)::Bool': Checks if the input is in the format 'integer x,y' (e.g. '1,-2').

        # When is the exported function invoked?
            - Function 'is_valid_format(input::String)::Bool' is invoked by function `check_if_input_is_valid` in module 'CheckingNodesInput'.
            - Function 'is_valid_format(input::String)::Bool' is invoked by function `test_is_valid_format()` in module 'TestCheckIfInputIsValid'.
            
        # Notes:
            - This module is a submodule of module 'CheckingNodesInput'.
            - Function 'is_valid_format(input::String)::Bool' is invoked before the node is added to the circuit by function `_add_node_to_circuit`.
        """
        module InputFormatCheck

            # ==============================================================================
            # =========================== Exported Function ================================
            # ==============================================================================
                
                # Invoke the function to check if the input is in the format 'integer x,y' (e.g. '1,-2').
                export is_valid_format

            # ==============================================================================
            # =============== Function: is_valid_format(input::String)::Bool ===============
            # ==============================================================================

                """
                    is_valid_format(input::String)::Bool

                Checks if the input is in the format 'integer x,y' (e.g. '1,-2').

                # Parameters:
                    - input: The input provided by the user.
                    
                # Returns:
                    - true if the input is in the format 'integer x,y' (e.g. '1,-2').
                    - false otherwise.

                # Function logic:
                    - Try to parse the coordinates as integers.
                    - If the input is in the format 'integer x,y' (e.g. '1,-2'), return true.
                    - If the input is not in the format 'integer x,y' (e.g. '1,-2'), return false.
                    
                # When is this function invoked?
                    - Function 'is_valid_format(input::String)::Bool' is invoked by function `check_if_input_is_valid` in module 'CheckingNodesInput'.
                    - Function 'is_valid_format(input::String)::Bool' is invoked by function `test_is_valid_format()` in module 'TestCheckIfInputIsValid'.  
                    
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

                            # If the input is not in the format 'integer x,y' (e.g. '1,-2'), return false.
                            return false
                        else

                            # Parse the coordinates as integers.
                            x, y = parse(Int, coords[1]), parse(Int, coords[2])
                            
                            # If the input is in the format 'integer x,y' (e.g. '1,-2'), return true.
                            return true
                        end
                    catch

                        # If the input is not in the format 'integer x,y' (e.g. '1,-2'), return false.
                        return false
                    end
                end
        end

    # ==============================================================================
    # ==============================================================================
    # ------------------ Submodule: CoordinateAvailabilityCheck --------------------
    # ==============================================================================
    # ==============================================================================
    
    """
        Submodule: CoordinateAvailabilityCheck

    This submodule contains the function for checking if the coordinates are available.
    
    # Author: Michelangelo Dondi

    # Date: 29-10-2023
    
    # Version: 4.7
    
    # License: MIT License 

    # Required packages: 
        - none
    
    # Included modules: 
        - 'DataStructure': Provides the data structures used by the Circuit Plotter Program.

    # Exported functions:
        - 'is_coordinate_available(input::String, circuit::Circuit)::Bool': Checks if the coordinates are available.
            The coordinates are available if no node already exists at the provided coordinates.

    # When are the exported functions invoked?
        - Function 'is_coordinate_available(input::String, circuit::Circuit)::Bool' is invoked by function `check_if_input_is_valid` in module 'CheckingNodesInput'.
        - Function 'is_coordinate_available(input::String, circuit::Circuit)::Bool' is invoked by function `test_is_coordinate_available()` in module 'TestCheckIfInputIsValid'.

    # Notes:
        - This module is a submodule of module 'CheckingNodesInput'.
    """
    module CoordinateAvailabilityCheck

        # ==============================================================================
        # =========================== Exported Function ================================
        # ==============================================================================

            # Invoke the function to check if the coordinates are available.
            export is_coordinate_available

        # ==============================================================================
        # ============================ Included Modules ================================
        # ==============================================================================

            # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
            include("../../data_structure.jl")
            using .DataStructure: Node, Circuit # Access the data structures

        # ==============================================================================
        # === Function: is_coordinate_available(input::String, circuit::Circuit)::Bool ===
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
                
            # Function logic:   
                - Split the input into its x and y coordinates.
                - Parse the coordinates as integers.
                - Iterate over the nodes in the circuit.
                - If a node already exists at the provided coordinates, print an error message and return false.
                - If no node already exists at the provided coordinates, return true.

            # When is this function invoked?
                - Function 'is_coordinate_available(input::String, circuit::Circuit)::Bool' is invoked by function `check_if_input_is_valid` in module 'CheckingNodesInput'.
                - Function 'is_coordinate_available(input::String, circuit::Circuit)::Bool' is invoked by function `test_is_coordinate_available()` in module 'TestCheckIfInputIsValid'.

            # Notes:
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
                        println("\n\033[31mThe node coordinates you have inserted cannot be accepted for the following reason:")
                        println("\033[33mNode N",node.id," already exists at position ($x,$y).\033[0m\n")
                        return false
                    end
                end

                # If no node already exists at the provided coordinates, return true.
                return true
            end
    end
end
