$ontext
CEE 6410 - Water Resources Systems Analysis
Example 7.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

Pamela Claure
liliana.claure@usu.edu
$offtext

* 1. Define sets
Sets
Source         Water Source / Res "Reservoir", Pmp "Pump", Rvr "River", Frm "Farm"/
Period         Time period /s1, s2/
VolumeLevels   Reservoir volumes /Cap0, Cap1, Cap2/;

* 2. Define input data
Parameters

Res_Vol_Cap(VolumeLevels)    Reservoir capacity (acft) /Cap0 0, Cap1 300, Cap2 700/
Res_Vol_Cost(VolumeLevels)   Reservoir capital cost ($ per year) /Cap0 0, Cap1 6000, Cap2 10000/
Rvr_Inflow(Period)           River inflows (acft) /s1 600, s2 200/
Irr_Demand(Period)           Irrigation demands (ac-ft per acre) /s1 1, s2 3/;

Scalars
Pump_MaxFlow                Pump capacity (acft per season) /396/
Pump_CostCapital             Pump capital cost ($ per year) /8000/
Pump_CostOperating           Pump operational cost ($ per ac-ft) /20/
Groundwater_Inflow           Groundwater base flow increase (ac-ft per season) /360/
Revenue_Per_Acre             Revenue ($ per acre irrigated per year) /300/;

* 3. Define variables
Variables

Flow(Source, Period)        Water flows at different sources (ac-ft)
Reservoir_Built(Source, VolumeLevels) Binary variable for reservoir construction (1 = yes 0 = no)
Pump_Installed(Source)      Binary decision to build pump (1 = yes 0 = no)
Irrigated_Area              Total area irrigated (acres)
Total_Cost                  Total system costs (capital and operational) ($);

Binary variables Reservoir_Built, Pump_Installed;
Positive variables Flow, Irrigated_Area;

* 4. Define equations
Equations
Obj_Cost                       Objective function and total cost ($)
Pump_Limit(Period)             Maximum allowable pumping capacity (ac-ft)
Reservoir_Constraint           Only one reservoir option can be built
Res_Vol_Limit(Period)          Reservoir capacity constraint (ac-ft)
Mass_Balance_River(Period)     Mass balance for river flows (ac-ft)
Mass_Balance_Reservoir_Init    Initial mass balance at the reservoir (ac-ft)
Mass_Balance_Reservoir(Period) Reservoir mass balance for subsequent periods (ac-ft)
Irrigation_Calculation(Period) Calculating the irrigated area (acres);

Obj_Cost ..                    Total_Cost =e= (Revenue_Per_Acre * Irrigated_Area) 
                                    - sum(VolumeLevels, Res_Vol_Cost(VolumeLevels) * Reservoir_Built('Res', VolumeLevels)) 
                                    - Pump_CostCapital * Pump_Installed('Pmp') 
                                    - sum(Period, Pump_CostOperating * Flow('Pmp', Period));
                                    
Pump_Limit(Period)..            Flow('Pmp', Period) =l= Pump_MaxFlow * Pump_Installed('Pmp');
Reservoir_Constraint..          1 =e= sum(VolumeLevels, Reservoir_Built('Res', VolumeLevels));
Res_Vol_Limit(Period)..         Flow('Res', Period) =l= sum(VolumeLevels, Res_Vol_Cap(VolumeLevels) * Reservoir_Built('Res', VolumeLevels));
Mass_Balance_River(Period)..    Flow('Pmp', Period) =l= Flow('Rvr', Period) + Groundwater_Inflow;
Mass_Balance_Reservoir_Init..   Flow('Res', 's1') =e= Rvr_Inflow('s1') - Flow('Rvr', 's1') - Flow('Frm', 's1');
Mass_Balance_Reservoir(Period)$(ord(Period) ge 2).. 
                                Flow('Res', Period) =e= Rvr_Inflow(Period) 
                                    + Flow('Res', Period - 1) 
                                    - Flow('Rvr', Period) 
                                    - Flow('Frm', Period);
Irrigation_Calculation(Period)..Irrigated_Area =l= (Flow('Frm', Period) + Flow('Pmp', Period)) / Irr_Demand(Period);

* 5. Define the model
Model WaterSystem /all/;

* 6. Solve the model
SOLVE WaterSystem USING MIP MAXIMIZE Total_Cost;