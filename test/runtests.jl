# ------------------------------------------------------------------------------
# ==============================================================================
# ==============================================================================
# ============================= File: runtests.jl ==============================
# ==============================================================================
# ==============================================================================
# ------------------------------------------------------------------------------

"""
    File: runtests.jl

This file runs the tests for the Circuit Plotter Program.

# Author: Michelangelo Dondi

# Date: 30-10-2023

# Version: 4.8

# License: MIT License

# Reqired packages:
    - `Test`: For testing
    - `Parameters`: For defining the data structures (e.g. 'Node(id=1, x=1, y=1)' instead of 'Node(1, 1, 1)')
    - `LightGraphs`: For graph data structures
    - `GraphRecipes`: For plotting the circuit (the graph)
    - `Plots`: For plotting the circuit (labels, etc.)
    - `PlotlyJS`: Plotting backend for interactivity

# Included modules:
    - `DataStructure`: For housing the data structures used by the Circuit Plotter Program
    - `TestCheckIfInputIsValid`: For housing the tests of the module 'CheckIfInputIsValid'
    - `TestSavePlotDisplayed`: For housing the tests of the module 'SavePlotDisplayed'

# Notes:
    - The program is structured in modules, each of which is described in the corresponding file.
"""
# ---------------------------------------------------------------------------- #
################################################################################
# ================= Begin Of Tests Of Circuit-Plotter Program ================ #
################################################################################
# ---------------------------------------------------------------------------- #

    # ==============================================================================
    # ============================= Required Packages ==============================
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

        # Module 'DataStructure' provides the data structures used by the Circuit Plotter Program.
        include("../src/data_structure.jl")
        using .DataStructure: Node, EdgeInfo, Circuit # Access the data structures

        # Module 'TestCheckIfInputIsValid' provides the functions used to test the module 'CheckIfInputIsValid'.
        include("nodes_management/helper_functions_collecting_nodes/checking_nodes_input/test_check_if input_is_valid.jl")
        using .TestCheckIfInputIsValid: test_is_coordinate_available # Access the function
        using .TestCheckIfInputIsValid: test_is_valid_format # Access the function

        # Module 'OverlappingCheck' provides the function 'test_overlapping_check()'.
        include("edges_management/helper_functions_collecting_edges/test_overlapping_check.jl")
        using .TestOverlappingCheck: test_overlapping_check # Access the function

        # Module TestImageName provides the function 'test_save_plot_displayed()'.
        #include("test_save_plot_displayed.jl")
        #using .TestSavePlotDisplayed: test_save_plot_displayed # Access the function
        
    # ==============================================================================
    # ========================== Hard-Coded Circuit ================================
    # ==============================================================================

        """
            Hard-coded circuit for testing purposes.

        The circuit is the following:

        N4 --- N5 -- N6
         |     |     | 
         |     N7    |
         |     |     | 
        N3 --- N2 -- N1

        Edge list: 
            -E1: (N1, N2), 
            -E2: (N2, N3), 
            -E3: (N3, N4), 
            -E4: (N4, N5), 
            -E5: (N5, N6), 
            -E6: (N6, N1), 
            -E7: (N5, N7), 
            -E8: (N7, N2)
        """
        # Create a circuit hard-coded
        circuit = Circuit([
            Node(id = 1, x = 1, y =-1),  # Node N1 at ( 1,-1)
            Node(id = 2, x =-1, y =-1),  # Node N2 at ( 0,-1)
            Node(id = 2, x =-1, y =-1),  # Node N3 at (-1,-1)
            Node(id = 3, x =-1, y = 1),  # Node N4 at (-1, 1)
            Node(id = 4, x = 0, y = 1),  # Node N5 at ( 0, 1)
            Node(id = 5, x = 1, y = 1),  # Node N6 at ( 1, 1)
            Node(id = 6, x = 0, y = 0)   # Node N7 at ( 0, 0)
            ], [], SimpleGraph())

        # Create an edge info hard-coded
        edge_info = EdgeInfo([])

        # Add edges to the edge info
        push!(edge_info.edges, (1, 2))
        push!(edge_info.edges, (2, 3))
        push!(edge_info.edges, (3, 4))
        push!(edge_info.edges, (4, 5))
        push!(edge_info.edges, (5, 6))
        push!(edge_info.edges, (6, 1))
        push!(edge_info.edges, (5, 7))
        push!(edge_info.edges, (7, 2))

        # Add edges to the circuit
        add_edge!(circuit.graph, 1, 2)
        add_edge!(circuit.graph, 2, 3)
        add_edge!(circuit.graph, 3, 4)
        add_edge!(circuit.graph, 4, 5)
        add_edge!(circuit.graph, 5, 6)
        add_edge!(circuit.graph, 6, 1)
        add_edge!(circuit.graph, 5, 7)
        add_edge!(circuit.graph, 7, 2)      

    # ==============================================================================
    # ===================== Testing Module CheckingNodesInput ======================
    # ==============================================================================

        # Test module 'CheckingNodesInput'
        #println("\nRunning tests for module 'CheckingNodesInput'...")

        # Test 'is_valid_format()' of submodule 'InputFormatCheck' of module 'CheckingNodesInput'
        #println("\nRunning tests for submodule 'InputFormatCheck'...")    
        #test_is_valid_format()

        # Test 'is_coordinate_available(circuit)' of submodule 'CoordinateAvailabilityCheck' of module 'CheckingNodesInput'
        #println("\nRunning tests for submodule 'CoordinateAvailabilityCheck'...")
        #test_is_coordinate_available(circuit)

    # ==============================================================================
    # ====================== Testing Module OverlappingCheck =======================
    # ==============================================================================

        # Test module 'OverlappingCheck'
        println("\nRunning tests for module OverlappingCheck...")

        # Test 'overlapping_check()'
        test_overlapping_check(circuit, edge_info)

    # ==============================================================================
    # =========================== Testing Module Saving ============================
    # ==============================================================================

        #println("\nRunning tests for Module Saving...")

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

# ---------------------------------------------------------------------------- #
################################################################################
# ================== End Of Tests Of Circuit-Plotter Program ================= #
################################################################################
# ---------------------------------------------------------------------------- #