"""
    test_Module_Auxiliary_Functions_Input_Validation.jl

Author: Michelangelo Dondi
Date: 20-10-2023
Description:
    A test suite for the `get_positive_integer_input` function.

Version: 2.3
License: MIT License
"""
module Tests_Input_Validation
            
    # ==============================================================================
    # =========================== Required Packages ================================
    # ==============================================================================
        
        using Test

        # Import the `get_positive_integer_input` function.
        include("../src/Module_Auxiliary_Functions_Input_Validation.jl")
        using .Auxiliary_Functions_Input_Validation: get_positive_integer_input

        # Import TestResult data structure
        include("Module_Test_Utils.jl")
        using .Test_Utils: TestResult

    # ==============================================================================
    # ============================ Exported Functions ==============================
    # ==============================================================================

        export recap_test_Module_Functions_Input_Validation
    
    # ==============================================================================
    # ============================ Test Functions ==================================
    # ==============================================================================

    """
        print_result(description::String, input::String, expected::Int, got::Int)

    Prints the result of a test.

    Arguments:
    - `description`: A string describing what the test checks.
    - `input`: The input used for the test.
    - `expected`: The expected output.
    - `got`: The actual output from the function.

    Returns: nothing
    """
    function print_result(description, input, expected, got)
        if got isa Exception
            status = "\033[93mERROR\033[0m"
            got_str = string(got)
        elseif expected == got
            status = "\033[94mPassed\033[m"
            got_str = "\033[32m$got\033[0m"
        else
            status = "\033[31mFAILED\033[0m"
            got_str = "\033[31m$got\033[0m"
        end
        println("$description \n$status \n  - Input:     \033[32m$input\033[0m\n  - Expected:  \033[32m$expected\033[0m\n  - Got:       $got_str\n")
    end

    """
        run_test(description::String, io::IOBuffer, expected::Int)::TestResult

    Run a single test for `get_positive_integer_input` and return a `TestResult`.

    Arguments:
    - `description`: A string describing what the test checks.
    - `io`: An `IOBuffer` containing the input to be used for the test.
    - `expected`: The expected output.
    """
    function run_test(description, io, expected)
        input_string = replace(String(take!(copy(io))), '\n' => '↩')
        seekstart(io)  # Reset IOBuffer's position.

        # Suppress the function's console output.
        original_stdout = stdout
        redirect_stdout(devnull)

        result = nothing  # Initialize result to a default value.

        try
            result = get_positive_integer_input("Prompt: ", io)
        catch e
            result = e
        end

        # Restore original console output.
        redirect_stdout(original_stdout)  

        # Determine and return the test result.
        if result isa Exception
            status = :error
        else
            status = (result == expected) ? :passed : :failed
        end
        print_result(description, input_string, expected, result)
        return TestResult{Int64}(description, status, input_string, expected, result)
    end

    # Main testset for the `get_positive_integer_input` function.
    @testset "get_positive_integer_input" begin

        println("\n=====================================================\n")
        println("Starting tests for 'get_positive_integer_input'...\n")

        # Define tests as (description, IOBuffer input, expected output).
        tests = [
            ("Test 1: Checking a valid small positive integer", 
                # Test 1 input
                IOBuffer("1\n"), 
                # Test 1 expected output 
                1)

            ("Test 2: Checking large positive integer input", 
                # Test 2 input 
                IOBuffer("2222222222\n"),
                # Test 2 expected output 
                2222222222)
            
            ("Test 3: Checking float input followed by valid positive integer", 
                # Test 3 input
                IOBuffer("3.14\n3\n"), 
                # Test 3 expected output
                3)
            
            ("Test 4: Checking alphabetical input followed by valid positive integer", 
                # Test 4 input
                IOBuffer("abc\n4\n"), 
                # Test 4 expected output
                4)
            
            ("Test 5: Checking special characters input followed by valid positive integer", 
                # Test 5 input
                IOBuffer("!@#\n5\n"), 
                # Test 5 expected output
                5)
            
            ("Test 6: Checking empty input followed by valid positive integer", 
                # Input Test 6
                IOBuffer("\n6\n"), 
                # Test 6 expected output
                66)
            
            ("Test 7: Checking sequence of invalid inputs followed by a valid positive integer", 
                # Test 7 input
                IOBuffer("3.14\nabc\n!@#\n7\n"), 
                # Test 7 expected output
                7)

            ("Test 8: Negative number input followed by valid positive integer", 
                # Test 8 inpet
                IOBuffer("-7\n8\n"), 
                # Test 8 expected output
                8)

            ("Test 9: Spaces and tabs followed by valid positive integer", 
                # Test 9 input
                IOBuffer("   \t   \n9\n"), 
                # Test 9 expected output
                9)

            ("Zero input followed by valid positive integer", 
                # Test 10 input
                IOBuffer("0\n10\n"), 
                # Test 10 expected output    
                10)
        
        ]

        results = [run_test(desc, io, exp) for (desc, io, exp) in tests]

        # Display a summary of the test results
        function recap_test_Module_Functions_Input_Validation()
            
            println("\n=====================================================\n")
            println("Tests for 'get_positive_integer_input' concluded.\n")

            println("====== RECAP ======\n")
            passed_tests = filter(r -> r.status == :passed, results)
            failed_tests = filter(r -> r.status == :failed, results)
            error_tests = filter(r -> r.status == :error, results)

            println("     Passed: \033[94m", length(passed_tests), "\033[0m")
            println("     Failed: \033[31m", length(failed_tests), "\033[0m")
            println("     Errors: \033[93m", length(error_tests), "\033[0m")
            println("    -----------")
            println("     Total:  \033[32m", length(results), "\033[0m")
            println("\nSuccess rate: ", length(passed_tests) / length(results) * 100, "%")
            println("\n===================\n")

            # Display failed tests.
            if !isempty(failed_tests)
                println("Failed tests details:")
                for test in failed_tests
                    println("- ", test.description)
                    println("  Input:     \033[32m", test.input, "\033[0m")
                    println("  Expected:  \033[31m", test.expected, "\033[0m")
                    println("  Got:       \033[31m", test.got, "\033[0m\n")
                end
            end

            # Display error tests.
            if !isempty(error_tests)
                println("Error tests details:")
                for test in error_tests
                    println("- ", test.description)
                    println("  Input:     \033[32m", test.input, "\033[0m")
                    println("  Expected:  \033[93m", test.expected, "\033[0m")
                    println("  Got:       \033[93m", test.got, "\033[0m\n")  # Yellow for error details
                end
            end

            println("\nTests for 'get_positive_integer_input' concluded.")
        end

        recap_test_Module_Functions_Input_Validation()

        println("\n=====================================================\n")
        println("Please ignore the following:\n")
    end
end