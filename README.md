# abnormalest
A Stata package to estimate abnormal measures

by Francesca Rossingoli & Nicola Tommasi


## Installation
The package can be installed via GitHub.

```
net install abnormalest, from("https://raw.githubusercontent.com/NicolaTommasi8/abnormalest/master/") replace
```

## Syntax
```
abnormalest depvar indepvars [if] [in] [weight], condvar(varlist) abnvar(varname)
  [ estvar(varname) model(string) minobs(#) noconstant quantile(#) targets(options)
    iterate(integer) btolerance(#) ptolerance(#) difficult fix(varlist2) ]
```

See the help file `help abnormalest` for details.

### Options
`condvar(varlist)` variables identifying the control sample observations whereon to predict the
normal measure

`abnvar(varname)` variable generated as the difference between the reported measure in the treated
sample depvar and the predicted measure in the control sample estvar

`estvar(varname)` estimated variable for depvar obtained from the estimation model used

`model(ststring)` estimation model. Available alternatives: model(ols|qreg|ebal). Default is
model(ols)

`minobs(#)` imposes the minimum number of observations to execute the conditional estimation.
Default minimum is equal to the estimation model degrees + 1 e(df m)+1 in the models(ols)
or model(qreg), and to the minimum number of observations in the treated sample for the
model(ebal)

`noconstant` omits constant term in the conditional estimation model

`quantile(#)` estimate # quantile; default is quantile(.5). model(qreg) is required

`targets(options)` specify types of moments to be balanced; default is targets(mean). Possible options are: mean (the default), variance (implies mean), skeweness (implies mean and
variance) and covariance (implies mean). model(ebal) is required

`iterate(integer)` specifies the maximum number of iterations; default is iterate(300). model(ebal)
is required

`btolerance(#)` sets the balancing tolerance. Balance is achieved if the balancing loss is smaller
than the balancing tolerance. The default is btolerance(1e-6). model(ebal) is required

`ptolerance(#)` specifies the convergence tolerance for the coefficient vector.
The default is ptolerance(1e-6). model(ebal) is required

`difficult` use a different stepping algorithm in nonconcave regions. model(ebal) is required

`fix(varlist2)` allows selecting the control units fixing one or more conditions to be met. Variables
in varlist2 must be a subgroup of condvar(varlist) variables. model(ebal) is required

Note on fix() option. By default, the treated observations are those meeting each of the combina-
tions of the imposed conditions. The control units are selected as the residual observations discarding
those meeting each of the combinations of the imposed conditions. Given a treated unit meeting a
combination of the imposed conditions, the control units are the residual observations. Using fix()
option, the control units are the non-treated observations showing in correspondence to the fixed
conditions the same values as the treated observations. For example, being the treated observations
those located in Thaiwan, operating in industry 7 in year 2019 by option condvar(country year
industry1d), fixing the condition fix(country) means selecting all the control units located in
Thaiwan discarding the treated units identified by the combination of the imposed conditions.

## Examples
Load the Stata dataset

```
use abnormal_red.dta, clear
```

and let's test the `abnormalest` command:

```
. abnormalest total_accruals_scaled intercept_scaled delta_REV_scaled PPE_scaled, ///
>   condvars(industry1d year country) estvar(est1a) abnvar(abn1a) minobs(7)

Conditional var #1: industry1d
Levels of industry1d: 
5 7 8 9

Conditional var #2: year
Levels of year: 
2019 2020 2021

Conditional var #3: country
Levels of country: 
CHN CYM KOR TWN

I'm performing regressions... please wait!
Looping until 45 regressions
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
.....................................x..x.xxx
x means Insuf. obs, n fail in regression

Minimum number of obs: 7
Theoric minimum number of obs: 4
Conditional vars: industry1d year country

OK regressions: 40
No reg. by insuf obs.: 5
Failed regressions: 0

---------------------------------------------------------------------------------
Conditional vars   | Valid obs.          Reg. outcome          Adj Rsq   Prob > F
-------------------+-------------------------------------------------------------
5 2019 CHN         |     157             OK                     0.0199     0.1087
5 2019 CYM         |     105             OK                     0.2497     0.0000
5 2019 KOR         |     57              OK                     0.1363     0.0129
5 2019 TWN         |     107             OK                     0.4166     0.0000
5 2020 CHN         |     154             OK                     0.3507     0.0000
5 2020 CYM         |     100             OK                     0.1137     0.0022
5 2020 KOR         |     60              OK                     0.0186     0.2604
5 2020 TWN         |     106             OK                     0.3754     0.0000
5 2021 CHN         |     104             OK                     0.2109     0.0000
5 2021 CYM         |     65              OK                     0.1405     0.0065
5 2021 KOR         |     54              OK                    -0.0058     0.4489
5 2021 TWN         |     101             OK                     0.0994     0.0043
7 2019 CHN         |     263             OK                     0.0651     0.0001
7 2019 CYM         |     139             OK                     0.0783     0.0029
7 2019 KOR         |     154             OK                     0.0863     0.0009
7 2019 TWN         |     103             OK                     0.0940     0.0051
7 2020 CHN         |     251             OK                     0.0574     0.0005
7 2020 CYM         |     136             OK                     0.0377     0.0447
7 2020 KOR         |     159             OK                    -0.0087     0.6523
7 2020 TWN         |     104             OK                    -0.0102     0.5836
7 2021 CHN         |     182             OK                     0.0508     0.0064
7 2021 CYM         |     87              OK                     0.1892     0.0001
7 2021 KOR         |     145             OK                     0.0084     0.2432
7 2021 TWN         |     89              OK                     0.0039     0.3482
8 2019 CHN         |     103             OK                    -0.0083     0.5424
8 2019 CYM         |     47              OK                     0.2601     0.0011
8 2019 KOR         |     27              OK                    -0.0345     0.5551
8 2019 TWN         |     21              OK                     0.0945     0.2057
8 2020 CHN         |     97              OK                    -0.0176     0.7199
8 2020 CYM         |     48              OK                     0.0081     0.3482
8 2020 KOR         |     29              OK                     0.6382     0.0000
8 2020 TWN         |     21              OK                    -0.1013     0.7641
8 2021 CHN         |     70              OK                     0.2105     0.0003
8 2021 CYM         |     26              OK                     0.0332     0.3039
8 2021 KOR         |     28              OK                     0.1552     0.0715
8 2021 TWN         |     20              OK                    -0.0157     0.4617
9 2019 CHN         |     8               OK                     0.8584     0.0119
9 2019 CYM         |     2               Insuff. obs                 .          .
9 2019 KOR         |     7               OK                    -0.0950     0.5604
9 2020 CHN         |     7               OK                    -0.4497     0.7763
9 2020 CYM         |     2               Insuff. obs                 .          .
9 2020 KOR         |     7               OK                     0.5274     0.1805
9 2021 CHN         |     2               Insuff. obs                 .          .
9 2021 CYM         |     2               Insuff. obs                 .          .
9 2021 KOR         |     4               Insuff. obs                 .          .
---------------------------------------------------------------------------------
```

The output shows the levels of the conditional variables and, subsequently, the looping progress
and the estimation results. Alternative results of each regression are: ”Ok regressions”, indicating
the regressions correctly estimated, ”No reg. by insuf. obs.”, indicating the number of not-executed
regressions because of insufficient number of observations and ”Failed regressions”, indicating the
number of regressions executed but failed to produce the estimated parameters. The final table
shows for each combination of the conditional variables, the number of observations meeting the
specific combination of the conditional variables, the regression outcomes, and, for the OLS models,
the adjusted R-square and the Prob. F statistic, while for the qreg model only the Pseudo R-square
is available.

In the second example, we apply the command to Jones’ approach using the
quantile regression as the estimation model:

```
. abnormalest total_accruals_scaled intercept_scaled delta_REV_scaled PPE_scaled, ///
>   condvars(industry1d year country) estvar(est2a) abnvar(abn2a) minobs(7) model(qreg)

Conditional var #1: industry1d
Levels of industry1d: 
5 7 8 9

Conditional var #2: year
Levels of year: 
2019 2020 2021

Conditional var #3: country
Levels of country: 
CHN CYM KOR TWN

I'm performing regressions... please wait!
Looping until 45 regressions
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
.....................................xnnxnxxx
x means Insuf. obs, n fail in regression

Minimum number of obs: 7
Theoric minimum number of obs: 4
Conditional vars: industry1d year country

OK regressions: 37
No reg. by insuf obs.: 5
Failed regressions: 3

------------------------------------------------------------------------
Conditional vars   | Valid obs.          Reg. outcome          Pseudo R2
-------------------+----------------------------------------------------
5 2019 CHN         |     157             OK                     0.0191
5 2019 CYM         |     105             OK                     0.2240
5 2019 KOR         |     57              OK                     0.0493
5 2019 TWN         |     107             OK                     0.1908
5 2020 CHN         |     154             OK                     0.0520
5 2020 CYM         |     100             OK                     0.0942
5 2020 KOR         |     60              OK                     0.0724
5 2020 TWN         |     106             OK                     0.2747
5 2021 CHN         |     104             OK                     0.1760
5 2021 CYM         |     65              OK                     0.0856
5 2021 KOR         |     54              OK                     0.0386
5 2021 TWN         |     101             OK                     0.1824
7 2019 CHN         |     263             OK                     0.0467
7 2019 CYM         |     139             OK                     0.0342
7 2019 KOR         |     154             OK                     0.0390
7 2019 TWN         |     103             OK                     0.0490
7 2020 CHN         |     251             OK                     0.0525
7 2020 CYM         |     136             OK                     0.0122
7 2020 KOR         |     159             OK                     0.0166
7 2020 TWN         |     104             OK                     0.0179
7 2021 CHN         |     182             OK                     0.0447
7 2021 CYM         |     87              OK                     0.0627
7 2021 KOR         |     145             OK                     0.0238
7 2021 TWN         |     89              OK                     0.0521
8 2019 CHN         |     103             OK                     0.0233
8 2019 CYM         |     47              OK                     0.1847
8 2019 KOR         |     27              OK                     0.0821
8 2019 TWN         |     21              OK                     0.1373
8 2020 CHN         |     97              OK                     0.0361
8 2020 CYM         |     48              OK                     0.0741
8 2020 KOR         |     29              OK                     0.1929
8 2020 TWN         |     21              OK                     0.0884
8 2021 CHN         |     70              OK                     0.0816
8 2021 CYM         |     26              OK                     0.0171
8 2021 KOR         |     28              OK                     0.2487
8 2021 TWN         |     20              OK                     0.1237
9 2019 CHN         |     8               OK                     0.6798
9 2019 CYM         |     2               Insuff. obs                 .
9 2019 KOR         |     7               Reg. fail                   .
9 2020 CHN         |     7               Reg. fail                   .
9 2020 CYM         |     2               Insuff. obs                 .
9 2020 KOR         |     7               Reg. fail                   .
9 2021 CHN         |     2               Insuff. obs                 .
9 2021 CYM         |     2               Insuff. obs                 .
9 2021 KOR         |     4               Insuff. obs                 .
------------------------------------------------------------------------
```

In case of ebalance model, the output is similar to the one of the OLS model; additionally
the number of observations counted in the control group is shown in brackets. In this example
some estimations fail in estimating the regression (Insuff. obs) because of insufficient observations
in the control sample. The researcher might be willing to force the estimation aggregating some
observations. For example, aggregating by industry and year, relaxing the country condition would
allow to pull together the observations in industry and year regardless the country. In this case,
the aggregation by industry and year would allow for treated observations in industry 9 and in year
2019 to be matched with a control sample including observations in CYM and KOR. As well as for
treated observation in industry 9 and in year 2021 to be matched with a control sample including
observations in CHN, CYM and KOR.

Fails in regression might be resolved by increasing maximum number of iterations (option `iterate()`)
or increasing tolerance level (`ptolerance()`).

```
. clonevar country_aggr=country

. replace country_aggr="KOR-CYM" if inlist(country,"CYM","KOR") & year==2019 & industry1d==9
variable country_aggr was str3 now str7
(10 real changes made)

. replace country_aggr="KOR-CYM-CHN" if inlist(country,"CYM","KOR","CHN") & year==2021 & industry1d==9
variable country_aggr was str7 now str11
(13 real changes made)

. 
. abnormalest total_accruals_scaled intercept_scaled delta_REV_scaled PPE_scaled, ///
>   condvars(industry1d year country_aggr) estvar(est3a_aggr) abnvar(abn3a_aggr) ///
>   minobs(7) model(ebal)

Conditional var #1: industry1d
Levels of industry1d: 
5 7 8 9

Conditional var #2: year
Levels of year: 
2019 2020 2021

Conditional var #3: country_aggr
Levels of country_aggr: 
CHN CYM KOR KOR-CYM KOR-CYM-CHN TWN

I'm performing regressions... please wait!
Looping until 42 regressions
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
.......................................x..
x means Insuf. obs, n fail in regression

Minimum number of obs: 7
Theoric minimum number of obs: 4
Conditional vars: industry1d year country_aggr

OK regressions: 41
No reg. by insuf obs.: 1
Failed ebalance convergence: 0
Failed regressions: 0

----------------------------------------------------------------------------------
Conditional vars    | Valid obs.          Reg. outcome          Adj Rsq   Prob > F
--------------------+-------------------------------------------------------------
5 2019 CHN          |     157 (4144)      OK                     0.0369     0.0000
5 2019 CYM          |     105 (4196)      OK                     0.1705     0.0000
5 2019 KOR          |     57 (4244)       OK                     0.0848     0.0000
5 2019 TWN          |     107 (4194)      OK                     0.1675     0.0000
5 2020 CHN          |     154 (4147)      OK                     0.1667     0.0000
5 2020 CYM          |     100 (4201)      OK                     0.1113     0.0000
5 2020 KOR          |     60 (4241)       OK                     0.0488     0.0000
5 2020 TWN          |     106 (4195)      OK                     0.1116     0.0000
5 2021 CHN          |     104 (4197)      OK                     0.1271     0.0000
5 2021 CYM          |     65 (4236)       OK                     0.1033     0.0000
5 2021 KOR          |     54 (4247)       OK                     0.0755     0.0000
5 2021 TWN          |     101 (4200)      OK                     0.0877     0.0000
7 2019 CHN          |     263 (4038)      OK                     0.0257     0.0000
7 2019 CYM          |     139 (4162)      OK                     0.0642     0.0000
7 2019 KOR          |     154 (4147)      OK                     0.0527     0.0000
7 2019 TWN          |     103 (4198)      OK                     0.0947     0.0000
7 2020 CHN          |     251 (4050)      OK                     0.0382     0.0000
7 2020 CYM          |     136 (4165)      OK                     0.0676     0.0000
7 2020 KOR          |     159 (4142)      OK                     0.0155     0.0000
7 2020 TWN          |     104 (4197)      OK                     0.0272     0.0000
7 2021 CHN          |     182 (4119)      OK                     0.0452     0.0000
7 2021 CYM          |     87 (4214)       OK                     0.0791     0.0000
7 2021 KOR          |     145 (4156)      OK                     0.0198     0.0000
7 2021 TWN          |     89 (4212)       OK                     0.0499     0.0000
8 2019 CHN          |     103 (4198)      OK                     0.0259     0.0000
8 2019 CYM          |     47 (4254)       OK                     0.1553     0.0000
8 2019 KOR          |     27 (4274)       OK                     0.0774     0.0000
8 2019 TWN          |     21 (4280)       OK                     0.0872     0.0000
8 2020 CHN          |     97 (4204)       OK                     0.0171     0.0000
8 2020 CYM          |     48 (4253)       OK                     0.0674     0.0000
8 2020 KOR          |     29 (4272)       OK                     0.2954     0.0000
8 2020 TWN          |     21 (4280)       OK                     0.0434     0.0000
8 2021 CHN          |     70 (4231)       OK                     0.0814     0.0000
8 2021 CYM          |     26 (4275)       OK                     0.1221     0.0000
8 2021 KOR          |     28 (4273)       OK                     0.1236     0.0000
8 2021 TWN          |     20 (4281)       OK                     0.0503     0.0000
9 2019 CHN          |     8 (4293)        OK                     0.1820     0.0000
9 2019 KOR-CYM      |     9 (4292)        OK                     0.1444     0.0000
9 2020 CHN          |     7 (4294)        OK                     0.0328     0.0000
9 2020 CYM          |     2               Insuff. obs                 .          .
9 2020 KOR          |     7 (4294)        OK                     0.1321     0.0000
9 2021 KOR-CYM-CHN  |     8 (4293)        OK                     0.0953     0.0000
----------------------------------------------------------------------------------
In brackets observations in control group
```





