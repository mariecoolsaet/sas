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

data mysas.animals;
	 length animal $ 18;
	 array letters[18] $ 1 ('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L'
	 'M' 'N' 'O' 'P' 'Q' 'R');
	 drop letters: i j seed;
	 seed = 4;
	 do i = 1 to 1E6;
	 call ranperm(seed, of letters[*]);
	 animal = cat(of letters[*]);
	 do j = 1 to 100;
	 weight = rand('uniform');
	 output;
	 end;
	 end;
run;

proc casutil;
 	load data=mysas.animals outcaslib=casuser;
quit;


/*****************************************************************************/
/*  Terminate the specified CAS session (mySession). No reconnect is possible*/
/*****************************************************************************/

cas mySession terminate;
