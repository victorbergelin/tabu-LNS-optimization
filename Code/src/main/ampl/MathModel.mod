## MathModel.mod file
# Model file for aviation problem, most simple mathematical model
# Created by: Claes Arvidson and Akdas Hossain


set G ordered;			#Set of modules (timelines)
set I ordered;			#Set of tasks
set I_g{G} ordered;		#Set of tasks on module g
set D;			#Set of index for dependencies


set S ordered by Reals;
set A1 ordered;
set Listset;


param l{I};	#length of task i
param g{I};	#which timeline task i belongs to
param t_s{I};	#earliest start time for task i
param t_e{I};	#latest end time for task i
param f_min{D};	#shortest distance between dependency D
param f_max{D};	#longest distance between dependency D
param I_df{D};	#from which task, dependency D
param I_dt{D};	#to which task, dependency D

param p{G};
param timelines;
param elements_in_list;
param K_list{S};
param I_list{S};
param J_list{S};

param n;

param a1_violations;
param a2_violations;
param a3_violations;
param a4_violations;
param a5_violations;
param a_violations;

param C1;
param C2;
param C3;
param C4;
param C5;
param count;

param count_comb;

param destroy;
param M;
param randg;
param randi;
param randj;
param cost_C1;
param cost_C2;
param cost_C3;
param cost_C4;
param cost_C5;
param total_violation;
param sum_a1;
param sum_a2;
param sum_a3;
param sum_a4;
param sum_a5;
param current_solution;
param previous_solution;
param destroy_degree;
param min_destroy;
param max_destroy;
param best_solution;
param t0;
param t01;
param time_elapsed;
param number_of_iterations;
param times_at_optima;
param iteration_time;

var u{d in D};	#distance between index i and j in dependency D
var x_s {i in I} >= 0, integer; 	#?!?!?!??
var x_e {i in I} >= 0, integer;
var y {k in G, i in I,j in I} binary;
var y_s {k in G, i in I_g[k]} binary;
var y_e {k in G, i in I_g[k]} binary;
var a1{k in G, i in I_g[k],j in I_g[k]} >= 0, integer;
var a2{i in I} >= 0, integer;
var a3{i in I} >= 0, integer;
var a4{d in D} >= 0, integer;
var a5{d in D} >= 0, integer;

param maxa1;
param mina1;


# Objective function

minimize total_cost:
	 0;


### Constraints ###


subject to first_task{k in G}:
	sum{i in I_g[k]} y_s[k,i] = 1;

subject to last_task{k in G}:
	sum{i in I_g[k]} y_e[k,i] = 1;

subject to check_if_endtask{k in G, i in I_g[k]}:
	sum{j in I_g[k]} y[k,i,j] + y_e[k,i] = 1;

subject to check_if_starttask{k in G, j in I_g[k]}:
	sum{i in I_g[k]} y[k,i,j] + y_s[k,j] = 1;

subject to start_constraint{k in G, i in I_g[k], j in I_g[k]}:
	x_s[j] - x_e[i] + a1[k,i,j] >=  -(t_e[i]-t_s[j])*(1-y[k,i,j]);

subject to task_length{i in I}:
	x_e[i] = x_s[i] + l[i];

subject to task_distance{d in D}:
	x_s[I_dt[d]] = x_e[I_df[d]] + u[d];


subject to interval_constraint1{i in I}:
	t_s[i] + l[i] <= x_e[i] + a2[i];

subject to interval_constraint2{i in I}:
	x_e[i] <= t_e[i] + a3[i];

subject to dependency_constraint1{d in D}:
	u[d] + a4[d] >= f_min[d];	


subject to dependency_constraint2{d in D}:
	u[d] <= f_max[d] + a5[d];

subject to identical_index{k in G, i in I}:
	y[k,i,i] = 0; 

subject to unique_start_end{k in G, i in I_g[k]}:
	y_s[k,i] + y_e[k,i] <= 1;

