* Reservoir Operation Optimization

Sets
    t /1*6/; 

Parameters
    inflow(t) / 1 2, 2 2, 3 3, 4 4, 5 3, 6 2 /     
    hp_benefit(t) / 1 1.6, 2 1.7, 3 1.8, 4 1.9, 5 2.0, 6 2.0 /  
    ir_benefit(t) / 1 1.0, 2 1.2, 3 1.9, 4 2.0, 5 2.2, 6 2.2 / ;

Scalar
    max_storage  /9/  
    init_storage /5/  
    min_flow     /1/  
    turb_capacity /4/ ;

Variables
    storage(t)        * Storage at the end of each month
    hp_release(t)     * Water released through turbines for hydropower
    ir_release(t)     * Water released for irrigation
    spill(t)          * Water spilled (bypassed turbine)
    flow_A(t)        * Minimum flow at point A
    total_benefit    * Total economic benefit;

Positive Variables storage, hp_release, ir_release, spill, flow_A;

Equations
    obj                   * Objective function
    mass_balance_first     * Mass balance equation for the first month
    mass_balance_rest(t)   * Mass balance equation for months > 1
    turb_capacity_con(t)   * Limit on turbine capacity
    min_flow_con(t)       * Minimum flow in the river
    storage_limit_con(t)   * Storage cannot exceed capacity
    end_storage_con        * Ending storage must be at least as much as the initial storage
    irrigation_release(t)  * Value of irrigation at each month;

* Objective: Maximize total economic benefit
obj ..
    total_benefit =e= sum(t, hp_benefit(t) * hp_release(t) + ir_benefit(t) * ir_release(t));

* Mass balance for the first month (Month 1)
mass_balance_first ..
    storage('1') =e= init_storage + inflow('1') - hp_release('1') - spill('1');

* Mass balance for the remaining months (Month 2 to 6)
mass_balance_rest(t)$(ord(t) > 1) ..
    storage(t) =e= storage(t-1) + inflow(t) - hp_release(t)  - spill(t);
    
* Defining irrigation release
irrigation_release(t) ..
    ir_release(t) =e= spill(t) + hp_release(t) - flow_A(t);
    
* Flow at A minimum value
 min_flow_con(t) ..
 flow_A(t) =g= min_flow;

* Turbine capacity constraint
turb_capacity_con(t) ..
    hp_release(t) =l= turb_capacity;

* Storage limit: cannot exceed maximum storage
storage_limit_con(t) ..
    storage(t) =l= max_storage;

* Ending storage must be at least as much as the initial storage
end_storage_con ..
    storage('6') =g= init_storage;


* Solve the LP model
Model ReservoirOptimization /all/;
Solve ReservoirOptimization using lp maximizing total_benefit;








