cas; 
caslib _all_ assign;


proc iml;
use casuser.APPRENTICESHIP_AGG;        /* open the data set */
read all var {"NOngoing" "NCompleted" "NDiscontinued"}; /* read 3 vars into vectors */
close casuser.APPRENTICESHIP_AGG;      /* close the data set */

Total = NOngoing + NCompleted + NDiscontinued;
mean = mean(Total);
print mean;

proc iml;
varNames =  {"AgeMean" "AgeSD" "NOngoing" "NCompleted" "NDiscontinued" "DurationMean"};   /* these vars have the same type */
use CASUSER.APPRENTICESHIP_AGG;        /* open the data set */
read all var varNames into X;            /* read vars into matrix */
close CASUSER.APPRENTICESHIP_AGG;        /* close the data set */

mean = mean(X);                          /* mean of each column */
corr = corr(X);                          /* correlation matrix */
print mean[colname=varNames],
      corr[colname=varNames rowname=varNames];