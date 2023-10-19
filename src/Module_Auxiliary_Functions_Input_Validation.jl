# ==============================================================================
# ==============================================================================
# ============== Module_Auxiliary_Functions_Input_Validation.jl ================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Input_Validation

Author: Michelangelo Dondi
Date: 19-10-2023
Description: 
    Dedicated to housing the input validation functions used by the Circuit Visualization Tool.
    This module simplifies the input validation process by providing a single file to call.

Version: 2.2
License: MIT License

Exported functions:
- `get_positive_integer_input(prompt::String)`: Prompts the user for a positive integer input.
"""
module Auxiliary_Functions_Input_Validation

    # ==============================================================================
    # =========================== Exported Function ===============================
    # ==============================================================================
        
        # Invoke this function to obtain a positive integer input
        export get_positive_integer_input # User input validation

    # ==============================================================================
    # =========================== Imported Modules ===============================
    # ==============================================================================

        # For user assistance during input
        include("Module_Helping.jl")
        using .Helping: show_help

    # ==============================================================================
    # ========================= Input Validation Functions ==========================
    # ==============================================================================

        """

            get_positive_integer_input(prompt::String) -> Int

        Prompts the user for a positive integer input.

        Returns:
        - Int: the positive integer input   
        """
        function _get_input(prompt::String, validation::Function)
            while true
                print(prompt)
                flush(stdout)
                input = readline()
                if input == "help"
                    show_help()
                elseif input == "exit"
                    println("Exiting the program.")
                    exit(0)
                else
                    val = validation(input)
                    if val !== nothing
                        return val
                    end
                end
            end
        end


        """

            _validate_integer(input::String) -> Int

        Validates if `input` is a valid integer.

        Returns:
        - Int: the integer value of `input`
        - nothing: if `input` is not a valid integer
        """
        _validate_integer(input) = try parse(Int, input) catch nothing end

        """

            get_integer_input(prompt::String) -> Int

        Prompts the user for an integer input.

        Returns:
        - Int: the integer input
        """
        function get_integer_input(prompt::String)
            return _get_input(prompt, _validate_integer)
        end

        """

            get_positive_integer_input(prompt::String) -> Int

        Prompts the user for a positive integer input.  

        Returns:    
        - Int: the positive integer input
        """
        function get_positive_integer_input(prompt::String)
            val = get_integer_input(prompt)
            while val <= 0
                println("\nEnsure you are entering a positive integer.")
                val = get_integer_input(prompt)
            end
            return val
        end
end
