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

Version: 2.2
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
            \n---------------------------------------------------
            Welcome to the Electrical Circuit Visualization Tool!
            Follow the prompts to construct and visualize your circuit.
            ---------------------------------------------------
            """)
            _show_instructions()
            println("Start creating your circuit now!")
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
            1. Define circuit nodes, edges and components.
            2. 'help' brings up instructions (type it at any time). 
            3. 'exit' closes the program (type it at any time).
        
            Notes:
            - For more information, please refer to the documentation.
            - For further issues, please contact support.
            """)
        end
end