# ==============================================================================
# ==============================================================================
# ============================= Module_Saving.jl ===============================
# ==============================================================================
# ==============================================================================

"""
    Module: Saving

Author: Michelangelo Dondi
Date: 22-10-2023
Description:
    Dedicated to saving plots generated by the Circuit Visualization Tool.
    This module simplifies the saving process by providing a single function to call.

Version: 2.7
License: MIT License

Exported functions:
- `save_plot_displayed(circuit)`: Saves the plot displayed into an "Images" directory. 
If no plot is rendered, the plot is first drawn and then saved. The user is prompted 
to provide a filename for the plot. If no filename is provided, a default filename 
"circuit_plot.png" is used. If the provided filename does not have an extension, 
".png" is appended to the filename. The plot is saved in the "Images" directory. 
If the "Images" directory does not exist, it is created.
"""
module Saving

    # ==============================================================================
    # =========================== Exported Function ================================
    # ==============================================================================
        
        # Invoke this function to export the save_plot_displayed function
        export save_plot_displayed

    # ==============================================================================
    # ========================= Imported Data Structure ============================
    # ==============================================================================

        # For housing the data structures used by the Circuit Plotter Program
        import Main: Circuit

    # ==============================================================================
    # ============================ Required Packages ===============================
    # ==============================================================================

        # For saving plots
        using Plots
    
    # ==============================================================================
    # =========================== Included Modules =================================
    # ==============================================================================  

        # Module_Plotting.jl provides functions for drawing the current circuit plot.
        include("Module_Plotting.jl")
        using .Plotting: draw_plot # Draw the current circuit plot

    # ==============================================================================
    # ====================== function save_plot_displayed ==========================
    # ==============================================================================

        """
        save_plot_displayed(circuit) -> nothing

        Saves the current plot into an "Images" directory. If no plot is rendered, 
        the plot is first drawn and then saved. The user is prompted to provide a
        filename for the plot. If no filename is provided, a default filename 
        "circuit_plot.png" is used. If the provided filename does not have an   
        extension, ".png" is appended to the filename. The plot is saved in the
        "Images" directory. If the "Images" directory does not exist, it is created.

        Parameters:
        - circuit: The circuit to draw and save.

        Returns:
        - nothing
        """
        function save_plot_displayed(circuit::Circuit, io::IO=stdin)

            # Ensure that the plot is rendered
            _ensure_plot_exists(circuit)

            # Determine paths
            project_dir = joinpath(@__DIR__, "..")   # Project root directory

            # Ensure that the "Images" directory exists and create it if it does not
            images_dir = _ensure_images_directory(project_dir)
            
            # Generate filename
            filename = _generate_filename(io)

            # Generate filepath
            filepath = joinpath(images_dir, filename)
                
            # Save the plot and provide feedback to user
            Plots.savefig(filepath)
            println("Circuit plot saved as '$filepath'.")
            return filepath
        end

    # ==============================================================================
    # ========================= function _ensure_plot_exists =======================
    # ==============================================================================

        """
            _ensure_plot_exists(circuit) -> nothing

        Ensures that a plot exists for the specified circuit. If no plot exists, 
        a plot is drawn.

        Parameters:
        - circuit: The circuit to draw and save.

        Returns:
        - nothing
        """
        function _ensure_plot_exists(circuit::Circuit)

            # Ensure that the plot is rendered
            try

                # Attempt to get the current plot
                plot = Plots.current()

            # If no plot is rendered, draw the plot
            catch

                # Provide feedback to user
                println("\nNo plot is currently rendered. Drawing the plot now.")

                # Draw the plot
                draw_plot(circuit)
            end
        end

    # ==============================================================================
    # -------------------- function _ensure_images_directory -----------------------
    # ==============================================================================

        """
            _ensure_images_directory(base_dir::String) -> String

        Ensures that an "Images" directory exists within the specified base directory.
        Returns the path to the "Images" directory.

        Parameters:
        - base_dir: The base directory to check for the existence of an "Images" directory.

        Returns:
        - The path to the "Images" directory.
        """
        function _ensure_images_directory(base_dir::String)
            images_path = joinpath(base_dir, "Images")
            if !isdir(images_path)
                mkdir(images_path)
            end
            return images_path
        end    

    # ==============================================================================
    # ------------------------ function _generate_filename -------------------------
    # ==============================================================================

        """
            _generate_filename() -> String

        Ask the user for a filename to save the plot as. If no filename is provided, 
        a default filename "circuit_plot.png" is used.    

        Parameters:
        - None
            
        Returns:
        - The generated filename.
        """
        function _generate_filename(io::IO=stdin)
            println("\nEnter a filename for the circuit plot")
            println("Otherwise, press Enter to use the default (default: circuit_plot.png).")
            filename = readline(io)

            # If filename is empty, use the default filename
            if filename == ""
                return "circuit_plot.png"
            end
            
            # If filename does not have an extension, append ".png"
            if !contains(filename, r"\.\w+$")  # Regular expression check for file extension
                filename = filename * ".png"
            end

            return filename
        end 
end