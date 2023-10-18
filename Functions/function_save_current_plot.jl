function save_current_plot()
    # Set the working directory to the directory of the script
    cd(@__DIR__)

    # Navigate to the parent directory "Circuit-Plotter" of the current directory 
    # (i.e. the root directory of the project, where the Images directory is located)
    # The ".." is the parent directory of the current directory
    cd("..")

    # Create the Images directory if it doesn't exist
    if !isdir("Images")
        mkdir("Images")
    end

    # Save the plot as an image in the Images directory
    current_date = Dates.now()

    # Convert the current_date to a formatted string
    formatted_date = Dates.format(current_date, "YYYY_MM_DD_HH_MM_SS")
    filename = "circuit_plot_$(formatted_date).png"
    
    Plots.savefig("Images\\$(filename)")
    println("Circuit plot saved as 'Images\\$(filename)'.")
end