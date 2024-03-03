@echo off

REM Get the directory where the batch file is located
set "folder_path=%~dp0"

REM Define the output file
set "output_file=%folder_path%\combined_output.txt"

REM Delete the old output file if it exists
del "%output_file%" 2>nul

REM Loop through each .txt file in the folder and append its contents to the output file
for %%I in ("%folder_path%\*.txt") do (
    echo Combining %%I
    type "%%I" >> "%output_file%"
    echo.>> "%output_file%"
    echo =============================================================================================================>> "%output_file%"
)

echo All files combined into %output_file%
pause