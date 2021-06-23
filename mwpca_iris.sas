cas;
caslib _all_ assign;
libname mycas cas;

data mycas.iris;
   set sashelp.iris;
   id = _n_;
run;

ods noproctitle;

proc mwpca data=MYCAS.IRIS stepsize=10 windowsize=50;
	id id;
	output out=CASUSER.movingpca_output standardpc npc=4;
run;

ods noproctitle;

proc pca data=MYCAS.IRIS outstat=CASUSER.pca_statistics plots=(scree 
		patternprofile);
	var SepalLength SepalWidth PetalLength PetalWidth;
	output out=CASUSER.pca_component score copyvars=(_all_);
run;