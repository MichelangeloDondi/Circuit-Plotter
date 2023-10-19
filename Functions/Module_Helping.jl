# =================================================================================
# =================================================================================
# =============================== Helping_Module.jl ===============================
# =================================================================================
# =================================================================================

"""
    Module: Helping 

Author: Michelangelo Dondi
Date: 19-10-2023
Description:
    Dedicated to providing guidance to users interacting with the Circuit Visualization Tool.
    This module simplifies user interactions by offering clear instructions and comprehensive assistance.

Version: 2.1
License: MIT License

Exported functions:
- `show_initial_greetings()`: Presents the welcoming message and initial instructions.
- `show_help()`: Delivers an in-depth guide on the program's usage.
"""
module Helping

    export show_initial_greetings, show_help

    # ==============================================================================
    # ================================== Exported Functions ====================================
    # ================================================================

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
            \n-----------------------------------------------
            Welcome to the Electrical Circuit Visualization Tool!
            Follow the prompts to construct and visualize your circuit.
            -----------------------------------------------
            """)
            _show_instructions()
            println("\nStart creating your circuit now!")
        end

        """
            show_help() -> nothing

        Provides an extensive guide detailing each aspect of the Circuit Visualization Tool.

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
            - Create visual representations of electrical circuits.
            - Input nodes, edges, and component details.

            NODE COORDINATES:
            - Ensure coordinates are integers.

            EDGES:
            - Edges link nodes by either their indexes or the nodes they connect to.
            - The system automatically manages reverse edges.

            COMPONENTS:
            - Attach components to circuit edges.
            - Without components, edges are merely wire sections.
            - Utilize dummy nodes for circuits requiring multiple components.

            VISUALIZATION:
            - Completed visuals are stored in the 'Images' directory.
            - Image filenames incorporate execution timestamp.

            """)
            _show_instructions()

            println("""
            \n---------------------------------------------------
                            END OF HELP
            ---------------------------------------------------
            """)
        end
    
    # ==============================================================================
    # ================================== Internal Functions ========================
    # ==============================================================================

        """
            _show_instructions() -> nothing

        Displays the general instructions for the Circuit Visualization Tool.
        Includes general usage notes and common commands.
            
        Parameters:
        - nothing
            
        Returns:
        - nothing
        """
        function _show_instructions()
            println("""
            Instructions:
            1. Follow prompts to define nodes, edges, and circuit components.
            2. 'help' brings up instructions. 'exit' closes the program.
            Notes:
            - Visualizations are saved under 'Images'.
            - Filenames use current date and time for easy tracking.
            - For issues, please contact support.
            """)
        end
end