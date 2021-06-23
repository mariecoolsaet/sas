proc iml;
use Sashelp.Class;                       /* open the data set */
read all var {"Name" "Height" "Weight"}; /* read 3 vars into vectors */
close Sashelp.Class;                     /* close the data set */

BMI = weight / height##2 * 703;
print BMI[rowname=Name];

proc iml;
varNames =  {"Age" "Height" "Weight"};   /* these vars have the same type */
use Sashelp.Class;                       /* open the data set */
read all var varNames into X;            /* read 3 vars into matrix */
close Sashelp.Class;                     /* close the data set */

mean = mean(X);                          /* mean of each column */
corr = corr(X);                          /* correlation matrix */
print mean[colname=varNames],
      corr[colname=varNames rowname=varNames];