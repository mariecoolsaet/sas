/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas; 
caslib _all_ assign;

/* Create a library reference to the server path folder */
%let path=/users/harsh/pgvy34;
libname mysas "&path";

data demodata.Readmissions_Large;
   n=1;
   set demodata.Readmissions_Final;
   output;
   n=2;
   output;
   n=3;
   output;
   n=4;
   output;
   n=5;
   output;
   n=6;
   output;
   n=7;
   output;
   n=8;
   output;
   n=9;
   output;
   n=10;
   output;
run;

data demodata.Readmissions_All (PROMOTE="YES");
	set demodata.Readmissions_Large;
    Length Patient_ID 8;
	Patient_ID = n*10000000000 + PatientID;
	drop n 'Patient Number'n PatientID;
run;

data mysas.Readmissions_All;
	set demodata.Readmissions_All (datalimit="ALL");
run;




