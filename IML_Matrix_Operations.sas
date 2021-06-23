proc iml;

A = {1 2,3 4};
print A;

/*Multiplication by a Scalar*/
B = 3*A;
print "Multiplication by a Scalar 3*A";
print  B;

/*Matrix Multiplication */
C = A*B;
print "Matrix Multiplication A*B";
Print C;

/*Division by a Scalar*/
D = A/3;
print "Division by a Scalar A/3";
print D;

/*Transpose*/
AT = A`;
print "A Transpose";
print AT;

/*Inverse*/
Ainv = inv(A);
print "A Inverse";
print Ainv;

run;