Process:

Download the XML files and unzip them to your local machine

Change the path variables in Python (already in notebook) to wherever you store all the XML files:
from irsx.settings import IRSX_SETTINGS_LOCATION, IRSX_CACHE_DIRECTORY 
# IRSX_SETTINGS_LOCATION
# IRSX_CACHE_DIRECTORY
IRSX_CACHE_DIRECTORY = 'C:\\Users\\jared\Documents\\NW\\1_courses\\6_498_Capstone\\0_final_project\\2_foundations\\data'
# IRSX_CACHE_DIRECTORY
IRSX_WORKING_DIRECTORY = 'C:\\Users\\jared\Documents\\NW\\1_courses\\6_498_Capstone\\0_final_project\\2_foundations\\data\\filings'
IRSX_WORKING_DIRECTORY



Running the above will create "XML" and "CSV" folders in your working_directory. Move all the unzipped XML files into that "XML" folder, but make sure they are not separated into folders (i.e. no sub-folders in the "XML" folder... limitation of package)
- make sure the names are in the format of "objectID_public" (e.g. "202213159339300321_public" for the B&M Gates Foundation)

Run code