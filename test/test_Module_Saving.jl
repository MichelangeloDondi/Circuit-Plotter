# ==============================================================================
# ==============================================================================
# ============================ Module: Saving_Tests ============================
# ==============================================================================
# ==============================================================================

"""
    test_Module_Saving.jl

Author: Michelangelo Dondi
Date: 28-10-2023
Description:
    A test suite for the `save_current_plot` function from the `Saving` module.

Version: 4.2
License: MIT License

Exported functions:
- `recap_test_Module_Saving()`: Displays a summary of the test results.
"""
module Saving_Tests

    # ==============================================================================
    # ============================ Exported Functions ==============================
    # ==============================================================================

        export recap_test_Module_Saving
    
    # ==============================================================================
    # ============================ Test Functions ==================================
    # ==============================================================================
    """
        run_test(description::String, io::IOBuffer, expected_filename::String)::TestResult

        Run a single test for `save_current_plot` and return a `TestResult`.
    """
    function run_test(description, io, expected_filename)
        input_string = replace(String(take!(copy(io))), '\n' => '↩')
        seekstart(io)

        plot(sin, -2π, 2π, label="sin(x)")

        original_stdout = stdout
        redirect_stdout(devnull)
        saved_file = ""

        try
            filepath = save_current_plot(io)
            saved_file = basename(filepath)
        catch e
            redirect_stdout(original_stdout)
            println("\033[93mError\033[0m in '$description': ", e,"\n")
            return TestResult{String}(description, :error, input_string, expected_filename, "\033[93mError\033[0m: $e")
        end

        redirect_stdout(original_stdout)
        status = saved_file == expected_filename ? :passed : :failed
        print_result(description, input_string, expected_filename, saved_file)
        return TestResult{String}(description, status, input_string, expected_filename, saved_file)
    end

    function print_result(description, input, expected, got)
        status = if expected == got
            "\033[94mPassed\033[m"
        elseif startswith(got, "Error:")
            "\033[93mError\033[m"
        else
            "\033[31mFAILED\033[m"
        end
        println("$description \n$status \n  - Input:     \033[32m$input\033[0m\n  - Expected:  \033[32m$expected\033[0m\n  - Got:       \033[32m$got\033[0m\n")
    end

    @testset "save_plot_displayed" begin

        println("\n=====================================================\n")
        println("Starting tests for 'save_current_plot'...\n")

        # Define tests as (description, IOBuffer input, expected filename output).
        tests = [
        
            ("Test 1: Default filename",
                # Test 1 input
                IOBuffer("\n"),
                # Test 1 expected output
                "circuit_plot.png"),

            ("Test 2: Custom filename",
                # Test 2 input
                IOBuffer("test_image.png\n"),
                # Test 2 expected output
                "test_image.png"),

            ("Test 3: Filename with leading and trailing whitespaces",
                # Test 3 input
                IOBuffer("  test_whitespace.png  \n"),
                # Test 3 expected output
                "test_whitespace.png"),

            ("Test 4: JPG format",
                # Test 4 input
                IOBuffer("test_image.jpg\n"),
                # Test 4 expected output
                "test_image.jpg"),

            ("Test 5: SVG format",
                # Test 5 input
                IOBuffer("test_image.svg\n"),
                # Test 5 expected output
                "test_image.svg"),

            ("Test 6: Overwrite existing file",
                # Test 6 input
                IOBuffer("test_image.png\n"),
                # Test 6 expected output
                "test_image.png"),

            ("Test 7: Extremely long filename",
                # Test 7 input
                IOBuffer("this_is_an_extremely_long_filename_that_might_cause_issues_for_some_file_systems_or_software_libraries.png\n"),
                # Test 7 expected output
                "this_is_an_extremely_long_filename_that_might_cause_issues_for_some_file_systems_or_software_libraries.png"),
            
            ("Test 8: No file extension provided",
                # Test 8 input
                IOBuffer("myplot\n"),
                # Test 8 expected output
                "myplot.png"),   # Assuming the function adds a .png extension by default.

            ("Test 9: Invalid file format",
                # Test 9 input
                IOBuffer("test.xyz\n"),
                # Test 9 expected output
                "test.xyz"),   

            ("Test 10: Filename with special characters",
                # Test 10 input
                IOBuffer("plot#test.png\n"),
                # Test 10 expected output
                "plot#test.png")
    ]

        results = [run_test(desc, io, exp) for (desc, io, exp) in tests]
        
        # Display a summary of the test results
        function recap_test_Module_Saving()
            
            println("\n=====================================================\n")
            println("Tests for 'save_current_plot' concluded.\n")
        
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

            println("\nTests for 'save_current_plot' concluded.")
        end

        recap_test_Module_Saving()

        println("\n=====================================================\n")
        println("Please ignore the following:\n")
    end
end