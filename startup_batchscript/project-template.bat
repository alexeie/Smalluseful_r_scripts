@echo off

cls
mode con: Cols=75 Lines=15
Title Prosjekt-initiering

SET YEAR=%date:~-4,10%
SET MD=%date:~3,2%

@echo Project template script by Alexander K Eieland date 20.Sept.2019
@echo.
@echo The Year is %YEAR%, Month %MD%

set /p requestee="Enter Name: "
set /p project="Enter Project Name: "

MkDir "%requestee%_%YEAR%\%MD%_%project%"

copy project_template_files\project_template.Rmd %requestee%_%YEAR%\%MD%_%project%\
copy project_template_files\project_template.R %requestee%_%YEAR%\%MD%_%project%\

project_template_files\find_and_replace_text.exe %requestee%_%YEAR%\%MD%_%project%\project_template.Rmd PROJECT_TITLE %project%
project_template_files\find_and_replace_text.exe %requestee%_%YEAR%\%MD%_%project%\project_template.R PROJECT_TITLE %project%
project_template_files\find_and_replace_text.exe %requestee%_%YEAR%\%MD%_%project%\project_template.Rmd PROJECT_STARTUP_DATE %DATE%
project_template_files\find_and_replace_text.exe %requestee%_%YEAR%\%MD%_%project%\project_template.R PROJECT_STARTUP_DATE %DATE%

cd /d "%requestee%_%YEAR%\%MD%_%project%\"


MkDir "doc"
MkDir "input_data"
MkDir "output_data"
MkDir "results"
MkDir "results\figures"
MkDir "sensitive"
MkDir "src"
MkDir "temp_files"
rename "project_template.Rmd" "%project%.Rmd"
rename "project_template.R" "%project%.R"

@echo ----------------------------------------------------------------------------------
@echo New project folder located at: C:\Users\aleeie\Documents\R-projects\%requestee%_%YEAR%\%MD%_%project%\

TIMEOUT 10
