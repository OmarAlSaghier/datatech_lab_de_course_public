

def load_data(data_to_load, targetfile):
    try:
        data_to_load.to_csv(targetfile, index=False)
        return("Saved in: ", targetfile)

    except Exception as exp:
        return(f"Error occured in load batches: {exp}")

    