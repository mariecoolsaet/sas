/* Create a library reference to the server path folder */
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

/*
proc casutil;
	droptable casdata="Readmissions_All" incaslib="demodata" quiet;
	load data=mysas.Readmissions_All casout="Readmissions_All" outcaslib="demodata" replace; 
quit;
*/

/* Do nothing but print available # of threads for Data step 
In BASE SAS # of threads = 1 */
/*
data _null_;
   put "Processed on " _threadid_= _nthreads_=;
run;

data _null_/sessref="MySession";
   put "Processed on " _threadid_= _nthreads_=;
run;
*/

Proc contents data=mysas.Readmissions_All;
run;

data work.AddSuperRegion;
   set mysas.Readmissions_All end=eof;
     select('Hospital Region'n);
      when ('NE', 'NW') 
           'Super Region'n="North";   
      when ("SW", "SE") 
           'Super Region'n="South";
      when ("CE") 
           'Super Region'n="Central";
      otherwise 'Super Region'n='Unknown';
   end;
   if eof then put _threadid_=   _N_=;
run;


data casuser.AddSuperRegion;
   set demodata.Readmissions_All end=eof;
     select('Hospital Region'n);
      when ('NE', 'NW') 
           'Super Region'n="North";   
      when ("SW", "SE") 
           'Super Region'n="South";
      when ("CE") 
           'Super Region'n="Central";
      otherwise 'Super Region'n='Unknown';
   end;
   if eof then put _threadid_=   _N_=;
run;

/* Calculating running total by Hospital */
proc sort data=mysas.Readmissions_All out=work.Readm2;
    by 'Hospital Name'n;
run;


data work.ReadmTotal;
	set work.Readm2 end=eof;
	by 'Hospital Name'n;
   	if 'first.Hospital Name'n then do;
   		TotalPatients=0;
   		numReadmitted=0;
   	end;
   	TotalPatients+1;
   	numReadmitted+'DV Readmit Flag'n;
   	if 'last.Hospital Name'n then output;
   	keep 'Hospital Name'n 'Hospital State'n TotalPatients numReadmitted;
   	if eof then put _threadid_=   _N_=;
run;

data casuser.ReadmTotal;
	set demodata.Readmissions_All end=eof;
	by 'Hospital Name'n;
   	if 'first.Hospital Name'n then do;
   		TotalPatients=0;
   		numReadmitted=0;
   	end;
   	TotalPatients+1;
   	numReadmitted+'DV Readmit Flag'n;
   	if 'last.Hospital Name'n then output;
   	keep 'Hospital Name'n 'Hospital State'n TotalPatients numReadmitted;
   	if eof then put _threadid_=   _N_=;
run;


/*****************************************************************************/
/*  Terminate the specified CAS session (mySession). No reconnect is possible*/
/*****************************************************************************/

cas mySession terminate;