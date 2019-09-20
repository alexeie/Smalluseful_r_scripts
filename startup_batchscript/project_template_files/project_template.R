#Project: PROJECT_TITLE
#Date: PROJECT_STARTUP_DATE

# This function sets working directory to the directory 
# where the script executing the file is located
setWdThisDir = function () {
    current_path <- rstudioapi::getActiveDocumentContext()$path
    setwd(dirname(current_path))
    rm(current_path)
}
setWdThisDir()

# Remove  function after execution
rm(setWdThisDir) 
