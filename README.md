# Inhomogeneous-Damping-----Mode-Analysis
use Finite Element Method to solve mode analysis of inhomogeneous damping system

APDL-Task_1.txt contains the code of generating and solving 3-D FEM structural model in Ansys APDL. This script should be executed 
paralleled with "ExportData_10_modes_imag.inp" (export the imaginary part of analyzed 10 modes of FEM physical properties), 
"ExportData_10_modes_real.inp" (.....real part.....), "ExportData_nodes_coord_and_freq.inp" (export the coordinates of finite elements 
as well as their frequences).

As for the other 6 scripts: "calc_SWR_harmonic", "create_M_matrix", "mode2time", "raw_data_processor", "run_the_calculation" and 
"SWR_calculation", you can directly change their "file extension" to ".m" and run them with matlab. These scripts should locate within
the same directory with ".mat" files (Data needed for running these scripts)!

Note that, raw data are initially generated through Ansys APDL！
