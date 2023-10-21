# ==============================================================================
# ==============================================================================
# =============== Module_Auxiliary_Functions_Input_Handling.jl =================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Input_Handling

Author: Michelangelo Dondi
Date: 21-10-2023
Description: 
    This module provides functions for handling special user input, such as
    'help', 'draw', 'exit', and 'stop'.

Version: 2.7
License: MIT License

Exported functions: 
    - handle_special_input: Handles special input from the user (e.g. 'help', 'draw', 'exit', 'stop').
"""
module Auxiliary_Functions_Handle_Special_Input

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================
        
        # Handles special input from the user (e.g. 'help', 'draw', 'exit', 'stop').
        export handle_special_input 

    # ==============================================================================
    # ============================ Included Modules ================================
    # ==============================================================================

        # Module_Helping.jl provides helper functions for the main program.
        include("Module_Helping.jl")
        using .Helping: show_help # Help and instructions

        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot

    # ==============================================================================
    # ===================== function handle_special_input =========================
    # ==============================================================================

        """
            handle_special_input(input::String)::Symbol

        Handles special input from the user. 
        Special input includes commands such as
        'help', 'draw', 'exit', and 'stop'.

        Parameters:
        - input: The input provided by the user.

        Returns:
        - :handled if the input was handled.
        - :stop if the stop command was invoked.
        - :not_handled otherwise.
        """
        function handle_special_input(input::String)::Symbol
            
            # If the user types 'help', show the help message.
            if input == "help"
                show_help()
                return :handled

            # If the user types 'draw', draw the current plot.
            elseif input == "draw"
                draw_plot(circuit)
                return :handled

            # If the user types 'exit', exit the program.
            elseif input == "exit"
                println("Exiting the program.")
                exit(0) 

            # If the user types 'stop', stop collecting nodes.
            elseif input == "stop"
                return :stop
            end

            # If the input was not handled, return :not_handled.
            return :not_handled
        end
end
