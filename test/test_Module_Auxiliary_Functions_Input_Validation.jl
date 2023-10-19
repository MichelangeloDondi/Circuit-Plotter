"""
    test_Module_Auxiliary_Functions_Input_Validation.jl

Author: Michelangelo Dondi
Date: 19-10-2023
Description:
    A test suite for the `get_positive_integer_input` function.

Version: 2.3
License: MIT License
"""

using Pkg
using Test

# Add the Test package only if it's not already added.
try
    using Test
catch
    Pkg.add("Test")
    using Test
end

# Import the `get_positive_integer_input` function.
include("..\\src\\Module_Auxiliary_Functions_Input_Validation.jl")
using .Auxiliary_Functions_Input_Validation: get_positive_integer_input

"""
    TestResult

A structure to hold details of a test result:
- `description`: A string describing what the test checks.
- `status`: A symbol indicating test status (`:passed` or `:failed`).
- `input`: The input used for the test.
- `expected`: The expected output.
- `got`: The actual output from the function.
"""
mutable struct TestResult
    description::String
    status::Symbol
    input::String
    expected::Int
    got::Int
end

"""
    run_test(description::String, io::IOBuffer, expected::Int)::TestResult

Run a single test for `get_positive_integer_input` and return a `TestResult`.
"""
function run_test(description, io, expected)
    input_string = replace(String(take!(copy(io))), '\n' => '↩')
    seekstart(io)  # Reset IOBuffer's position.

    # Suppress the function's console output.
    original_stdout = stdout
    redirect_stdout(devnull)
    result = get_positive_integer_input("Prompt: ", io)
    redirect_stdout(original_stdout)  # Restore original console output.

    # Determine and return the test result.
    status = (result == expected) ? :passed : :failed
    print_result(description, input_string, expected, result)
    return TestResult(description, status, input_string, expected, result)
end

# Helper function to print test results with color coding: blue for passed, red for failed, and green for input.
function print_result(description, input, expected, got)
    status = (expected == got) ? "\033[94mPassed\033[m" : "\033[31mFAILED\033[0m"
    println("$description \n$status \n  - Input:     \033[32m$input\033[0m\n  - Expected:  \033[32m$expected\033[0m\n  - Got:       \033[32m$got\033[0m\n")
end

# Main testset for the `get_positive_integer_input` function.
@testset "get_positive_integer_input" begin
    println("\nStarting tests for 'get_positive_integer_input'...\n")
    # Sleep for 2 seconds to allow the user to read the introduction.
    sleep(2)

    # Define tests as (description, IOBuffer input, expected output).
    tests = [
        ("Test 1: Checking a valid small positive integer", 
            # Input Test 1
            IOBuffer("1\n"), 
            # Expected output Test 0
            1)

        ("Test 2: Checking large positive integer input", 
            # Input Test 2
            IOBuffer("2222222222\n"),
            # Expected output Test 2 
            2222222222)
        
        ("Test 3: Checking float input followed by valid positive integer", 
            # Input Test 3
            IOBuffer("3.14\n3\n"), 
            # Expected output Test 3
            3)
        
        ("Test 4: Checking alphabetical input followed by valid positive integer", 
            # Input Test 4
            IOBuffer("abc\n4\n"), 
            # Expected output Test 4
            4)
        
        ("Test 5: Checking special characters input followed by valid positive integer", 
            # Input Test 5
            IOBuffer("!@#\n5\n"), 
            # Expected output Test 5
            5)
        
        ("Test 6: Checking empty input followed by valid positive integer", 
            # Input Test 6
            IOBuffer("\n6\n"), 
            # Expected output Test 6
            66)
        
        ("Test 7: Checking sequence of invalid inputs followed by a valid positive integer", 
            # Input Test 7
            IOBuffer("3.14\nabc\n!@#\n7\n"), 
            # Expected output Test 7
            7)
    ]

    results = [run_test(desc, io, exp) for (desc, io, exp) in tests]

    # Display a summary of the test results
    println("====== RECAP ======\n")
    passed_tests = filter(r -> r.status == :passed, results)
    failed_tests = filter(r -> r.status == :failed, results)

    println("     Passed: \033[94m", length(passed_tests), "\033[0m")
    println("     Failed: \033[31m", length(failed_tests), "\033[0m")
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
    
    println("\nTests for 'get_positive_integer_input' concluded.")
    println("\n=====================================================\n")
    println("Please ignore the following:\n")
end

################################## 
#=
"""
    test_Module_Auxiliary_Functions_Input_Validation.jl

A test suite for the `get_positive_integer_input` function.
"""
using Pkg

Pkg.add("Test")  # For testing the function
using Test

# Import the `get_positive_integer_input` function from Module_Auxiliary_Functions_Input_Validation.jl
include("..\\src\\Module_Auxiliary_Functions_Input_Validation.jl")
using .Auxiliary_Functions_Input_Validation: get_positive_integer_input

# Print an introduction to the tests
println("""

Starting tests for the 'get_positive_integer_input' function...

Each test will provide the following details:
  - Test description
  - Status (Passed/Failed)
  - Given input
  - Expected output
  - Actual output from the function
""")
println("Let's begin...\n")
sleep(5)  # A brief pause for the user to read the introduction.

"""
    TestResult

A structure to hold the details of a test result, including:
- description: A string that provides information about what the test is checking.
- status: A symbol indicating whether the test passed or failed.
- input: The given input for the test.
- expected: The expected output for the test.
- got: The actual output obtained from the function.
"""
mutable struct TestResult
    description::String
    status::Symbol
    input::String
    expected::Int
    got::Int
end

"""
    run_test(description::String, io::IOBuffer, expected::Int)::TestResult

Run a single test for the `get_positive_integer_input` function and return a TestResult structure 
containing the details of the test.
"""
function run_test(description, io, expected)
    # Convert IOBuffer's content to a readable string (with ↩ representing newlines)
    input_string = replace(String(take!(copy(io))), '\n' => '↩')
    seekstart(io)  # Reset the IOBuffer's position

    # Temporarily suppress the function's console output to avoid clutter
    original_stdout = stdout
    redirect_stdout(devnull)

    # Execute the function under test with the provided input
    result = Auxiliary_Functions_Input_Validation.get_positive_integer_input("Prompt: ", io)

    # Restore the original console output
    redirect_stdout(original_stdout)

    # Log the result and return the corresponding TestResult instance
    if result == expected
        println("$description \n\033[94mPassed\033[m \n  - Input:     \033[32m$input_string\033[0m\n  - Expected:  \033[94m$expected\033[0m\n  - Got:       \033[94m$result\033[0m\n")
        return TestResult(description, :passed, input_string, expected, result)
    else
        println("$description \n\033[31mFAILED\033[0m \n  - Input:     \033[32m$input_string\033[0m\n  - Expected:  \033[31m$expected\033[0m\n  - Got:       \033[31m$result\033[0m\n")
        return TestResult(description, :failed, input_string, expected, result)
    end
end

# Main testset for the `get_positive_integer_input` function
@testset "get_positive_integer_input" begin
    # Define test cases with their descriptions, inputs, and expected results
    results = []

    # Each tuple represents: (description, IOBuffer input, expected output)
    tests = [
        ("Test 1: Checking a valid small positive integer", 
            # Input Test 1
            IOBuffer("1\n"), 
            # Expected output Test 0
            1)

        ("Test 2: Checking large positive integer input", 
            # Input Test 2
            IOBuffer("99999999\n"),
            # Expected output Test 2 
            99999999)
        
        ("Test 3: Checking float input followed by valid positive integer", 
            # Input Test 3
            IOBuffer("3.14\n3\n"), 
            # Expected output Test 3
            3)
        
        ("Test 4: Checking alphabetical input followed by valid positive integer", 
            # Input Test 4
            IOBuffer("abc\n4\n"), 
            # Expected output Test 4
            4)
        
        ("Test 5: Checking special characters input followed by valid positive integer", 
            # Input Test 5
            IOBuffer("!@#\n5\n"), 
            # Expected output Test 5
            5)
        
        ("Test 6: Checking empty input followed by valid positive integer", 
            # Input Test 6
            IOBuffer("\n6\n"), 
            # Expected output Test 6
            66)
        
        ("Test 7: Checking sequence of invalid inputs followed by a valid positive integer", 
            # Input Test 7
            IOBuffer("3.14\nabc\n!@#\n7\n"), 
            # Expected output Test 7
            7)
    ]

    # Run each test and store its result in the 'results' list
    for (description, io, expected) in tests
        push!(results, run_test(description, io, expected))
    end

    # Display a summary of the test results
    println("====== RECAP ======\n")
    passed_tests = filter(r -> r.status == :passed, results)
    failed_tests = filter(r -> r.status == :failed, results)

    println("     Passed: \033[94m", length(passed_tests), "\033[0m")
    println("     Failed: \033[31m", length(failed_tests), "\033[0m")
    println("    -----------")
    println("     Total:  \033[32m", length(results), "\033[0m")
    println("\nSuccess rate: ", length(passed_tests) / length(results) * 100, "%")
    println("\n===================\n")

    # If there are failed tests, print their details
    if !isempty(failed_tests)
        println("Failed tests details:")
        for test in failed_tests
            println("- ", test.description)
            println("  Input:     \033[32m", test.input, "\033[0m")
            println("  Expected:  \033[31m", test.expected, "\033[0m")
            println("  Got:       \033[31m", test.got, "\033[0m\n")
        end
    end
    
    println("Tests for the 'get_positive_integer_input' function concluded.")
    println("\n=====================================================\n")
    println("Please ignore the following:\n")
end
=#