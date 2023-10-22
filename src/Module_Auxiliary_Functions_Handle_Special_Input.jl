# ==============================================================================
# ==============================================================================
# =============== Module_Auxiliary_Functions_Input_Handling.jl =================
# ==============================================================================
# ==============================================================================

"""
    Module Auxiliary_Functions_Input_Handling

Author: Michelangelo Dondi
Date: 22-10-2023
Description: 
    This module provides functions for handling special user input, such as
    'exit', 'help', 'draw' and 'save'.

Version: 2.7
License: MIT License

Exported functions: 
- `handle_special_input_break(input::String)::Symbol`: Handles special input from the user. 
    Special input includes commands such as 'exit', 'help', 'draw', 'save' and 'break'.
- `handle_special_input_yes_no(input::String)::Symbol`: Handles special input from the user.
    Special input includes commands such as 'exit', 'help', 'draw', 'save', 'yes' and 'no'.
"""
module Auxiliary_Functions_Handle_Special_Input

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================
        
        # Handles special input from the user (e.g. 'exit, 'help', 'draw', 'save').
        export handle_special_input_break
        export handle_special_input_yes_no

    # ==============================================================================
    # ============================ Included Modules ================================
    # ==============================================================================

        # Module_Helping.jl provides helper functions for the main program.
        include("Module_Helping.jl")
        using .Helping: show_help # Help and instructions

        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot

        # Module_Saving.jl provides functions for saving the current circuit plot.
        include("Module_Saving.jl")
        using .Saving: save_current_plot # Save the current circuit plot
        
    # ==============================================================================
    # =================== function handle_special_input_break ======================
    # ==============================================================================

        """
            handle_special_input_break(input::String)::Symbol

        Handles special input from the user. 
        Special input includes commands such as
        'exit', 'help', 'draw', 'save' and 'break'.

        Parameters:
        - input: The input provided by the user.

        Returns:
        - :handled if the input was handled.
        - :break if the user types 'break' or 'b'.
        - :not_handled otherwise.
        """
        function handle_special_input_break(input::String, circuit)::Symbol

            # Checking if the input is a special input
            result = _handle_special_input(input, circuit)

            # If the user types 'break' or 'b', return :break.
            if input == "break" || input == "b"
                return :break
                
            # If the input was handled, return the result.
            elseif result == :handled
                return :handled
            
            # If the input was not handled, return :not_handled.
            else
                return :not_handled
            end
        end
    
    # ==============================================================================
    # ================== function handle_special_input_yes_no ======================
    # ==============================================================================

        """
            handle_special_input_yes_no(input::String)::Symbol

        Handles special input from the user. 
        Special input includes commands such as
        'exit', 'help', 'draw', 'save' 'yes', and 'no'.

        Parameters:
        - input: The input provided by the user.

        Returns:
        - :handled if the input was handled.
        - :yes if the user types 'yes' or 'y'.
        - :no if the user types 'no' or 'n'.
        - :not_handled otherwise.
        """
        function handle_special_input_yes_no(input::String, circuit)::Symbol
            
            # Checking if the input is a special input
            result = _handle_special_input(input, circuit)

            # If the user types 'yes or 'y', return :yes.
            if input == "yes" || input == "y"
                return :yes
            
            # If the user types 'no' or 'n', return :no.
            elseif input == "no" || input == "n"
                return :no
            
            # If the input was handled, return :handled.
            elseif result == :handled
                return :handled
        
            # If the input was not handled, return :not_handled.
            else
                return :not_handled
            end
        end

    # ==============================================================================
    # ----------------------- function _handle_special_input -----------------------
    # ==============================================================================

        """
            _handle_special_input(input::String, circuit)

        Handles the common special input commands shared between multiple functions.

        Parameters:
        - input: The input provided by the user.
        - circuit: The circuit object.

        Returns:
        - :handled if the input was handled.
        - :not_common_special_input otherwise.
        """
        function _handle_special_input(input::String, circuit)

            # If the user types 'exit' or 'e', exit the program.
            if input == "exit" || input == "e"
                println("Exiting the program.")
                exit(0)

            # If the user types 'help' or 'h', show the help message.
            elseif input == "help" || input == "h"
                show_help()
                return :handled
            
            # If the user types 'draw' or 'd', draw the current plot.
            elseif input == "draw" || input == "d"
                draw_plot(circuit)
                return :handled
            
            # If the user types 'save' or 's', save the current plot.
            elseif input == "save" || input == "s"
                save_current_plot()
                return :handled
            
            # If the input was not handled, return :not_common_special_input.
            else
                return :not_common_special_input
            end
        end
end
