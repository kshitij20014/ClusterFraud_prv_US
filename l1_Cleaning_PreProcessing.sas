*option obs = 10000; 

* Adding some of my macros ;

%include '/folders/myfolders/Macros/kssrtsum.sas' ;

* removing blank npi's;

data sasdata.npi_presc_clean; 
set sasdata.npi_presc_drug_summary;
if npi not in (""," ",".");
if bene_count not in ("."," ","");
if bene_count_ge65 not in ("."," ","");
run; 

* feature selection - as in choosing important features for our model ;

data sasdata.npi_presc_clean2 (keep = npi nppes_provider_city nppes_provider_state specialty_description drug_name
 generic_name bene_count total_claim_count total_30_day_fill_count total_day_supply  total_drug_cost bene_count_ge65 
 total_claim_count_ge65 total_30_day_fill_count_ge65 total_day_supply_ge65 total_drug_cost_ge65); 
set sasdata.npi_presc_clean;
run;



* drop repeat values; 
proc sql;
create table sasdata.npi_presc_uni as
select distinct 
npi,
nppes_provider_city,
nppes_provider_state,
specialty_description,
drug_name,
generic_name,
bene_count,
total_claim_count, 
total_30_day_fill_count,
total_day_supply,
total_drug_cost,
bene_count_ge65,
total_claim_count_ge65,
total_30_day_fill_count_ge65,
total_day_supply_ge65,
total_drug_cost_ge65
from sasdata.npi_presc_clean2;
quit;


* sort + Roll up;
*Macro created is a compination of proc sort then followed by proc summary ;
 
%kssrtsum(sasdata.npi_presc_uni, npi npi nppes_provider_city nppes_provider_state specialty_description drug_name generic_name,
bene_count total_claim_count total_30_day_fill_count total_day_supply  total_drug_cost bene_count_ge65 total_claim_count_ge65 
total_30_day_fill_count_ge65 total_day_supply_ge65 total_drug_cost_ge65, sasdata.npi_presc_clean_rolled);

