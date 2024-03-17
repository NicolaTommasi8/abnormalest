# abnormalest
A Stata package to estimate abnormal measures


## Installation
The package can be installed via GitHub.

```
net install abnormalest, from("https://raw.githubusercontent.com/NicolaTommasi8/abnormalest/master/") replace
```

## Syntax
```
abnormalest depvar indepvars [if] [in] [weight], condvar(varlist)
abnvar(varname) [ estvar(varname) model(string) minobs(#)
noconstant quantile(#) targets(options) iterate(integer)
btolerance(#) ptolerance(#) difficult fix(varlist2) ]
```

