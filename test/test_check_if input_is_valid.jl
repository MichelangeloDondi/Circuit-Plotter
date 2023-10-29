# ==============================================================================
# ==============================================================================
# ====================== Module: TestCheckIfInputIsValid =======================
# ==============================================================================
# ==============================================================================

"""
    Module: TestCheckIfInputIsValid

Author: Michelangelo Dondi
Date: 29-10-2023
Description: This module provides functions to test the function 'check_if_input_is_valid()' 
    of the module CheckingNodesInput. The function 'check_if_input_is_valid()' checks if the 
    input provided by the user can be used to add a node to the circuit. 

Version: 4.5
Licence: MIT Licence

Exported Functions:
    test_is_valid_format()
    test_is_coordinate_available(circuit)
        
Required Packages:
    Test
        
Including Modules:
    CheckingNodesInput
    CircuitRecap
"""
module TestCheckIfInputIsValid

    # ==============================================================================
    # =========================== Exported Functions ===============================
    # ==============================================================================

        # Invoke the function test_is_valid_format() to test the function is_valid_format() of the module Auxiliary_Functions_Checking_Input_Of_Nodes
        export test_is_valid_format

        # Invoke the function test_is_coordinate_available(circuit) to test the function is_coordinate_available(input, circuit) of the module Auxiliary_Functions_Checking_Input_Of_Nodes
        export test_is_coordinate_available
        
    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        using Test

    # ==============================================================================
    # ============================ Including Modules ===============================
    # ==============================================================================

        # Module CheckingNodesInput provides functions to check if the input provided by the user can be used to add a node to the circuit.
        include("../src/nodes_management/helper_functions_collecting_nodes/checking_nodes_input.jl")
        using .CheckingNodesInput.CoordinateAvailabilityCheck # Check if the coordinates are available.
        using .CheckingNodesInput.InputFormatCheck # Check if the input is in the correct format (a pair of integers).

        # Module_Auxiliary_Functions_Circuit_Recap.jl provides auxiliary functions for recapping the circuit.
        include("../src/functions_always_callable/circuit_recap.jl")
        using .CircuitRecap: show_nodes_recap # Recap the nodes in the circuit    

    # ==============================================================================
    # ======================= Function: test_is_valid_format() =====================
    # ==============================================================================

        """
            test_is_valid_format()

        Test if the input is in valid format (a pair of integers).

        Parameters:
        None
            
        Returns:
        None
            
        Notes:
        The function is_valid_format(input) is tested in the following cases:

        Cases 'A' where the input is a pair of valid integers:
            - Test 1A: pair of small integers
            - Test 2A: pair of large positive integers
            - Test 3A: pair of large integers with opposite signs
            - Test 4A: pair of integers with a space in front
            - Test 5A: pair of integers with a space at the end
            - Test 6A: pair of integers with a space in the middle after the comma
            - Test 7A: pair of integers with a space in the middle before the comma

        Cases 'B' where the input is composed of integer numbers but is not in the format 'x,y':
            - Test 1B: single integer
            - Test 2B: pair of integers with a double comma
            - Test 3B: triple integer
            - Test 4B: pair of integers with a negative sign in the middle
            - Test 5B: pair of integers with a negative sign at the end
            - Test 6B: pair of integers with a comma at the beginning
            - Test 7B: pair of integers with a comma at the end

        Cases 'C' where the input is not composed of integer numbers:
            - Test 1C: pair of an integer with a letter
            - Test 2C: pair of an integer with a special character
            - Test 3C: empty string
            - Test 4C: pair of an integer with a space
            - Test 5C: pair of an integer with a space
        """
        function test_is_valid_format()

            @testset "Check if the input is in valid format (a pair of integers)" begin

                # Print the name of the test
                println("\nRunning tests for is_valid_format()...\n")

                # Cases where the input is a valid pair of integers
                println("\n\033[93mCases 'A' where the input is a valid pair of integers: \033[0m\n")

                # In this section, the assertion is true == true because the function is_valid_format(input) is tested in the following cases:

                    # Cases 'A' where the input is a pair of valid integers:
                    # - Test 1A: pair of small integers
                    # - Test 2A: pair of large positive integers
                    # - Test 3A: pair of large integers with opposite signs
                    # - Test 4A: pair of integers with a space in front
                    # - Test 5A: pair of integers with a space at the end
                    # - Test 6A: pair of integers with a space in the middle after the comma
                    # - Test 7A: pair of integers with a space in the middle before the comma
        
                test_is_valid_format_cases_A_where_the_input_is_a_pair_of_valid_integers()

                # Cases where the input is not in the format 'x,y'
                println("\n\033[93mCases 'B' where the input is composed of integer numbers but is not in the format 'x,y': \033[0m\n")

                # In this section, the assertion is false == false because the function is_valid_format(input) is tested in the following cases:
                
                    # Cases 'B' where the input is composed of integer numbers but is not in the format 'x,y':
                    # - Test 1B: single integer
                    # - Test 2B: pair of integers with a double comma
                    # - Test 3B: triple integer
                    # - Test 4B: pair of integers with a negative sign in the middle
                    # - Test 5B: pair of integers with a negative sign at the end
                    # - Test 6B: pair of integers with a comma at the beginning
                    # - Test 7B: pair of integers with a comma at the end

                test_is_valid_format_cases_B_where_the_input_is_not_in_the_format_x_y()

                # Cases where the input is not composed of integer numbers
                println("\n\033[93mCases 'C' where the input is not composed of integer numbers.\033[0m\n")

                # In this section, the assertion is false == false because the function is_valid_format(input) is tested in the following cases:

                    # Cases 'C' where the input is not composed of integer numbers:
                    # - Test 1C: pair of an integer with a letter
                    # - Test 2C: pair of an integer with a special character
                    # - Test 3C: empty string
                    # - Test 4C: pair of an integer with a space
                    # - Test 5C: pair of an integer with a space

                test_is_valid_format_cases_C_where_the_input_is_not_composed_of_integer_numbers()
            end
        end

    # ==============================================================================
    # === Function: test_is_valid_format_cases_A_where_the_input_is_a_pair_of_valid_integers() ===
    # ==============================================================================

        """
            test_is_valid_format_cases_A_where_the_input_is_a_pair_of_valid_integers()

        Test if a pair of integers in the format 'x,y' (without regarding for spaces) returns true.

        Parameters:
        None
            
        Returns:
        None
            
        Notes:
        The function is_valid_format(input) is tested in the following cases:

        Cases 'A' where the input is a pair of valid integers:
            - Test 1A: pair of small integers
            - Test 2A: pair of large positive integers
            - Test 3A: pair of large integers with opposite signs
            - Test 4A: pair of integers with a space in front
            - Test 5A: pair of integers with a space at the end
            - Test 6A: pair of integers with a space in the middle after the comma
            - Test 7A: pair of integers with a space in the middle before the comma
        """
        function test_is_valid_format_cases_A_where_the_input_is_a_pair_of_valid_integers()

            # Test 1A: pair of small integers
            input1A = "1,-1"
            println("""
            ---------------------------------------------------

            \033[96mTest 1A: checking if a pair of small integers in the format 'x,y' is valid \033[0m

                - Input: '$input1A'
                - Expected Output: true
                - Notes: The input is in the format 'x,y' so the format of the input should be valid
                
            ---------------------------------------------------""")
            @test is_valid_format(input1A) == true       

            # Test 2A: pair of large positive integers
            input2A = "22222222,22222222"
            println("""
            ---------------------------------------------------

            \033[96mTest 2A: checking if a pair of large positive integers in the format 'x,y' is valid \033[0m

                - Input: $input2A
                - Expected Output: true
                - Notes: The input is in the format 'x,y' so the format of the input should be valid

            ---------------------------------------------------""")
            @test is_valid_format(input2A) == true  
            
            # Test 3A: pair of lange integers with opposit signs
            input3A = "333333333,-333333333"
            println("""
            ---------------------------------------------------

            \033[96mTest 3A: checking if a pair of large integers with opposite signs in the format 'x,y' is valid \033[0m

                - Input: $input3A
                - Expected Output: true
                - Notes: The input is in the format 'x,y' so the format of the input should be valid

            ---------------------------------------------------""")
            @test is_valid_format(input3A) == true

            # Test 4A: pair of integers with a space in front
            input4A = " 4,4"
            println("""
            ---------------------------------------------------

            \033[96mTest 4A: checking if a pair of integers with a space in front in the format 'x,y' is valid \033[0m

                - Input: '$input4A'
                - Expected Output: true
                - Notes: The input is in the format 'x,y' so the format of the input should be valid

            ---------------------------------------------------""")
            @test is_valid_format(input4A) == true

            # Test 5A: pair of integers with a space at the end
            input5A = "5,5 "
            println("""
            ---------------------------------------------------

            \033[96mTest 5A: checking if a pair of integers with a space at the end in the format 'x,y' is valid \033[0m

                - Input: '$input5A'
                - Expected Output: true
                - Notes: The input is in the format 'x,y' so the format of the input should be valid

            ---------------------------------------------------""")
            @test is_valid_format(input5A) == true

            # Test 6A: pair of integers with a space in the middle after the comma
            input6A = "6, 6"
            println("""
            ---------------------------------------------------

            \033[96mTest 6A: checking if a pair of integers with a space in the middle after the comma in the format 'x,y' is valid \033[0m

                - Input: '$input6A'
                - Expected Output: true
                - Notes: The input is in the format 'x,y' so the format of the input should be valid

            ---------------------------------------------------""")
            @test is_valid_format(input6A) == true

            # Test 7A: pair of integers with a space in the middle before the comma
            input7A = "7 ,7"
            println("""
            ---------------------------------------------------

            \033[96mTest 7A: checking if a pair of integers with a space in the middle before the comma in the format 'x,y' is valid \033[0m

                - Input: '$input7A'
                - Expected Output: true
                - Notes: The input is in the format 'x,y' so the format of the input should be valid

            ---------------------------------------------------""")
            @test is_valid_format(input7A) == true
        end      

    # ==============================================================================
    # --- Function: test_is_valid_format_cases_B_where_the_input_is_not_in_the_format_x_y() ---
    # ==============================================================================

        """
            test_is_valid_format_cases_B_where_the_input_is_not_in_the_format_x_y() 

        Test if the input is not in the format 'x,y' (without regarding for spaces) returns false.

        Parameters:
        None
            
        Returns:
        None
            
        Notes:
        The function is_valid_format(input) is tested in the following cases:

        Cases 'B' where the input is composed of integer numbers but is not in the format 'x,y':
            - Test 1B: single integer
            - Test 2B: pair of integers with a double comma
            - Test 3B: triple integer
            - Test 4B: pair of integers with a negative sign in the middle
            - Test 5B: pair of integers with a negative sign at the end
            - Test 6B: pair of integers with a comma at the beginning
            - Test 7B: pair of integers with a comma at the end
        """
        function test_is_valid_format_cases_B_where_the_input_is_not_in_the_format_x_y()

            # Test 1B: single integer
            input1B = "1"
            println("""
            ---------------------------------------------------

            \033[96mTest 1B: checking if a single integer in the format 'x' is valid \033[0m

                - Input: '$input1B'
                - Expected Output: false
                - Notes: The input is not in the format 'x,y' so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input1B) == false     

            # Test 2B: pair of integers with a double comma
            input2B = "2,,2"
            println("""
            ---------------------------------------------------

            \033[96mTest 2B: checking if a pair of integers in the format 'x,,y' is valid \033[0m

                - Input: '$input2B'
                - Expected Output: false
                - Notes: The input is not in the format 'x,y' so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input2B) == false

            # Test 3B: triple integer
            input3B = "3,3,3"
            println("""
            ---------------------------------------------------

            \033[96mTest 3B: checking if a triple integer in the format 'x,y,z' is valid \033[0m

                - Input: '$input3B'
                - Expected Output: false
                - Notes: The input is not in the format 'x,y' so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input3B) == false

            # Test 4B: pair of integers with a negative sign in the middle
            input4B = "4,-,4"
            println("""
            ---------------------------------------------------

            \033[96mTest 4B: checking if a pair of integers in the format 'x,-,y' is valid \033[0m

                - Input: '$input4B'
                - Expected Output: false
                - Notes: The input is not in the format 'x,y' so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input4B) == false

            # Test 5B: pair of integers with a negative sign at the end
            input5B = "5,5-"
            println("""
            ---------------------------------------------------

            \033[96mTest 5B: checking if a pair of integers in the format 'x,y-' is valid \033[0m

                - Input: '$input5B'
                - Expected Output: false
                - Notes: The input is not in the format 'x,y' so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input5B) == false

            # Test 6B: pair of integers with a comma at the beginning
            input6B = ",6,6"
            println("""
            ---------------------------------------------------

            \033[96mTest 6B: checking if a pair of integers in the format ',x,y' is valid \033[0m

                - Input: '$input6B'
                - Expected Output: false
                - Notes: The input is not in the format 'x,y' so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input6B) == false

            # Test 7B: pair of integers with a comma at the end
            input7B = "7,7,"
            println("""
            ---------------------------------------------------

            \033[96mTest 7B: checking if a pair of integers in the format 'x,y,' is valid \033[0m

                - Input: '$input7B'
                - Expected Output: false
                - Notes: The input is not in the format 'x,y' so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input7B) == false
        end

    # ==============================================================================
    # --- Function: test_is_valid_format_cases_C_where_the_input_is_not_composed_of_integer_numbers() ---
    # ==============================================================================

        """
            test_is_valid_format_cases_C_where_the_input_is_not_composed_of_integer_numbers()

        Test if the input is not composed of integer numbers returns false.

        Parameters:
        None
            
        Returns:
        None
            
        Notes:
        The function is_valid_format(input) is tested in the following cases:

        Cases 'C' where the input is not composed of integer numbers:
            - Test 1C: pair of an integer with a letter
            - Test 2C: pair of an integer with a special character
            - Test 3C: empty string
            - Test 4C: pair of an integer with a space
            - Test 5C: pair of an integer with a space
        """
        function test_is_valid_format_cases_C_where_the_input_is_not_composed_of_integer_numbers()

            # Test 1C: pair of an integer with a letter
            input1C = "1,a"
            println("""
            ---------------------------------------------------

            \033[96mTest 1C: checking if a pair of an integer with a letter in the format 'x,y' is valid \033[0m

                - Input: '$input1C'
                - Expected Output: false
                - Notes: The input is not composed of integer numbers so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input1C) == false

            # Test 2C: pair of an integer with a special character
            input2C = "2,!"
            println("""
            ---------------------------------------------------

            \033[96mTest 2C: checking if a pair of an integer with a special character in the format 'x,y' is valid \033[0m

                - Input: '$input2C'
                - Expected Output: false
                - Notes: The input is not composed of integer numbers so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input2C) == false

            # Test 3C: empty string
            input3C = ""
            println("""
            ---------------------------------------------------

            \033[96mTest 3C: checking if an empty string is valid

                - Input: '$input3C'
                - Expected Output: false
                - Notes: The input is not composed of integer numbers so the format of the input should not be valid \033[0m

            ---------------------------------------------------""")
            @test is_valid_format(input3C) == false

            # Test 4C: pair of an integer with a space
            input4C = "4, "
            println("""
            ---------------------------------------------------

            \033[96mTest 4C: checking if a pair of an integer with a space in the end in the format 'x,y' is valid \033[0m

                - Input: '$input4C'
                - Expected Output: false
                - Notes: The input is not composed of integer numbers so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input4C) == false

            # Test 5C: pair of an integer with a space
            input5C = " ,5"
            println("""
            ---------------------------------------------------

            \033[96mTest 5C: checking if a pair of an integer with a space in the beginning in the format 'x,y' is valid \033[0m

                - Input: '$input5C'
                - Expected Output: false
                - Notes: The input is not composed of integer numbers so the format of the input should not be valid

            ---------------------------------------------------""")
            @test is_valid_format(input5C) == false
        end

    # ==============================================================================
    # ============== Function: test_is_coordinate_available(circuit) ===============
    # ==============================================================================

        """
            test_is_coordinate_available(circuit)

        Test if the input is associated to available coordinates.

        Parameters:
        - input : the input to be tested.
        - circuit : the circuit to be tested.

        Returns:
        None
        
        Notes:
        The function is_coordinate_available(input, circuit) is tested in the following cases:

        Cases 'A' where the coordinates are available and therefore the function should return true:
            - Test 1A: node at (2,2) does not already exist so the coordinates are available
            - Test 2A: node at (-3,4) does not already exist so the coordinates are available
            - Test 3A: node at (1001,0) does not already exist so the coordinates are available

        Cases 'B' where the coordinates are not available and therefore the function should return false:
            - Test 1B: node at (0,0) already exists so the coordinates are not available
            - Test 2B: node at (1,1) already exists so the coordinates are not available
            - Test 3B: node at (-1,0) already exists so the coordinates are not available
        """
        function test_is_coordinate_available(circuit)

            # Test if the input is associated to available coordinates
            @testset "Check if the input is associated to available coordinates" begin

                # Print the name of the test
                println("\nRunning tests for is_coordinate_available(input, circuit)...\n")

                # Show the sample circuit
                println("Hard-coded circuit:")
                show_nodes_recap(circuit)

                # Cases where the coordinates are available
                println("\n\033[93mCases 'A' where the coordinates are available and therefore the function should return true: \033[0m\n")

                # In this section, the assertion is true == true because the function is_coordinate_available(input, circuit) is tested in the following cases:

                    # Cases 'A' where the coordinates are available and therefore the function should return true:
                    # - Test 1A: node at (2,2) does not already exist so the coordinates are available
                    # - Test 2A: node at (-3,4) does not already exist so the coordinates are available
                    # - Test 3A: node at (1001,0) does not already exist so the coordinates are available

                test_is_coordinate_available_cases_A_where_the_coordinates_are_available(circuit)

                # Test if the coordinates are not available
                println("\n\033[93mCases 'B' where the coordinates are not available and therefore the function should return false: \033[0m\n")

                # In this section, the assertion is false == false because the function is_coordinate_available(input, circuit) is tested in the following cases:

                    # Cases 'B' where the coordinates are not available and therefore the function should return false:
                    # - Test 1B: node at (0,0)  already exists so the coordinates are not available
                    # - Test 2B: node at (1,1)  already exists so the coordinates are not available
                    # - Test 3B: node at (1,-1) already exists so the coordinates are not available

                test_is_coordinate_available_cases_B_where_the_coordinates_are_not_available(circuit)

                println("""
                
                End of tests for is_coordinate_available(input, circuit).

                ===================================================

                """)

            end
        end
    
    # ==============================================================================
    # --- Function: test_is_coordinate_available_cases_A_where_the_coordinates_are_available(circuit) --- 
    # ==============================================================================

        """
            test_is_coordinate_available_cases_A_where_the_coordinates_are_available(circuit)

        Test if the coordinates that are available are indicated as available.

        Parameters:
        - circuit: the circuit to be tested.
            
        Returns:
        None
            
        Notes:
        The function is_coordinate_available(input, circuit) is tested in the following cases:

        Cases 'A' where the coordinates are available and therefore the function should return true:
            - Test 1A: node at (2,2) does not already exist so the coordinates are available
            - Test 2A: node at (-3,4) does not already exist so the coordinates are available
            - Test 3A: node at (1001,0) does not already exist so the coordinates are available
        """
        function test_is_coordinate_available_cases_A_where_the_coordinates_are_available(circuit)
            
                # Test 1A: node at (2,2) does not already exist so the coordinates are available
                input1A = "2,2"
                println("""
                ---------------------------------------------------

                \033[96mTest 1A: trying to add a node in a position where there is no node already \033[0m

                    - Input: '$input1A'
                    - Expected Output: true
                    - Notes: Node at ($input1A) does not already exist so the coordinates are available
                    
                ---------------------------------------------------""")
                @test is_coordinate_available(input1A, circuit) == true         
                
                # Test 2A: node at (-3,4) does not already exist so the coordinates are available
                input2A = "-3,4"
                println("""
                ---------------------------------------------------

                \033[96mTest 2A: trying to add a node with a negative coordinate in a position where there is no node already \033[0m

                    - Input: '$input2A'
                    - Expected Output: true
                    - Notes: Node at ($input2A) does not already exist so the coordinates are available 
                
                ---------------------------------------------------""")                
                @test is_coordinate_available(input2A, circuit) == true        

                # Test 3A: node at (1001,0) does not already exist so the coordinates are available
                input3A = "1001,0"
                println("""
                ---------------------------------------------------

                \033[96mTest 3A: trying to add a node with a coordinate greater than 1000 in a position where there is no node already \033[0m

                    - Input: '$input3A'
                    - Expected Output: true
                    - Notes: Node at ($input3A) does not already exist so the coordinates are available

                ---------------------------------------------------""") 
                @test is_coordinate_available(input3A, circuit) == true  
        end
    
    # ==============================================================================
    # --- Function: test_is_coordinate_available_cases_B_where_the_coordinates_are_not_available(circuit) ---
    # ==============================================================================

        """
        test_is_coordinate_available_cases_B_where_the_coordinates_are_not_available(circuit)

        Test if the coordinates that are already occupied are indicated as not available.

        Parameters:
        - circuit: the circuit to be tested.
            
        Returns:
        None
            
        Notes:
        The function is_coordinate_available(input, circuit) is tested in the following cases:

        Cases 'B' where the coordinates are not available and therefore the function should return false:
            - Test 1B: node at (0,0) already exists so the coordinates are not available
            - Test 2B: node at (1,1) already exists so the coordinates are not available
            - Test 3B: node at (1,-1) already exists so the coordinates are not available
        """        
        function test_is_coordinate_available_cases_B_where_the_coordinates_are_not_available(circuit)

            # Test 1B: node at (0,0) already exists so the coordinates are not available
            input1B = "0,0"
            println("""
            ---------------------------------------------------

            \033[96mTest 1B: trying to add a node in a position where there is already a node \033[0m

                - Input: '$input1B'
                - Expected Output: false
                - Notes: Node at ($input1B) already exists so the coordinates are not available

            ---------------------------------------------------""")
            @test is_coordinate_available(input1B, circuit) == false

            # Test 2B: node at (1,1) already exists so the coordinates are not available
            input2B = "1,1"
            println("""
            ---------------------------------------------------

            \033[96mTest 2B: trying to add a node in a position where there is already a node \033[0m

                - Input: '$input2B'
                - Expected Output: false
                - Notes: Node at ($input2B) already exists so the coordinates are not available

            ---------------------------------------------------""")
            @test is_coordinate_available(input2B, circuit) == false

            # Test 3B: node at (1,-1) already exists so the coordinates are not available
            input3B = "1,-1"
            println("""
            ---------------------------------------------------

            \033[96mTest 3B: trying to add a node in a position where there is already a node \033[0m

                - Input: '$input3B'
                - Expected Output: false
                - Notes: Node at ($input3B) already exists so the coordinates are not available

            ---------------------------------------------------""")
            @test is_coordinate_available(input3B, circuit) == false
        end
end