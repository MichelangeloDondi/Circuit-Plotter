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
- `handle_special_input_stop(input::String)::Symbol`: Handles special input from the user. 
    Special input includes commands such as 'exit', 'help', 'draw', and 'stop'.
- `handle_special_input_yn(input::String)::Symbol`: Handles special input from the user.
    Special input includes commands such as 'exit', 'help', 'draw', 'n', and 'y'.
"""
module Auxiliary_Functions_Handle_Special_Input

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================
        
        # Handles special input from the user (e.g. 'help', 'draw', 'exit', 'stop').
        export handle_special_input_stop
        export handle_special_input_yn

    # ==============================================================================
    # ============================ Included Modules ================================
    # ==============================================================================

        # Module_Helping.jl provides helper functions for the main program.
        include("Module_Helping.jl")
        using .Helping: show_help # Help and instructions

        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot

        # Module_Saving.jl provides functions for saving the current plot.
        include("Module_Saving.jl")
        using .Saving: save_current_plot # Save the current plot

    # ==============================================================================
    # =================== function handle_special_input_stop =======================
    # ==============================================================================

        """
            handle_special_input_stop(input::String)::Symbol

        Handles special input from the user. 
        Special input includes commands such as
        'exit', 'help', 'draw', and 'stop'.

        Parameters:
        - input: The input provided by the user.

        Returns:
        - :handled if the input was handled.
        - :stop if the user types 'stop'.
        - :not_handled otherwise.
        """
        function handle_special_input_stop(input::String, circuit)::Symbol

            # Checking if the input is a special input
            result = _handle_special_input(input, circuit)

            # Handle specific commands for this function
            if input == "stop"
                return :stop
            elseif result != :not_handled_yet
                return result
            end

            return :not_handled
        end
    
    # ==============================================================================
    # ==================== function handle_special_input_yn ========================
    # ==============================================================================

        """
            handle_special_input_yn(input::String)::Symbol

        Handles special input from the user. 
        Special input includes commands such as
        'exit', 'help', 'draw', 'n', and 'y'.

        Parameters:
        - input: The input provided by the user.

        Returns:
        - :handled if the input was handled.
        - :y if the user types 'y'.
        - :not_handled otherwise.
        """
        function handle_special_input_yn(input::String, circuit)::Symbol
            
            # Checking if the input is a special input
            result = _handle_special_input(input, circuit)

            # Handle specific commands for this function
            if input == "n"
                return :handled
            elseif input == "y"
                return :y
            elseif result != :not_handled_yet
                return result
            end

            return :not_handled
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
        - :not_handled_yet otherwise.
        """
        function _handle_special_input(input::String, circuit)

            # If the user types 'exit', exit the program.
            if input == "exit"
                println("Exiting the program.")
                exit(0)

            # If the user types 'help', show the help message.
            elseif input == "help"
                show_help()
                return :handled
            
            # If the user types 'draw', draw the current plot.
            elseif input == "draw"
                draw_plot(circuit)
                return :handled
                
            # If the user types 'save', save the current plot.
            elseif input == "save"
                save_current_plot()
                return :handled
            
            # If the input was not handled, return :not_handled.
            else
                return :not_handled_yet
            end
        end
end
