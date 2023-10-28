# ==============================================================================
# ==============================================================================
# ======================== Module: HandlingSpecialInput ========================
# ==============================================================================
# ==============================================================================

"""
    Module: HandlingSpecialInput

Author: Michelangelo Dondi
Date: 28-10-2023
Description: 
    This module provides functions for handling special user input, such as
    'exit', 'help', 'recap', 'draw' and 'save'.

Version: 4.4
License: MIT License

Exported functions: 
- `handle_special_input_break(input::String)::Symbol`: Handles the followiing special 
    input from the user: 'exit', 'help', 'recap', 'draw', 'save' and 'break'.
- `handle_special_input_yes_no(input::String)::Symbol`: Handles the following special 
    input from the user: 'exit', 'help', 'recap', 'draw', 'save', 'yes', 'no'.
"""
module HandlingSpecialInput

    # ==============================================================================
    # ============================= Exported Functions =============================
    # ==============================================================================
        
        # Handles special input from the user ('exit, 'help', 'recap', 'draw', 'save', 'break')
        export handle_special_input_break

        # Handles special input from the user ('exit, 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel')
        export handle_special_input_break_modify_cancel

        # Handles special input from the user ('exit, 'help', 'recap', 'draw', 'save', 'yes', 'no')
        export handle_special_input_yes_no

    # ==============================================================================
    # ============================== Included Modules ==============================
    # ==============================================================================

        # Module Helping provides helper functions for the main program.
        include("helping.jl")
        using .Helping: show_help # Help and instructions

        # Module CircuitRecap provides auxiliary functions for recapping the circuit.
        include("circuit_recap.jl")
        using .CircuitRecap: show_circuit_recap # Recap the circuit
        
        # Module Plotting provides functions for drawing the current circuit plot.
        include("plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot

        # Module Saving provides functions for saving the plot displayed.
        include("saving.jl")
        using .Saving: save_plot_displayed # Save the plot displayed
        
    # ==============================================================================
    # === Function: handle_special_input_break(input::String, circuit, edgeinfo)::Symbol ===
    # ==============================================================================

        """
            handle_special_input_break(input::String, circuit, edgeinfo)::Symbol

        Handles the following special input from the user:
        'exit', 'help', 'recap', 'draw', 'save' and 'break'.

        Parameters:
        - input: The input provided by the user.

        Returns:
        - :handled if the input was handled.
        - :break if the user types 'break' or 'b'.
        - :not_handled otherwise.
        """
        function handle_special_input_break(input::String, circuit, edgeinfo)::Symbol

            # Checking if the input is a special input
            result = _handle_special_input(input, circuit, edgeinfo)
            
            # If the input was handled, return the result.
            if result == :handled
                return :handled

            # If the user types 'break' or 'b', return :break.
            elseif input == "break" || input == "b"
                return :break
                    
            # If the input was not handled, return :not_handled.
            else
                return :not_handled
            end
        end
        
    # ==============================================================================
    # === Function: handle_special_input_break_modify_cancel(input::String, circuit, edgeinfo)::Symbol ===
    # ==============================================================================

        """
            handle_special_input_break_modify_cancel(input::String, circuit, edgeinfo)::Symbol

        Handles the following special input from the user:
        'exit', 'help', 'recap', 'draw', 'save', 'break', 'modify', 'cancel'.

        Parameters:
        - input: The input provided by the user.

        Returns:
        - :handled if the input was handled.
        - :break if the user types 'break' or 'b'.
        - :modify if the user types 'modify' or 'm'.
        - :cancel if the user types 'cancel' or 'c'.
        - :not_handled otherwise.
        """
        function handle_special_input_break_modify_cancel(input::String, circuit, edgeinfo)::Symbol

            # Checking if the input is a special input
            result = _handle_special_input(input, circuit, edgeinfo)

            # If the input was handled, return the result.
            if result == :handled
                return :handled
                
            # If the user types 'break' or 'b', return :break.
            elseif input == "break" || input == "b"
                return :break   
                
            # If the user types 'modify' or 'm', return :modify.
            elseif input == "modify" || input == "m"
                return :modify

            # If the user types 'cancel' or 'c', return :cancel.
            elseif input == "cancel" || input == "c"
                return :cancel
            
            # If the input was not handled, return :not_handled.
            else
                return :not_handled
            end
        end

    # ==============================================================================
    # === Function handle_special_input_yes_no(input::String, circuit, edgeinfo)::Symbol ===
    # ==============================================================================

        """
            handle_special_input_yes_no(input::String, circuit, edgeinfo)::Symbol

        Handles the following special input from the user:
        'exit', 'help', 'recap', 'draw', 'save', 'break', 'yes', 'no'.    

        Parameters:
        - input: The input provided by the user.

        Returns:
        - :handled if the input was handled.
        - :yes if the user types 'yes' or 'y'.
        - :no if the user types 'no' or 'n'.
        - :not_handled otherwise.
        """
        function handle_special_input_yes_no(input::String, circuit, edgeinfo)::Symbol
            
            # Checking if the input is a special input
            result = _handle_special_input(input, circuit, edgeinfo)

            # If the input was handled, return :handled.
            if result == :handled
                return :handled

            # If the user types 'yes or 'y', return :yes.
            elseif input == "yes" || input == "y"
                return :yes
            
            # If the user types 'no' or 'n', return :no.
            elseif input == "no" || input == "n"
                return :no
        
            # If the input was not handled, return :not_handled.
            else
                return :not_handled
            end
        end

    # ==============================================================================
    # --- Function: _handle_special_input(input::String, circuit, edge_info)::Symbol ---
    # ==============================================================================

        """
            _handle_special_input(input::String, circuit, edge_info)::Symbol

        Handles the following special input from the user:
        'exit', 'help', 'recap', 'draw', 'save'.

        Parameters:
        - input: The input provided by the user.
        - circuit: The circuit object.

        Returns:
        - :handled if the input was handled.
        - :not_common_special_input otherwise.
        """
        function _handle_special_input(input::String, circuit, edge_info)::Symbol

            # If the user types 'exit' or 'e', exit the program.
            if input == "exit" || input == "e"
                println("Exiting the program.")
                exit(0)

            # If the user types 'help' or 'h', show the help message.
            elseif input == "help" || input == "h"
                show_help()
                return :handled
            
            # If the user types 'recap' or 'r', show the recap message.
            elseif input == "recap" || input == "r"
                show_circuit_recap(circuit, edge_info)
                return :handled
        
            # If the user types 'draw' or 'd', draw the current plot.
            elseif input == "draw" || input == "d"
                draw_plot(circuit)
                return :handled
            
            # If the user types 'save' or 's', save the current plot.
            elseif input == "save" || input == "s"
                save_plot_displayed(circuit)
                return :handled
            
            # If the input was not handled, return :not_common_special_input.
            else
                return :not_common_special_input
            end
        end
end