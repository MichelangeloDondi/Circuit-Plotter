# ==============================================================================
# ==============================================================================
# ==============================================================================
# =========================== Tests Circuit Plotter ============================
# ==============================================================================
# ==============================================================================
# ==============================================================================

"""
    File: runtests.jl

Author: Michelangelo Dondi
Date: 27-10-2023
Description: This file runs the tests for the Circuit Plotter Program.

Version: 4.0
License: MIT License
"""
# ==============================================================================
# ============================ Required Packages ===============================
# ==============================================================================

    # Ensure necessary packages are added and used.
    using Pkg

    # List of packages to be installed and loaded
    for package in [
        "Test",          # For testing
        "Parameters",    # For defining the data structures (e.g. 'Node(id=1, x=1, y=1)' instead of 'Node(1, 1, 1)')
        "LightGraphs",   # For graph data structures
        "GraphRecipes",  # For plotting the circuit (the graph)
        "Plots",         # For plotting the circuit (labels, etc.)
        "PlotlyJS"       # Plotting backend for interactivity
        ]

        # Try to load the packages
        try 
            
            # Load the package
            eval(Meta.parse("using $package"))

        # If any of the packages is not installed, install it
        catch
            
            # Install the package
            Pkg.add(package)        

            # Load the package
            eval(Meta.parse("using $package"))
        end
    end

# ==============================================================================
# ============================ Including Modules ===============================
# ==============================================================================

    # Module_CircuitStructures.jl provides the data structures used by the Circuit Plotter Program.
    include("../src/Module_Circuit_Structures.jl")
    using .Circuit_Structures: Node, Circuit # Access the data structures

    # Module_Test_check_if_input_is_valid.jl provides the function 'check_if_input_is_valid()'.
    include("Module_Test_check_if_input_is_valid.jl")
    using .Test_check_if_input_is_valid: test_is_coordinate_available # Access the function
    using .Test_check_if_input_is_valid: test_is_valid_format # Access the function

    # Module_Test_image_name.jl provides the function 'test_save_plot_displayed()'.
    #include("Module_Test_save_plot_displayed.jl")
    #using .Test_save_plot_displayed: test_save_plot_displayed # Access the function
    
# ==============================================================================
# ========================== Hard-Coded Circuit ================================
# ==============================================================================

    # Create a circuit hard-coded
    circuit = Circuit([
        Node(id=1, x=0, y=0),  # Node N1 at ( 0,0)
        Node(id=2, x=-1, y=0), # Node N2 at (-1,0)
        Node(id=3, x=2, y=0),  # Node N3 at ( 2,0)
        Node(id=4, x=1, y=1),  # Node N4 at ( 1,1)
        Node(id=5, x=0, y=2)   # Node N5 at ( 0,2)
        ], [], SimpleGraph())

# ==============================================================================
# ========= Testing Module Auxiliary_Functions_Checking_Input_Of_Nodes =========
# ==============================================================================

    # Test module 'Module_Test_check_if_input_is_valid.jl'
    println("\nRunning tests for Module_Test_check_if_input_is_valid...")

    # Test 'is_valid_format()' of Module Auxiliary_Functions_Checking_Input_Of_Nodes
    test_is_valid_format()

    # Test 'is_coordinate_available(circuit)' of Module Auxiliary_Functions_Checking_Input_Of_Nodes
    test_is_coordinate_available(circuit)

# ==============================================================================
# ========================== Testing Module_Saving =============================
# ==============================================================================

    # Test 'save_plot_displayed()'
    #test_save_plot_displayed()

#=
    @testset "Module_Saving Tests" begin
        println("\nRunning tests for Module_Saving...")
        include("test_Module_Saving.jl")
    end

=#
#=
@testset "Add node $input" for input in ["1,2", "3,4", "1,3", "5,6"] 
    @test check_if_inupu_is_valid(input, circuit) == true
end 
=#

# ==============================================================================
# ========================= Test Module_Saving =================================
# ==============================================================================
#=
@testset "Module_Saving Tests" begin
    println("\nRunning tests for Module_Saving...")
    include("test_Module_Saving.jl")
end
=#
println("\nAll tests have concluded.")
