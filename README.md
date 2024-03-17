# abnormalest
A Stata package to estimate abnormal measures


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
`targets(options)` specify types of moments to be balanced; default is targets(mean). Possi-
ble options are: mean (the default), variance (implies mean), skeweness (implies mean and
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




