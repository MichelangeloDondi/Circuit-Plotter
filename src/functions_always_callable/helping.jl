# =================================================================================
# =================================================================================
# ================================ Module: Helping ================================
# =================================================================================
# =================================================================================

"""
    Module: Helping 

Dedicated to providing guidance to users interacting with the Circuit Plotter Program.
This module simplifies user interactions by offering clear instructions and comprehensive assistance.

# Author: Michelangelo Dondi

# Date: 29-10-2023

# Version: 4.7

# License: MIT License

# Included modules:
    - 'DataStructure' provides the data structures used by the Circuit Plotter Program.
    - 'Saving provides' functions for plotting the circuit.

# Required packages:
    - none

# Exported functions:
    - `show_initial_greetings()`: Presents the welcoming message and initial instructions.
    - `show_help()`: Delivers an in-depth guide on the program's usage.

# When are the exported functions invoked?
    - `show_initial_greetings()` is invoked by the function `main(circuit, edgeinfo)` in module `MainFunction`.
    - `show_help()` is invoked by the function `_handle_special_input` in module `HandlingSpecialInput`.
    - `show_final_greetings_asking_whether_to_save_plot_displayed(circuit)` is invoked by the function `main()` in module `MainFunction`.

# Notes:
    - This module is not intended to be used by the user.
    - This module is only used by the other modules in the program.
"""
module Helping

    # ==============================================================================
    # ============================= Exported Functions =============================
    # ==============================================================================
        
        # Invoke these function to show greetings and instructions
        export show_initial_greetings

        # Invoke thi function to obtain help and instructions
        export show_help

        # Invoke this function to show final greetings and whether to save the plot displayed before exiting the program
        export show_final_greetings_asking_whether_to_save_plot_displayed

    # ==============================================================================
    # ============================= Including Modules ==============================
    # ==============================================================================

        # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
        include("../data_structure.jl")
        using .DataStructure: Circuit # Access the data structures

        # Module 'Saving' provides functions for plotting the circuit.
        include("saving.jl")
        using .Saving: save_plot_displayed # Save the plot displayed

    # ==============================================================================
    # ===================== Function: show_initial_greetings() =====================
    # ==============================================================================
            
        """
            show_initial_greetings()

        Presents the welcoming message and initial instructions.

        Parameters:
        - nothing
            
        Returns:
        - nothing

        Notes:
        - This function is exported.
        - This function is called by the function 'main(circuit, edgeinfo)' in Module Main.
        """
        function show_initial_greetings()
            println("""\033[33m
            ---------------------------------------------------
                  Welcome to the Circuit Plotter Program!
            ---------------------------------------------------\033[0m
            """)
            _show_instructions()
            println("Start creating your circuit now!")
        end
    
    # ==============================================================================
    # ========================== Function: show_help() =============================
    # ==============================================================================
        
        """
            show_help() 

        Provides an extensive guide detailing each aspect of the Circuit Plotter Program.

        Parameters:
        - nothing
            
        Returns:
        - nothing

        Notes:
        - This function is exported.
        - This function is called by the function '_handle_special_input' in Module HandlingSpecialInput.
        """
        function show_help()
            println("""\033[33m
            \n---------------------------------------------------
                                    HELP
            ---------------------------------------------------

            INTRODUCTION:
            - Create visual representations of circuits.
            - The program is interactive and user-friendly.
            - The program is designed primary for electrical circuits.
            - However, it can be used for any type of circuit.
            - Input nodes, edges, and component details following the prompts.
            - The program will automatically render the circuit.

            NODE COORDINATES:
            - Ensure coordinates are integer numbers.
            - Ensure coordinates are separated by a comma.
            - Ensure coordinates are not already used by another node.

            EDGES:
            - Edges are links between 2 different nodes.
            - Edges are directed.
            - Edges are not allowed to overlap with other edges for a finite length.

            COMPONENTS:
            - Attach components to circuit edges. 
            - No more than one component is allowed for each edge.
            - Without components, edges are merely wire sections.
            - Utilize dummy nodes to add more components in a row.

            VISUALIZATION:
            - You can visualize the circuit at any time by entering 'draw'.
            - You will be asked whether to save the plot before exiting the program.
            - Completed visuals are saved in the 'circuit_drawings' directory.
            - Visuals are saved as "circuit_plot.png" by default.
            """)
            _show_instructions()

            println("""
            \n---------------------------------------------------
                                END OF HELP 
            ---------------------------------------------------\033[0m
            """)
        end

    # ==========================================================================
    # --------------------- Function: _show_instructions() ---------------------
    # ==========================================================================
            
        """
            _show_instructions() 

        Displays the general instructions for the Circuit Plotter Program.
        Includes common commands and general usage notes.
            
        Parameters:
        - nothing
            
        Returns:
        - nothing

        Notes:
        - This function is not exported.
        - This function is only used by the functions 'show_initial_greetings()' and 'show_help()'.
        """
        function _show_instructions()
            println("""\033[33m
            ---------------------------------------------------
                                INSTRUCTIONS
            ---------------------------------------------------

            General Usage:
            - Follow the prompts to create, visualize and save your circuit.
            - Enter 'exit'  or 'e' at any time to close the program.
            - Enter 'help'  or 'h' at any time to show the help.
            - Enter 'recap' or 'r' at any time to show the circuit recap.
            - Enter 'draw'  or 'd' at any time to render the circuit.
            - Enter 'save'  or 's' at any time to save the plot displayed

            Notes:
            - If there is an attempt to save a plot without displaying it first, the plot is displayed before saving.
            - For more information, please refer to the documentation.
            - For further issues, please contact support.

            ---------------------------------------------------
                            END OF INSTRUCTIONS
            ---------------------------------------------------\033[0m
            """)
        end
    
    # ==========================================================================
    # - Function: show_final_greetings_asking_whether_to_save_plot_displayed() -
    # ==========================================================================
            
        """
            show_final_greetings_asking_whether_to_save_plot_displayed(circuit)

        Shows the final greetings and asks the user whether to save the plot displayed before exiting the program.

        Parameters:
        - circuit: The circuit object.

        Returns:
        - nothing

        Notes:
        - This function is exported.
        - This function is only used by the function 'main()'.
        """
        function show_final_greetings_asking_whether_to_save_plot_displayed(circuit)
            
            # Ask the user whether to save the plot displayed before exiting the program.
            println("\n\033[36mType 'save' or 's' to save the plot of your circuit before exiting the program.")
            println("If you do not want save, press Enter or provide any other input to directly exit the program\033[0m")

            # Read the user input.
            input = readline()

            # If the user types 'save' or 's', save the current plot.
            if input == "save" || input == "s"  

                # Save the current plot.
                save_plot_displayed(circuit)
            end

            # Show the final greetings.
            println("""\033[33m
            Thank you for having used the Circuit Plotter Program.
            We hope you have found it useful and that you will use it again in the future. 
            
            The program will be quitted in 5 seconds.
            
            ---------------------------------------------------
                                END OF PROGRAM
            ---------------------------------------------------
            \033[0m""")
            
            # Exit the program after 5 seconds.
            sleep(5)
        end
end