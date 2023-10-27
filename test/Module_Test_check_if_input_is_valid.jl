# ==============================================================================
# ==============================================================================
# ===================== Module_Test_check_if_input_is_valid.jl ========================
# ==============================================================================
# ==============================================================================

"""
    Module: Test_check_if_input_is_valid()

Author: Michelangelo Dondi
Date: 27-10-2023
Description: This module provides the function test_check_if_input_is_valid() which tests the function check_if_input_is_valid().

Version: 3.5
Licence: MIT Licence

Exported Function(s):
    test_check_if_input_is_valid() # Test if the input is valid
"""
module Test_check_if_input_is_valid

    # ==============================================================================
    # =========================== Exported Functions ===============================
    # ==============================================================================

        # Invokes the modify_existing_node function to modify an existing node's coordinates in the circuit.
        export test_check_if_input_is_valid

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        using Test

    # ==============================================================================
    # ============================ Including Modules ===============================
    # ==============================================================================

        # Module_Auxiliary_Functions_Checking_Input_Of_Nodes provides auxiliary functions for checking the input of nodes.
        include("../src/Module_Auxiliary_Functions_Checking_Input_Of_Nodes.jl")
        using .Auxiliary_Functions_Checking_Input_Of_Nodes # Check if the node can be added to the circuit.
        
    # ==============================================================================
    # =================== function test_check_if_input_is_valid() ==================
    # ==============================================================================

        """
            test_check_if_input_is_valid()

        Test if the input is valid. This function is called by Test_check_if_input_is_valid.jl.

        Parameters: 
        """
        function test_check_if_input_is_valid(circuit)

            # Test if the input is valid
            @testset "Check if the input is valid" begin
                println("\nRunning tests for check_if_input_is_valid()...")

                # Cases where the input is valid
                @test check_if_input_is_valid("2,2", circuit) == true         # Node at (2,2) does not already exist so the input is valid
                @test check_if_input_is_valid("-3,4", circuit) == true        # Node at (-3,4) does not already exist so the input is valid
                @test check_if_input_is_valid("1000,1000", circuit) == true   # Node at (1000,1000) does not already exist so the input is valid

                # Cases where the input is invalid
                @test check_if_input_is_valid("1,g2", circuit) == false       # Input is not in the format 'x,y' (e.g. '1,-2') so the input is invalid
                @test check_if_input_is_valid("0,0", circuit) == false        # Node N1 already exists at (0,0) so the input is invalid
                @test check_if_input_is_valid("1,1", circuit) == false        # Node N4 aready exists at (1,1) so the input is valid
                
            end
        end
end