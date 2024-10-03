
-----------------------------------------------------------------
**Program:**
-----------------------------------------------------------------
- Phase_shift.m
- fk_main.m
- tp_main.m
- HRLRT_main.m
- F_J_Main.m
-----------------------------------------------------------------
**Description:**
-----------------------------------------------------------------

Each of these scripts has a main code and a corresponding function code.

1. **f-c transform:** 
   - Main code:     "Phase_shift.m"
   - Function code: "phase_shift_fun.m"

2. **f-k transform:** 
   - Main code:     "fk_main.m"
   - Function code: "fk_fun.p"

3. **t-p transform:** 
   - Main code:     "tp_main.m"
   - Function code: "tp_fun.p"
   - 
4. **HRLRT transform:** 
   - Main code:     "HRLRT_main.m"
   - Function code: "HRLRT_fun.p"
   - 
5. **F-J transform:** 
   - Main code:     "F_J_Main.m"
   - Function code: "FJ_fun.m"
-----------------------------------------------------------------
**Data:**
-----------------------------------------------------------------

The field data used in the study is provided in ".xlsx" format:

1. 'Nandanam_4s_2.5m@1m.xlsx'
2. 'iisc_aerofield_noisy_2s_2.5m@0.5m.xlsx'
3. 'Love_2s_5m@1m.xlsx'

The naming format is: "Description_RecordingTime_SourceOffset@SensorSpacing"

-----------------------------------------------------------------
**How to Run the Code:**
-----------------------------------------------------------------
To run the code, follow these steps:

1. Open the main code file (e.g., 'fk_main.m').
2. Read the data in the "insert data" section.
3. Modify the required parameters as needed.
4. Run the script.

Note: Ensure you have all necessary data files and dependencies in your working directory.
