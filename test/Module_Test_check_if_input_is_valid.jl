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

Version: 3.7
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
        using .Auxiliary_Functions_Checking_Input_Of_Nodes.Coordinate_Availability_Check # Check if the node can be added to the circuit.

        # Module_Auxiliary_Functions_Circuit_Recap.jl provides auxiliary functions for recapping the circuit.
        include("../src/Module_Auxiliary_Functions_Circuit_Recap.jl")
        using .Auxiliary_Functions_Circuit_Recap: show_nodes_recap # Recap the nodes in the circuit    

    # ==============================================================================
    # =================== function test_check_if_input_is_valid() ==================
    # ==============================================================================

        function test_is_valid_format()

            @testset "Check if the input is in valid format (a pair of integers)" begin

        #=
                # Cases where the input is invalid
                @test is_valid_format("1,g2", circuit) == false       # Input is not in the format 'x,y' (e.g. '1,-2') so the input is invalid
                @test is_valid_format("0,0", circuit) == false        # Node N1 already exists at (0,0) so the input is invalid
                @test is_valid_format("1,1", circuit) == false        # Node N4 aready exists at (1,1) so the input is valid
=#  
            end
        end

    # ==============================================================================
    # =================== Function: test_is_coordinate_available ===================
    # ==============================================================================

        """
            test_is_coordinate_available(input, circuit)

        Test if the input is valid. This function is called by Test_check_if_input_is_valid.jl.

        Parameters: 
        """
        function test_is_coordinate_available(circuit)

            # Test if the input is valid
            @testset "Check if the input is associated to available coordinates" begin

                # Print the name of the test
                println("\nRunning tests for is_coordinate_available(input, circuit)...\n")

                # Show the sample circuit
                println("Hard-coded circuit:")
                show_nodes_recap(circuit)

                # Cases where the coordinates are available
                println("Cases 'a' where the coordinates are available and therefore the function should return true: \n")

                # Test 1: node at (2,2) does not already exist so the coordinates are available
                input1a = "2,2"
                println("""
                ---------------------------------------------------

                \033[96mTest 1a\033[0m: trying to add a node in a position where there is no node already

                    - Input: '$input1a'
                    - Expected Output: true
                    - Notes: Node at ($input1a) does not already exist so the coordinates are available
                    
                ---------------------------------------------------""")
                @test is_coordinate_available(input1a, circuit) == true         
                
                # Test 2a: node at (-3,4) does not already exist so the coordinates are available
                input2a = "-3,4"
                println("""
                ---------------------------------------------------

                \033[96mTest 2a\033[0m: trying to add a node with a negative coordinate in a position where there is no node already

                    - Input: '$input2a'
                    - Expected Output: true
                    - Notes: Node at ($input2a) does not already exist so the coordinates are available
                
                ---------------------------------------------------""")                
                @test is_coordinate_available(input2a, circuit) == true        

                # Test 3a: node at (1001,0) does not already exist so the coordinates are available
                input3a = "1001,0"
                println("""
                ---------------------------------------------------

                \033[96mTest 3a\033[0m: trying to add a node with a coordinate greater than 1000 in a position where there is no node already

                    - Input: '$input3a'
                    - Expected Output: true
                    - Notes: Node at ($input3a) does not already exist so the coordinates are available

                ---------------------------------------------------""") 
                @test is_coordinate_available(input3a, circuit) == true                

                # Test if the coordinates are not available
                println("\nCases 'b' where the coordinates are not available and therefore the function should return false: \n")

                # Test 1b: node at (0,0) already exists so the coordinates are not available
                input1b = "0,0"
                println("""
                ---------------------------------------------------

                \033[96mTest 1b\033[0m: trying to add a node in a position where there is already a node

                    - Input: '$input1b'
                    - Expected Output: false
                    - Notes: Node at ($input1b) already exists so the coordinates are not available

                ---------------------------------------------------""")
                @test is_coordinate_available(input1b, circuit) == false

                # Test 2b: node at (1,1) already exists so the coordinates are not available
                input2b = "1,1"
                println("""
                ---------------------------------------------------

                \033[96mTest 2b\033[0m: trying to add a node in a position where there is already a node

                    - Input: '$input2b'
                    - Expected Output: false
                    - Notes: Node at ($input2b) already exists so the coordinates are not available

                ---------------------------------------------------""")
                @test is_coordinate_available(input2b, circuit) == false

                # Test 3b: node at (-1,0) already exists so the coordinates are not available
                input3b = "-1,0"
                println("""
                ---------------------------------------------------

                \033[96mTest 3b\033[0m: trying to add a node in a position where there is already a node

                    - Input: '$input3b'
                    - Expected Output: false
                    - Notes: Node at ($input3b) already exists so the coordinates are not available

                ---------------------------------------------------""")
                @test is_coordinate_available(input3b, circuit) == false

                println("""
                
                End of tests for is_coordinate_available(input, circuit).

                ===================================================

                """)

            end
        end
end