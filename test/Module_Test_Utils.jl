module Test_Utils

    export TestResult

    """
        TestResult

        A structure to hold details of a test result:
        - `description`: A string describing what the test checks.
        - `status`: A symbol indicating test status (`:passed` or `:failed`).
        - `input`: The input used for the test.
        - `expected`: The expected output (filename in this case).
        - `got`: The actual output (filename).
    """
    struct TestResult{T}
        description::String
        status::Symbol
        input::String
        expected::T
        got::T
    end

end
