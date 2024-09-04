import glob
import os
import pandas as pd
import xml.etree.ElementTree as ET

def extract_from_csv(file_to_process): 
    try:
        dataframe = pd.read_csv(file_to_process) 
        return dataframe

    except Exception as exp:
        return("Error occured in read csv")


def extract_from_json(file_to_process):
    try:
        dataframe = pd.read_json(file_to_process,lines=True)
        return dataframe
    except Exception as exp:
        return(f"Error occured in read json: {exp}")


def extract_from_xml(file_to_process):
    try:
        dataframe = pd.DataFrame(columns=['car_model','year_of_manufacture','price', 'fuel'])
        tree = ET.parse(file_to_process) 
        root = tree.getroot()

        for i, child in enumerate(root): 
            car_model = child.find("car_model").text 
            year_of_manufacture = int(child.find("year_of_manufacture").text)
            price = float(child.find("price").text) 
            fuel = child.find("fuel").text
            new_data = pd.DataFrame([{
                "car_model": car_model,
                "year_of_manufacture": year_of_manufacture,
                "price": price,
                "fuel": fuel
            }])
            
            dataframe = pd.concat([dataframe, new_data], ignore_index=True)

        return dataframe

    except Exception as exp:
        return(f"Error occured in read xml: {exp}")


def extract_batch_files(source_dir):
    try:
        relative_path = source_dir
        # Prepare the dataFrame
        extracted_data = pd.DataFrame(columns=['car_model','year_of_manufacture','price', 'fuel', 'year_of_selling'])

        #for csv files
        for csvfile in glob.glob(f"{relative_path}/*.csv"):
            extracted_data = pd.concat([extracted_data, extract_from_csv(csvfile)], ignore_index=True)

        #for json files
        for jsonfile in glob.glob(f"{relative_path}/*.json"):
            extracted_data = pd.concat([extracted_data, extract_from_json(jsonfile)], ignore_index=True)

        #for xml files
        for xmlfile in glob.glob(f"{relative_path}/*.xml"):
            extracted_data = pd.concat([extracted_data, extract_from_xml(xmlfile)], ignore_index=True)
        
        return extracted_data

    except Exception as exp:
        return(f"Error occured in extract_batch_files: {exp}")


if __name__ == '__main__':
    cwd = os.getcwd()
    source_dir = f"{cwd}/source_data/data_files/dealership_data"
    df = extract_batch_files(source_dir)
    print(f"dataFrame shape: {df.shape}")
    print("Extracted data Frame: ", df.head(10))

