* After cleaning processing, now processing the data for building model. ;

proc print data=sasdata.npi_presc_clean_rolled (obs=10);

* adjusting "." sas nulls as zero;
* By default all numerical nulls in SAS have "." as placeholders. To use this in python, we need to convert them;

data sasdata.npi_final; 
set sasdata.npi_presc_clean_rolled;
array change _numeric_;
        do over change;
            if change=. then change=0;
        end;
run;

proc export data = sasdata.npi_final outfile = "/folders/myfolders/Data/npi_final.csv"
dbms = csv replace;
run; 
