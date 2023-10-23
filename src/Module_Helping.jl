# =================================================================================
# =================================================================================
# =============================== Helping_Module.jl ===============================
# =================================================================================
# =================================================================================

"""
    Module: Helping 

Author: Michelangelo Dondi
Date: 3.1-10-2023
Description:
    Dedicated to providing guidance to users interacting with the Circuit Plotter Program.
    This module simplifies user interactions by offering clear instructions and comprehensive assistance.

Version: 3.1
License: MIT License

Exported functions:
- `show_initial_greetings()`: Presents the welcoming message and initial instructions.
- `show_help()`: Delivers an in-depth guide on the program's usage.
"""
module Helping

    # ==============================================================================
    # ============================ Exported Functions ==============================
    # ==============================================================================
        
        # Invoke these function to show greetings and instructions
        export show_initial_greetings

        # Invoke these functions to obtain help and instructions
        export show_help

        # Invoke these function to show final greetings and whether to save the plot displayed before exiting the program
        export show_final_greetings_asking_whether_to_save_plot_displayed

    # ==============================================================================
    # ========================= Imported Data Structure ============================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit

    # ==============================================================================
    # =========================== show_initial_greetings ===========================
    # ==============================================================================
            
        """
            show_initial_greetings() -> nothing

        Presents the welcoming message and initial instructions.

        Parameters:
        - nothing
            
        Returns:
        - nothing
        """
        function show_initial_greetings()
            println("""
            \n---------------------------------------------------
                  Welcome to the Circuit Plotter Program!
            ---------------------------------------------------
            """)
            _show_instructions()
            println("Start creating your circuit now!")
        end
    
    # ==============================================================================
    # ================================ show_help ===================================
    # ==============================================================================
        
        """
            show_help() -> nothing

        Provides an extensive guide detailing each aspect of the Circuit Plotter Program.

        Parameters:
        - nothing
            
        Returns:
        - nothing
        """
        function show_help()
            println("""
            \n---------------------------------------------------
                                    HELP
            ---------------------------------------------------

            INTRODUCTION:
            - Create visual representations of circuits.
            - The program is interactive and user-friendly.
            - The program is designed primary for electrical circuits.
            - However, it can be used for any type of circuit.
            - Input nodes, edges, and component details following the prompts.

            NODE COORDINATES:
            - Ensure coordinates are integer numbers.

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
            - You will be asked whether to save the plot before continuing.
            - Completed visuals are saved in the 'Images' directory.
            - Visuals are saved as "circuit_plot.png" by default.
            """)
            _show_instructions()

            println("""
            \n---------------------------------------------------
                                END OF HELP 
            ---------------------------------------------------
            """)
        end

    # ==========================================================================
    # ------------------------- _show_instructions -------------------------
    # ==========================================================================
            
        """
            _show_instructions() -> nothing

        Displays the general instructions for the Circuit Plotter Program.
        Includes general usage notes and common commands.
            
        Parameters:
        - nothing
            
        Returns:
        - nothing
        """
        function _show_instructions()
            println("""
            \n---------------------------------------------------
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
            """)
        end
    
    # ==========================================================================
    # --- function show_final_greetings_asking_whether_to_save_plot_displayed --
    # ==========================================================================
            
        """
        show_final_greetings_asking_whether_to_save_plot_displayed(circuit::Circuit) -> nothing

        Displays the final greetings and ask the user whether to save the plot displayed before exiting the program.

            
        Parameters:
        - circuit: The primary data structure representing the circuit, including its nodes and components.
            
        Returns:
        - nothing
        """
        function show_final_greetings_asking_whether_to_save_plot_displayed(circuit::Circuit)
            
            # Ask the user whether to save the plot displayed before exiting the program.
            println("Type 'save' or 's' to save the plot of your circuit before exiting the program.")
            println("If you do not want save if, press any other key to directly exit the program")
            input = readline()
            if input == "save" || input == "s"
                save_plot_displayed(circuit)
            end

            # Exit the program after the user presses Enter.
            println("""
            Thank you for having used the Circuit Plotter Program.
            We hope you have found it useful and that you will use it again in the future.
            The program will now exit in 5 seconds.
            \n---------------------------------------------------
                                END OF PROGRAM
            ---------------------------------------------------
            """)
            sleep(5)
        end
end