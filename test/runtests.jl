"""
    File runtests.jl

From this file all tests can be managed
"""

using Test

@testset "Module_Saving Tests" begin
    println("\nRunning tests for Module_Saving...")
    include("test_Module_Saving.jl")
end

println("\nAll tests have concluded.")
