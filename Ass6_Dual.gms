$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

Pamela Claure
liliana.claure@usu.edu

$offtext

* 1. DEFINE the SETS
SETS plnt crops growing /Hay, Grain/
     res resources /Land, Water_Jun, Water_Jul, Water_Aug/;

* 2. DEFINE input data
PARAMETERS
   c(plnt) Objective function coefficients (Area per crop)
         /Hay 100,
         Grain 120/
   b(res) Right hand constraint values (per resource)
          /Land 10000,
           Water_Jun  14000,
           Water_Jul 18000,
           Water_Aug 6000/;

TABLE A(plnt,res) Left hand side constraint coefficients
             Land    Water_Jun     Water_Jul    Water_Aug
 Hay          1        2              1            1
Grain         1        1              2            0;

* 3. DEFINE the variables
VARIABLES X(plnt) area planted (Acres)
          VPROFIT  total profit ($)
          Y(res)  value of resources used (units specific to variable)
          VREDCOST total reduced cost ($);

* Non-negativity constraints
POSITIVE VARIABLES X,Y;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT_PRIMAL Total profit ($) and objective function value
   RES_CONS_PRIMAL(res) Resource constraints
   REDCOST_DUAL Reduced Cost ($) associated with using resources
   RES_CONS_DUAL(plnt) Profit levels ;

*Primal Equations
PROFIT_PRIMAL..                 VPROFIT =E= SUM(plnt,c(plnt)*X(plnt));
RES_CONS_PRIMAL(res) ..    SUM(plnt,A(plnt,res)*X(plnt)) =L= b(res);

*Dual Equations
REDCOST_DUAL..                 VREDCOST =E= SUM(res,b(res)*Y(res));
RES_CONS_DUAL(plnt)..          sum(res,A(plnt,res)*Y(res)) =G= c(plnt);

* 5. DEFINE the MODELS
*PRIMAL model
MODEL PLANT_PRIMAL /PROFIT_PRIMAL, RES_CONS_PRIMAL/;
*Set the options file to print out range of basis information
PLANT_PRIMAL.optfile = 1;

*DUAL model
MODEL PLANT_DUAL /REDCOST_DUAL, RES_CONS_DUAL/;

* 6. SOLVE the MODELS
* Solve the PLANTING PRIMAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_PRIMAL USING LP MAXIMIZING VPROFIT;

* Solve the PLANTING DUAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_DUAL USING LP MINIMIZING VREDCOST;
*Order does not matter!

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file

* 7 . Dump all data and results to GAMS proprietary file storage .gdx and to Excel
Execute_Unload "Ass6_Dual.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xlsAss6_Dual.gdx"
* To open the GDX file in the GAMS IDE, select File => Open.
* In the Open window, set Filetype to .gdx and select the file.
