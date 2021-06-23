%let path=/users/harsh/pgvy34;
libname mysas "&path";

/*****************************************************************************/
/*  Start a session named mySession using the existing CAS server connection */
/*  while allowing override of caslib, timeout (in seconds), and locale     */
/*  defaults.                                                                */
/*****************************************************************************/

cas mySession sessopts=(caslib=casuser timeout=1800 locale="en_US");

/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas;

caslib _all_ assign;

libname mycas cas caslib=casuser;

proc casutil;
 	load data=mysas.animals outcaslib=casuser;
quit;


proc sort data=mysas.animals out=mysas.animals2; by animal; run;

data mysas.min_weights;
 	 retain min_weight;
	 set mysas.animals2;
	 by animal;
	 if first.animal then min_weight = .;
	 min_weight = min(weight, min_weight);
	 if last.animal then output;
run;

data mycas.min_weights;
 	 retain min_weight;
	 set mycas.animals;
	 by animal;
	 if first.animal then min_weight = .;
	 min_weight = min(weight, min_weight);
	 if last.animal then output;
run;

proc cas;
	partition / table={name="animals"
 	groupby="animal"
	orderby="animal"}
 	casout="animals_part"; 
	run;
quit;

data mycas.min_weights;
 	 retain min_weight;
	 set mycas.animals_part;
	 by animal;
	 if first.animal then min_weight = .;
	 min_weight = min(weight, min_weight);
	 if last.animal then output;
run;

/*****************************************************************************/
/*  Terminate the specified CAS session (mySession). No reconnect is possible*/
/*****************************************************************************/

cas mySession terminate;
