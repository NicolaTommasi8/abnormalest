*! abnormalest v0.3.1 (May 2024)
*! Francesca Rossignoli (francesca.rossignoli@univr.it) - Nicola Tommasi (nicola.tommasi@univr.it)

* version 0.3.1  may2024 - fix moremata update problem
* version 0.3    nov2022 - Francy & Nick revision
* version 0.2.1  oct2022 - add sample selection for ebal model - fix() option
* version 0.2    sep2022 - add ebal model and some options
* version 0.1    18jul2022

program abnormalest, rclass
version 15

syntax varlist(numeric fv ts min=2) [if] [in] [fweight aweight pweight iweight],  ///
       condvars(varlist fv min=1) abnvar(name) [ estvar(name) MODel(string) minobs(integer 0) ///
       NOCONStant Quantile(real 0.5) ///
       TARgets(numlist >0 <=3 integer) MAXIter(integer 20) TOLerance(real .015) fix(varlist) debug]
marksample touse
tempvar valobs comb_condvars tmppred missflag valobs outcome stroutcome adjr2 probf treat /*notreat*/ _webal


/******************
 ****  CHECKS  ****
 ******************/
if "`model'"=="" local model "ols"
if inlist("`model'","ols","qreg","ebal")!=1 {
  di as error "Error in model specification. Possible options for model specification are ols (defaul), qreg or ebal"
  exit 498
}

if "`model'"=="qreg" & "`noconstant'"!="" {
  di as error "noconstant option not applicable in qreg model"
  exit 498
}

capture which ebalance
if _rc==111 {
  di in yellow "ebalance not installed.... installing..."
  ssc inst ebalance
}
capture ssc desc moremata
if _rc==601 {
  di in yellow "moremata not installed.... installing..."
  ssc inst moremata
}

/****
capture ssc inst moremata
if _rc==602 {
  di "moremata update available"
  di "You can type <ssc inst moremata, replace> in Command bar to update moremata"
}
****/


if "`model'"=="ebal" & "`fix'"!="" {
  foreach V of varlist `fix' {
    local check : list V & condvars
    capture assert "`check'"!=""
    if _rc {
      di as error "vars in fix() must be part of condvars ()"
      exit  498
    }
  }

  if `:word count `fix'' == `:word count `condvars'' {
    if `: list fix === condvars ' == 1 di as error "vars in fix() must be part of condvars()"
    exit 498
  }
}
**end checks



if `quantile'==0.5 local quantile "quantile(0.5)"
else  local quantile "quantile(`quantile')"

if "`targets'"!="" local targets "targets(`targets')"
local maxiter "maxiter(`maxiter')"
local tolerance "tolerance(`tolerance')"


gettoken depvar indeps : varlist
_fv_check_depvar `depvar'
local n_of_indeps : word count `indeps'

**Theoretical minimum obs
** #indeps + intercept + 1
qui regress `depvar' `indeps', `noconstant'
local th_minobs = `e(df_m)'+1
if `minobs'<`th_minobs' local minobs = `th_minobs'

di _newline(2)
local n_of_cv : word count `condvars'
forvalues i=1/`n_of_cv' {
  local cv`i' : word `i' of `condvars'
  qui levelsof `cv`i'' if `touse', local(lev_cv`i') clean
  di as result "Conditional var #`i': `cv`i''"
  di as text "Levels of `cv`i'': "
  di as text "`lev_cv`i''"
  di _newline(1)
}


**CHECK MISSING IN depvar AND indeps
qui recode `touse' (1=0) (0=1), gen(`missflag')
qui egen `valobs' = total(`missflag'==0) if `touse', by(`condvars')
qui egen `comb_condvars' = group(`condvars') if `touse' & `missflag'==0, label lname(`comb_condvars')
if "`estvar'"=="" local estvar "est_`depvar'"

**Regress section
di as result "I'm performing regressions... please wait!"
qui gen double `estvar'=.
qui gen double `outcome'=0 if `touse'
qui gen double `adjr2'=.
qui gen double `probf'=.
if "`model'"=="ebal" {
  tempvar notreat
  qui gen `notreat'=.
}
qui levelsof `comb_condvars', local(levels)
local nreg = r(r)
nois _dots 0, title(Looping until `nreg' regressions)
local rep 1
foreach l of local levels {
  local status 0
  local idreg : label (`comb_condvars') `l', strict
  if "`model'"=="ols" {
    qui summ `valobs'  if `touse' & `comb_condvars'==`l'
    if "`debug'"!="" di _newline(2) "Regression `l' of `nreg': `idreg' - `r(mean)' - `minobs'"
    if `r(mean)' < `minobs' {
      qui replace `outcome'=1  if `touse' & `comb_condvars'==`l'
      local status = 1
    }
    else {
        qui regress `depvar' `indeps'  if `touse' & `comb_condvars'==`l' [`weight' `exp'], `noconstant'
      if _rc!=0 {
        qui replace `outcome'=2  if `touse' & `comb_condvars'==`l'
        local status = 3
      }
      else {
        qui cap predict double `tmppred' if `touse' & `comb_condvars'==`l'
        qui cap replace `estvar' = `tmppred'  if `touse' & `comb_condvars'==`l'
        qui drop `tmppred'
        qui replace `adjr2'=e(r2_a) if `touse' & `comb_condvars'==`l'
        qui replace `probf'=Ftail(e(df_m),e(df_r),e(F)) if `touse' & `comb_condvars'==`l'
      }
    }
  }

  else if "`model'"=="qreg" {
    qui summ `valobs'  if `touse' & `comb_condvars'==`l'
    if "`debug'"!="" di _newline(2) "Regression `l' of `nreg': `idreg' - `r(mean)' - `minobs'"
    if `r(mean)' < `minobs' {
      qui replace `outcome'=1  if `touse' & `comb_condvars'==`l'
      local status = 1
    }
    else {
      cap qreg `depvar' `indeps'  if `touse' & `comb_condvars'==`l' [`weight' `exp'], `quantile'
      if _rc!=0 {
        qui replace `outcome'=2  if `touse' & `comb_condvars'==`l'
        local status = 3
      }
      else {
        qui cap predict `tmppred' if `touse' & `comb_condvars'==`l'
        qui cap replace `estvar' = `tmppred'  if `touse' & `comb_condvars'==`l'
        qui drop `tmppred'
        qui replace `adjr2'=e(r2_p) if `touse' & `comb_condvars'==`l'
      }
    }

  }

  else if "`model'"=="ebal" {
    qui summ `valobs'  if `touse' & `comb_condvars'==`l'
    if "`debug'"!="" di _newline(2) "Entropy balancing regression `l' of `nreg': `idreg' - `r(mean)' - `minobs'"
    if `r(mean)' < `minobs' {
      qui replace `outcome'=1  if `touse' & `comb_condvars'==`l'
      local status = 1
    }

    else {
      qui gen `treat'=(`touse' & `comb_condvars'==`l')
      if "`fix'"!="" {
        foreach V of varlist `fix' {
          qui levelsof `V' if `comb_condvars'==`l', local(value) clean
          if substr("`:type `V''",1,3) == "str" qui replace `treat'=. if `treat'==0 & `V'!="`value'"
          else                                  qui replace `treat'=. if `treat'==0 & `V'!=`value'
        }
       if "`debug'"!="" {
         fre `treat'
         di "treat 1"
         fre  `comb_condvars' if `treat'==1
         di "treat 0"
         fre  `comb_condvars' if `treat'==0
       }
     }
      qui count if `treat'==0
      qui replace `notreat'=r(N) if `touse' & `comb_condvars'==`l'


      qui ebalance `treat' `indeps', `targets' `tolerance' `maxiter' generate(`_webal')
      if `e(convg)' == 0 {
        qui replace `outcome'=3  if `touse' & `comb_condvars'==`l'
        drop `treat'
        local status = 3
      }
      else {
        qui regress `depvar' `treat' `indeps'  if `touse' [aweight=`_webal'], `noconstant'
        if _rc!=0 {
          qui replace `outcome'=2  if `touse' & `comb_condvars'==`l'
          local status = 3
        }
        else {
          qui cap predict double `tmppred' if `touse' & `comb_condvars'==`l'
          qui cap replace `estvar' = `tmppred'  if `touse' & `comb_condvars'==`l'
          qui drop `tmppred'
          qui replace `adjr2'=e(r2_a) if `touse' & `comb_condvars'==`l'
          qui replace `probf'=Ftail(e(df_m),e(df_r),e(F)) if `touse' & `comb_condvars'==`l'
        }
      }
      capture drop `_webal' `treat'
    }
  }

  nois _dots `rep++' `status'
}
di _newline "x means Insuf. obs, n fail in regression"

if "`abnvar'"!="" qui gen double `abnvar'=`depvar'-`estvar' if `touse'



/*** OUTPUT SECTION ***/
preserve
qui drop if `comb_condvars'==.
collapse (count) `missflag' (mean) `outcome' `adjr2' `probf' `notreat' if `touse', by(`comb_condvars')
label define `outcome' 0 "OK" 1 "Insuff. obs" 2 "Reg. fail" 3 "ebalance fail"
label values `outcome' `outcome'
label var `outcome' "Regressions outcome"
qui decode `outcome', gen(`stroutcome')
qui count
local N = r(N)
di _newline "Minimum number of obs: `minobs'"
di "Theoric minimum number of obs: `th_minobs'"
di "Conditional vars: `condvars'"

**fre `outcome'
qui count if `outcome'==0
local ok=r(N)
qui count if `outcome'==1
local insuf=r(N)
qui count if `outcome'==2
local fail=r(N)
qui count if `outcome'==3
local failebal=r(N)

di _newline(2) "OK regressions: `ok'"
di "No reg. by insuf obs.: `insuf'"
if "`model'"=="ebal" di "Failed ebalance convergence: `failebal'"
di "Failed regressions: `fail'"

local lablen=17 /*leng inte col #1*/
qui label list `comb_condvars'
forvalues i=1(1)`r(max)' {
  local tmp : label (`comb_condvars') `i', strict
  local strlen : strlen local tmp
  if `strlen'>`lablen' local lablen = `strlen'
}
local lablen=`lablen'+2 /*white space*/
if `lablen'>30 local lablen=30
**abbrev("`: word `i' of `varlist''",13) _col(15)
local h1 = `lablen'
if inlist("`model'","ols","ebal")  local h2 = 61
else if "`model'"=="qreg"          local h2 = 52
local p1 = `lablen'+1
local p2 = `p1'+2
local p3 = `p2'+20
local p4 = `p3'+22
local p5 = `p4'+10

local r1 = `p1'+6
local r2 = `r1'+16
local r3 = `r2'+21
local r4 = `r3'+11

di _newline(2)
di as text "{hline `h1'}{c TT}{hline `h2'}"
if inlist("`model'","ols","ebal")  di "Conditional vars"    _col(`p1') "{c |}"  _col(`p2') "Valid obs."      _col(`p3') "Reg. outcome"          _col(`p4') "Adj Rsq"            _col(`p5') "Prob > F"
else if "`model'"=="qreg"          di "Conditional vars"    _col(`p1') "{c |}"  _col(`p2') "Valid obs."      _col(`p3') "Reg. outcome"          _col(`p4') "Pseudo R2"
di as text "{hline `h1'}{c +}{hline `h2'}"

forvalues i=1(1)`N' {
  local col1 : label (`comb_condvars') `i', strict
  local col2 = `missflag' in  `i'
  if "`model'"=="ebal" {
    local nnt = `notreat' in `i'
    if `nnt'!=. local col2ebal = "`col2' (`nnt')"
    else local col2ebal = "`col2'"
  }
  local col3 = `stroutcome' in `i'
  local col4 = `adjr2' in `i'
  local col4 : display %8.4f `col4'
  local col5 = `probf' in `i'
  local col5 : display %8.4f `col5'
  if "`model'"=="ols" {
    if `col2'<`minobs' | "`col3'"!="OK" di in red   "`col1'" _col(`p1') "{c |}" _col(`r1') "`col2'" _col(`r2') "`col3'" _col(`r3') "`col4'" _col(`r4') "`col5'"
    else                                di in green "`col1'" _col(`p1') "{c |}" _col(`r1') "`col2'" _col(`r2') "`col3'" _col(`r3') "`col4'" _col(`r4') "`col5'"
  }
  else if "`model'"=="ebal" {
    if `col2'<`minobs' | "`col3'"!="OK" di in red   "`col1'" _col(`p1') "{c |}" _col(`r1') "`col2ebal'" _col(`r2') "`col3'" _col(`r3') "`col4'" _col(`r4') "`col5'"
    else                                di in green "`col1'" _col(`p1') "{c |}" _col(`r1') "`col2ebal'" _col(`r2') "`col3'" _col(`r3') "`col4'" _col(`r4') "`col5'"
  }
  else {
    if `col2'<`minobs' | "`col3'"!="OK" di in red   "`col1'" _col(`p1') "{c |}" _col(`r1') "`col2'" _col(`r2') "`col3'" _col(`r3') "`col4'"
    else                                di in green "`col1'" _col(`p1') "{c |}" _col(`r1') "`col2'" _col(`r2') "`col3'" _col(`r3') "`col4'"
  }

}
di as text "{hline `h1'}{c BT}{hline `h2'}"
if "`model'"=="ebal" di "In brackets observations in control group"
end
exit


