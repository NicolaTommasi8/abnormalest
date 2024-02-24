{smcl}
{hline}
help for {cmd:abnormalest}{right:(Francesca Rossignoli and Nicola Tommasi)}
{hline}

{title:Abnormal Estimation}

{p 8 21 2}
{cmd:abnormalest} depvar indepvars [if] [in] [weight], {opt condvar(varlist)} {opt abnvar(varname)}
                                [ {opt estvar(varname)}
                                {opt mod:el(model)}
                                {opt minobs(integer)}
                                {opt nocons:tant}
                                {opt q:antile(#)}
                                {opt tar:gets(options)}
                                {opt iter:ate(integer)}
                                {opt btol:erance(#)}
                                {opt ptol:erance(#)}
                                {opt dif:ficult}
                                {opt fix(varlist2)}
                                ]


{title:Description}

{pstd}
{cmd:abnormalest} command allows to estimate the abnormal measure as the difference between the
reported and predicted measure. Multiple estimation models are available to predict the measure:
ols, quantile regression and regression preprocessed by entropy balance.


{title:Options for {cmd:abnormalest}}

{synoptset 22 tabbed}{...}
{marker options}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt condvar(varlist)}} variables identifying the control sample observations whereon to predict the normal measure{p_end}
{p2coldent : {opt abnvar(varname)}} variable generated as the difference between the reported measure depvar and the predicted measure estvar{p_end}
{p2coldent : {opt estvar(varname)}}  estimated variable for depvar obtained from the estimation model used{p_end}
{p2coldent : {cmdab:mod:el(ols}|{cmd:qreg}|{cmd:ebal)}} select estimation model. Available alternatives are ols, qreg and ebal. Default is {cmd:model(ols)}{p_end}
{p2coldent : {opt minobs(integer)}} imposes the minimum number of observations to execute the conditional estimation.
   Default minimum is equal to the estimation model degrees + 1 (e(df_m)+1) in the ols and qreg models, and to the minimum number of observations in the treated sample for the ebal model{p_end}
{p2coldent : {opt nocons:tant}} omits constant term in the conditional estimation model{p_end}
{p2coldent : {opt q:antile(#)}} estimate # quantile; default is quantile(.5). {cmd:model(qreg)} is required{p_end}
{p2coldent : {opt tar:gets(options)}} specify types of moments to be balanced; default is targets(mean). Possible options are: mean (the default), variance (implies mean),
  skeweness (implies mean and variance) and covariance (implies mean). {cmd:model(ebal)} is required{p_end}
{p2coldent : {opt iter:ate(integer)}} specifies the maximum number of iterations; default is iterate(300). {cmd:model(ebal)} is required{p_end}
{p2coldent : {opt btol:erance(#)}} sets the balancing tolerance. Balance is achieved if the balancing loss is smaller than the balancing tolerance. The default is btolerance(1e-6). {cmd:model(ebal)} is required{p_end}
{p2coldent : {opt ptol:erance(#)}} specifies the convergence tolerance for the coefficient vector. The default is ptolerance(1e-6). {cmd:model(ebal)} is required{p_end}
{p2coldent : {opt dif:ficult}} use a different stepping algorithm in nonconcave regions. See the {cmd:difficult} option in {helpb maximize}. {cmd:model(ebal)} is required{p_end}
{p2coldent : {opt fix(varlist2)}} allows selecting the control units fixing one or more conditions to be met.
   Variables in {opt varlist2} must be a subgroup of {opt condvar(varlist)} variables. {cmd:model(ebal)} is required{p_end}
{synoptline}
{p2colreset}{...}
{pstd}


{title:Examples}

{phang2}{cmd: use abnormal_red, clear}{p_end}

Jones approach with ols model:
{phang2}{cmd: abnormalest total_accruals_scaled intercept_scaled delta_REV_scaled PPE_scaled, condvars(industry1d year country) estvar(est1a) abnvar(abn1a) minobs(7)}{p_end}

Jones approach with qreg model:
{phang2}{cmd: abnormalest total_accruals_scaled intercept_scaled delta_REV_scaled PPE_scaled, condvars(industry1d year country) estvar(est2a) abnvar(abn2a) minobs(7) model(qreg)}{p_end}

Jones approach with ebalance model:
{phang2}{cmd: abnormalest total_accruals_scaled intercept_scaled delta_REV_scaled PPE_scaled, condvars(industry1d year country) estvar(est3a) abnvar(abn3a) minobs(7) model(ebal)}{p_end}

Jones approach with ebalance model and fix() option:
{phang2}{cmd: abnormalest total_accruals_scaled intercept_scaled delta_REV_scaled PPE_scaled, condvars(industry1d year country) estvar(est3abis) abnvar(abn3abis) minobs(7) model(ebal) fix(country)}{p_end}


{title:Author}
{p 4} Francesca Rossignoli (corresponding author) {p_end}
{p 4} Department of Management {p_end}
{p 4} University of Verona - Italy {p_end}
{p 4} {browse "mailto:francesca.rossignoli@univr.it":francesca.rossignoli@univr.it}

{p 4} Nicola Tommasi {p_end}
{p 4} Interdepartmental Centre of Economic Documentation - C.I.D.E. {p_end}
{p 4} University of Verona - Italy {p_end}
{p 4} {browse "mailto:nicola.tommasi@univr.it":nicola.tommasi@univr.it}



{title:Also see}

{psee}
Manual:  {helpb regress}, {helpb qreg}
{p_end}

{psee}
Online: {helpb ebalance} (if installed)
{p_end}
