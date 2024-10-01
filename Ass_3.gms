$ontext
CEE 6410 - Water Resources Systems Analysis
Assignment from problem 2.3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/) 

Pamela Claure
liliana.claure@usu.edu
September 29, 2020
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
VARIABLES X(plnt) Area planted (Acres)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(plnt,c(plnt)*X(plnt));
RES_CONSTRAIN(res) ..    SUM(plnt,A(plnt,res)*X(plnt)) =L= b(res);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;

* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
