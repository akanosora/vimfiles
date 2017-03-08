" Vim syntax file
" Language:     SAS
" Maintainer:   Zhen-Huan Hu <wildkeny@gmail.com>
" Version:      3.0.0
" Last Change:  Mar 07, 2017
"
" 2017 Mar 7
"
" Rewrite script to improve speed
" Add new keywords introduced in the latest SAS
"
" 2017 Feb 9
"
" Add syntax folding marks
"
" 2016 Oct 10
"
" Add highlighting for functions
"
" 2016 Sep 14
"
" Change the implementation of syntaxing
" macro function names so that macro parameters same
" as SAS keywords won't be highlighted
" (Thank Joug Raw for the suggestion)
" Add section highlighting:
" - Use /** and **/ to define a section
" - It functions the same as a comment but
"   with different highlighting
"
" 2016 Jun 14
"
" Major changes so upgrade version number to 2.0
" Overhaul the entire script (again). Improvements include:
" - Higher precision
" - Faster synchronization
" - Separate color for control statements
" - Hightlight macro variables in double quoted strings
" - Update all syntaxes based on SAS 9.4
" - Add complete SAS/GRAPH and SAS/STAT procedure syntaxes
" - Add Proc TEMPLATE and GTL syntaxes
" - Add complete DS2 syntaxes
" - Add basic IML syntaxes
" - Many other improvements and bug fixes
" Drop support for earlier versions of VIM
"
" 2012 Feb 27
"
" Rewrite the entire matching algorithm
" Add keywords in Base SAS 9.3 and SAS/Stat
" Fix issues in highlighting procedure names and internal variables
" Add highlighting for hash and hiter objects
"
" 2011 Apr 1
"
" Simplify matching algorithm
" Fix mis-matching of some keywords and function names
" Fix an issue caused by multiple comments written at the same line
" Add highlighting for new statements and functions in SAS 9.1/9.2
" Add highlighting for user defined macro functions
" Add highlighting for format tags
"
" 2008 Jul 18 by Paulo Tanimoto <ptanimoto@gmail.com>
"
" Fix comments with asterisks taking multiple lines
" Fix highlighting of macro keywords
" Add words to cases that do not fit anywhere
"
" 2003 Jun 2 by Bob Heckel
"
" Add highlighting for additional keywords and such
" Attempt to match SAS default syntax colors
" Change syncing so it does not lose colors on large blocks
"
" 2001 Sep 26 by James Kidd
"
" Add keywords for use in SAS SQL procedure
" Add highlighting for SAS base procedures
" Add logic to distinqush between versions for SAS macro variable highlighting
" - For SAS 5: Clear all syntax items
" - For SAS 6: Quit when a syntax file was already loaded

if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

" Keywords
syn keyword sasOperator and eq ge gt in le lt ne not of or
syn keyword sasReserved _all_ _automatic_ _char_ _character_ _data_ _infile_ _last_ _n_ _name_ _null_ _num_ _numeric_ _temporary_ _user_ _webout_

" Numbers
syn match sasNumber '\v<\-=%(\d+\.=\d*|\.\d+)%(e\-=\d+)=>' display

" Strings
syn region sasString start=+'+ end=+'+ contains=@Spell
syn region sasString start=+"+ end=+"+ contains=sasMacroVariable,@Spell

" Format tag
syn match sasFormatTag '\v<\$=\K\k*\.\d*\ze%(\H|$)' display contained

" Comments
syn region sasComment start='/\*' end='\*/'
syn region sasComment start='\v%(^|;)\s*\zs\%=\*' end=';'me=s-1
syn region sasSectLbl matchgroup=sasSectLblEnds start='/\*\*\s*' end='\s*\*\*/' concealends

" Functions
syn keyword sasFunctionName abs addr addrlong airy allcomb allperm anyalnum anyalpha anycntrl anydigit anyfirst anygraph anylower anyname anyprint anypunct anyspace anyupper anyxdigit arcos arcosh arsin arsinh artanh atan atan2 attrc attrn band beta betainv blackclprc blackptprc blkshclprc blkshptprc blshift bnot bor brshift bxor byte cat catq cats catt catx cdf ceil ceilz cexist char choosec choosen cinv close cmiss cnonct coalesce coalescec collate comb compare compbl compfuzz compged complev compound compress constant convx convxp cos cosh cot count countc countw csc css cumipmt cumprinc curobs cv daccdb daccdbsl daccsl daccsyd dacctab dairy datdif date datejul datepart datetime day dclose dcreate depdb depdbsl depsl depsyd deptab dequote deviance dhms dif digamma dim dinfo divide dnum dopen doptname doptnum dosubl dread dropnote dsname dsncatlgd dur durp effrate envlen erf erfc euclid exist exp fact fappend fclose fcol fcopy fdelete fetch fetchobs fexist fget fileexist filename fileref finance find findc findw finfo finv fipname fipnamel fipstate first floor floorz fmtinfo fnonct fnote fopen foptname foptnum fpoint fpos fput fread frewind frlen fsep fuzz fwrite gaminv gamma garkhclprc garkhptprc gcd geodist geomean geomeanz getoption getvarc getvarn graycode harmean harmeanz hbound hms holiday holidayck holidaycount holidayname holidaynx holidayny holidaytest hour htmldecode htmlencode ibessel ifc ifn index indexc indexw input inputc inputn int intcindex intck intcycle intfit intfmt intget intindex intnx intrr intseas intshift inttest intz iorcmsg ipmt iqr irr jbessel juldate juldate7 kurtosis lag largest lbound lcm lcomb left length lengthc lengthm lengthn lexcomb lexcombi lexperk lexperm lfact lgamma libname libref log log1px log10 log2 logbeta logcdf logistic logpdf logsdf lowcase lperm lpnorm mad margrclprc margrptprc max md5 mdy mean median min minute missing mod modexist module modulec modulen modz month mopen mort msplint mvalid contained
syn keyword sasFunctionName n netpv nliteral nmiss nomrate normal notalnum notalpha notcntrl notdigit note notfirst notgraph notlower notname notprint notpunct notspace notupper notxdigit npv nvalid nwkdom open ordinal pathname pctl pdf peek peekc peekclong peeklong perm pmt point poisson ppmt probbeta probbnml probbnrm probchi probf probgam probhypr probit probmc probnegb probnorm probt propcase prxchange prxmatch prxparen prxparse prxposn ptrlongadd put putc putn pvp qtr quantile quote ranbin rancau rand ranexp rangam range rank rannor ranpoi rantbl rantri ranuni rename repeat resolve reverse rewind right rms round rounde roundz saving savings scan sdf sec second sha256 sha256hex sha256hmachex sign sin sinh skewness sleep smallest soapweb soapwebmeta soapwipservice soapwipsrs soapws soapwsmeta soundex spedis sqrt squantile std stderr stfips stname stnamel strip subpad substr substrn sum sumabs symexist symget symglobl symlocal sysexist sysget sysmsg sysparm sysprocessid sysprocessname sysprod sysrc system tan tanh time timepart timevalue tinv tnonct today translate transtrn tranwrd trigamma trim trimn trunc tso typeof tzoneid tzonename tzoneoff tzones2u tzoneu2s uniform upcase urldecode urlencode uss uuidgen var varfmt varinfmt varlabel varlen varname varnum varray varrayx vartype verify vformat vformatd vformatdx vformatn vformatnx vformatw vformatwx vformatx vinarray vinarrayx vinformat vinformatd vinformatdx vinformatn vinformatnx vinformatw vinformatwx vinformatx vlabel vlabelx vlength vlengthx vname vnamex vtype vtypex vvalue vvaluex week weekday whichc whichn wto year yieldp yrdif yyq zipcity zipcitydistance zipfips zipname zipnamel zipstate contained
syn keyword sasCallRoutineName allcomb allcombi allperm cats catt catx compcost execute graycode is8601_convert label lexcomb lexcombi lexperk lexperm logistic missing module poke pokelong prxchange prxdebug prxfree prxnext prxposn prxsubstr ranbin rancau rancomb ranexp rangam rannor ranperk ranperm ranpoi rantbl rantri ranuni scan set sleep softmax sortc sortn stdize streaminit symput symputx system tanh tso vname vnext wto contained
syn match sasFunctionHead '\v<\w+\(' display transparent contained contains=sasFunctionName,sasCallRoutineName
syn region sasFunction start='\v<\w+\(' end=')' contains=@sasBasicSyntax,sasFunctionHead
syn region sasMacroFunc matchgroup=sasMacroFuncName start='\v\%\w+\ze\(' end=')'me=s-1 contains=@sasBasicSyntax

" Macros
syn match sasMacroVariable '\v\&+\w+%(\.\w+)=' display
syn match sasMacroReserved '\v\%%(abort|by|copy|display|do|else|end|global|goto|if|include|input|let|list|local|macro|mend|put|return|run|symdel|syscall|sysexec|syslput|sysrput|then|to|until|window|while)>' display

" Syntax cluster for basic SAS syntaxes
syn cluster sasBasicSyntax contains=sasOperator,sasReserved,sasNumber,sasString,sasFormatTag,sasComment,sasFunction,sasMacroReserved,sasMacroFunc,sasMacroVariable,sasSectLbl

" Define global statements that can be accessed out of data step or procedures
syn keyword sasGlobalStatementKeyword catname dm endsas filename footnote footnote1 footnote2 footnote3 footnote4 footnote5 footnote6 footnote7 footnote8 footnote9 footnote10 missing libname lock options page quit resetline run sasfile skip sysecho title title1 title2 title3 title4 title5 title6 title7 title8 title9 title10 contained
syn match sasGlobalStatement '\v%(^|;)\s*\zs\w+>' display transparent contains=sasGlobalStatementKeyword
" Define ODS statements that can be accessed out of data steps or procedures
syn keyword sasODSStatementKeyword ods chtml csvall docbook document escapechar exclude graphics html3 html htmlcss imode listing markup output package path pcl pdf preferences phtml printer proclabel proctitle ps results rtf select show tagsets trace usegopt verify wml contained
syn match sasODSStatment '\v%(^|;)\s*\zsods%(\s+\w+)=>' display transparent contains=sasODSStatementKeyword

" Data step statements, 9.4
syn keyword sasDataStepControl by continue do else end go goto if leave link otherwise over return select then to until when while contained
syn keyword sasDataStepStatementKeyword abort array attrib by call cards cards4 datalines datalines4 delete describe display drop error execute file format infile informat input keep label length lines lines4 list lostcard merge modify output put putlog redirect remove rename replace retain set stop update where window contained
syn match sasDataStepStatement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasDataStepStatementKeyword,sasGlobalStatementKeyword
syn keyword sasDataStepStatementHashKeyword dcl declare hash hiter javaobj contained
syn match sasDataStepStatement '\v%(^|;)\s*\zs%(dcl|declare)%(\s+\w+)=>' display transparent contained contains=sasDataStepStatementHashKeyword
syn region sasDataStep matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsdata>' end='\v%(^|;)\s*%(data|endsas|proc|run)>'me=s-1 fold contains=@sasBasicSyntax,sasDataStepControl,sasDataStepStatement

" Procedures, base SAS, 9.4
syn keyword sasProcStatementKeyword abort age append array attrib audit block break by calid cdfplot change checkbox class classlev column compute contents copy create datarow dbencoding define delete deletefunc deletesubr delimiter device dialog dur endcomp exact exchange exclude explore fin fmtlib fontfile fontpath format formats freq function getnames guessingrows hbar hdfs histogram holidur holifin holistart holivar id idlabel informat inset invalue item key keylabel keyword label line link listfunc listsubr mapmiss mapreduce mean menu messages meta modify opentype outargs outdur outfin output outstart pageby partial picture pie pig plot ppplot printer probplot profile prompter qqplot radiobox ranks rbreak rbutton rebuild record remove rename repair report roptions save select selection separator source star start statistics struct submenu subroutine sum sumby table tables test text trantab truetype type1 types value var vbar ways weight where with write contained
syn match sasProcStatement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasProcStatementKeyword,sasGlobalStatementKeyword
syn region sasProc matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsproc%(\s+\w+)>' end='\v%(^|;)\s*%(data|endsas|proc|quit|run)>'me=s-1 fold contains=@sasBasicSyntax,sasProcStatement

" Procedures, ODS graphics, 9.4
syn keyword sasODSGraphicsProcStatementKeyword band block bubble colaxis compare dattrvar density dot dropline dynamic ellipse ellipseparm fringe gradlegend hbar hbarbasic hbarparm hbox heatmap heatmapparm highlow histogram hline inset keylegend lineparm loess matrix needle parent panelby pbspline plot polygon refline reg rowaxis scatter series spline step style styleattrs symbolchar symbolimage text vbar vbarbasic vbarparm vbox vector vline waterfall xaxis x2axis yaxis y2axis yaxistable contained
syn match sasODSGraphicsProcStatement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasODSGraphicsProcStatementKeyword,sasGlobalStatementKeyword
syn region sasODSGraphicsProc matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsproc\s+%(sgdesign|sgpanel|sgplot|sgrender|sgscatter)>' end='\v%(^|;)\s*%(data|endsas|proc|quit|run)>'me=s-1 fold contains=@sasBasicSyntax,sasODSGraphicsProcStatement

" Procedures, SAS/GRAPH, 9.4
syn keyword sasGraphProcStatementKeyword add area axis bar block bubble2 byline cc ccopy cdef cdelete chart cmap choro copy delete device dial donut exclude flow fs goptions gout grid group hbar hbar3d hbullet hslider htrafficlight id igout legend list modify move nobyline note pattern pie pie3d plot plot2 preview prism quit rename replay select scatter speedometer star surface symbol tc tcopy tdef tdelete template tile toggle treplay vbar vbar3d vtrafficlight vbullet vslider contained
syn match sasGraphProcStatement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasGraphProcStatementKeyword,sasGlobalStatementKeyword
syn region sasGraphProc matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsproc\s+%(g3d|g3grid|ganno|gareabar|gbarline|gchart|gcontour|gdevice|geocode|gfont|ginside|gkpi|gmap|goptions|gplot|gproject|gradar|greduce|gremove|greplay|gslide|gtile|mapimport)>' end='\v%(^|;)\s*%(data|endsas|proc|run)>'me=s-1 fold contains=@sasBasicSyntax,sasGraphProcStatement

" Procedures, SAS/STAT, 14.1
syn keyword sasAnalyticalProcStatementKeyword absorb add array assess baseline bayes beginnodata bivar bootstrap bounds by cdfplot cells class cluster code compute condition contrast control coordinates copy cosan cov covtest coxreg der design determ deviance direct directions domain effect effectplot effpart em endnodata equality estimate exact exactoptions factor factors fcs filter fitindex freq fwdlink gender grid group grow hazardratio height hyperprior id impjoint inset insetgroup invar invlink ippplot lincon lineqs lismod lmtests location logistic loglin lpredplot lsmeans lsmestimate manova matings matrix mcmc mean means missmodel mnar model modelaverage modeleffects monotone mstruct mtest multreg name nlincon nloptions oddsratio onecorr onesamplefreq onesamplemeans onewayanova outfiles output paired pairedfreq pairedmeans parameters parent parms partial partition path pathdiagram pcov performance plot population poststrata power preddist predict predpplot priors process probmodel profile prune pvar ram random ratio reference refit refmodel renameparm repeated replicate repweights response restore restrict retain reweight ridge rmsstd roc roccontrast rules samplesize samplingunit seed size scale score selection show simtests simulate slice std stderr store strata structeq supplementary table tables test testclass testfreq testfunc testid time transform treatments trend twosamplefreq twosamplemeans towsamplesurvival twosamplewilcoxon uds units univar var variance varnames weight where with zeromodel contained
syn match sasAnalyticalProcStatement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasAnalyticalProcStatementKeyword,sasGlobalStatementKeyword
syn region sasAnalyticalProc matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsproc\s+%(aceclus|adaptivereg|anova|bchoice|boxplot|calis|cancorr|candisc|catmod|cluster|corresp|discrim|distance|factor|fastclus|fmm|freq|gam|gampl|gee|genmod|glimmix|glm|glmmod|glmpower|glmselect|hpcandisc|hpfmm|hpgenselect|hplmixed|hplogistic|hpmixed|hpnlmod|hppls|hpprincomp|hpquantselect|hpreg|hpsplit|iclifetest|icphreg|inbreed|irt|kde|krige2d|lattice|lifereg|lifetest|loess|logistic|mcmc|mds|mi|mianalyze|mixed|modeclus|multtest|nested|nlin|nlmixed|npar1way|orthoreg|phreg|plan|plm|pls|power|princomp|prinqual|probit|quantlife|quantreg|quantselect|reg|robustreg|rsreg|score|seqdesign|seqtest|sim2d|simnormal|spp|stdize|stdrate|stepdisc|surveyfreq|surveyimpute|surveylogistic|surveymeans|surveyphreg|surveyreg|surveyselect|tpspline|transreg|tree|ttest|varclus|varcomp|variogram)>' end='\v%(^|;)\s*%(data|endsas|proc|run)>'me=s-1 fold contains=@sasBasicSyntax,sasAnalyticalProcStatement

" Proc TEMPLATE, 9.4
syn keyword sasProcTemplateClause as into
syn keyword sasProcTemplateStatementKeyword block break cellstyle class close column compute continue delete delstream do done dynamic edit else end eval flush footer header import iterate link list mvar ndent next nmvar notes open path put putl putlog putq putstream putvars replace set source stop style test text text2 text3 translate trigger unblock unset xdent
syn keyword sasProcTemplateGTLStatementKeyword axislegend axistable bandplot barchart barchartparm begingraph beginpolygon beginpolyline bihistogram3dparm blockplot boxplot boxplotparm bubbleplot continuouslegend contourplotparm dendrogram discretelegend drawarrow drawimage drawline drawoval drawrectangle drawtext dropline ellipse ellipseparm endgraph endinnermargin endlayout endpolygon endpolyline endsidebar entry entryfootnote entrytitle fringeplot heatmap heatmapparm highlowplot histogram histogramparm innermargin legenditem legendtextitems linechart lineparm loessplot mergedlegend modelband needleplot pbsplineplot polygonplot referenceline regressionplot scatterplot seriesplot sidebar stepplot surfaceplotparm symbolchar symbolimage textplot vectorplot waterfallchart contained
syn match sasProcTemplateStatement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasProcTemplateStatementKeyword,sasProcTemplateGTLStatementKeyword,sasGlobalStatementKeyword
syn keyword sasProcTemplateStatementComplexKeyword define cellvalue column crosstabs event footer header statgraph style table tagset
syn match sasProcTemplateStatement '\v%(^|;)\s*\zsdefine%(\s+\w+)=>' display transparent contained contains=sasProcTemplateStatementComplexKeyword
syn keyword sasProcTemplateGTLStatementComplexKeyword layout datalattice datapanel globallegend gridded lattice overlay overlayequated overlay3d region contained
syn match sasProcTemplateStatement '\v%(^|;)\s*\zslayout%(\s+\w+)=>' display transparent contained contains=sasProcTemplateGTLStatementComplexKeyword
syn region sasProcTemplate matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsproc\s+template>' end='\v%(^|;)\s*%(data|endsas|proc|quit|run)>'me=s-1 fold contains=@sasBasicSyntax,sasProcTemplateClause,sasProcTemplateStatement

" Proc SQL, 9.4
syn keyword sasProcSQLClause add as asc between by calculated cascade case check connection constraint cross delete desc distinct drop else end escape except exists foreign from full group having in inner intersect into is join key left libname like modify natural newline notrim null on order outer references restrict right select separated set then to trimmed union unique update user using values when where contained
syn keyword sasProcSQLStatementKeyword connect delete disconnect execute insert reset select update validate contained
syn match sasProcSQLStatement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasProcSQLStatementKeyword,sasGlobalStatementKeyword
syn keyword sasProcSQLStatementComplexKeyword alter create describe drop index table view contained
syn match sasProcSQLStatement '\v%(^|;)\s*\zs%(alter|create|describe|drop)%(\s+\w+)=>' display transparent contained contains=sasProcSQLStatementComplexKeyword
syn region sasProcSQL matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsproc\s+sql>' end='\v%(^|;)\s*%(data|endsas|proc|quit|run)>'me=s-1 fold contains=@sasBasicSyntax,sasProcSQLClause,sasProcSQLStatement

" SAS/DS2, 9.4
syn keyword sasDS2Control by continue data do else end enddata endpackage endthread from go goto if leave method otherwise package point return select then thread to until when while contained
syn keyword sasDS2StatementKeyword array by forward keep merge output put rename retain set stop vararray varlist contained
syn match sasDS2Statement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasDS2StatementKeyword,sasGlobalStatementKeyword
syn keyword sasDS2StatementComplexKeyword dcl declare drop package thread
syn match sasDS2Statement '\v%(^|;)\s*\zs%(dcl|declare|drop)%(\s+\w+)=>' display transparent contained contains=sasDS2StatementComplexKeyword
syn region sasDS2 matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsproc\s+ds2>' end='\v%(^|;)\s*%(data|endsas|proc|quit|run)>'me=s-1 fold contains=@sasBasicSyntax,sasDS2Control,sasDS2Statement

" SAS/IML, 14.1
syn keyword sasIMLControl abort by do else end finish goto if link pause quit resume return run start stop then to until while contained
syn keyword sasIMLStatementKeyword append close create delete edit find free list load mattrib print purge read reset remove setin setout show sort store use contained
syn match sasIMLStatement '\v%(^|;)\s*\zs\w+>' display transparent contained contains=sasIMLStatementKeyword,sasGlobalStatementKeyword
syn region sasIML matchgroup=sasSectionKeyword start='\v%(^|;)\s*\zsproc\s+iml>' end='\v%(^|;)\s*%(data|endsas|proc|quit)>'me=s-1 fold contains=@sasBasicSyntax,sasIMLControl,sasIMLStatement

" Macro definition
syn region sasMacro start='\v\%macro>' end='\v\%mend>' fold keepend contains=@sasBasicSyntax,sasGlobalStatement,sasODSStatment,sasDataStepControl,sasDataStepStatement,sasDataStep,sasProc,sasODSGraphicsProc,sasGraphProc,sasAnalyticalProc,sasProcTemplate,sasProcSQL,sasDS2,sasIML

" Define default highlighting
hi def link sasComment Comment
hi def link sasSectLbl Title
hi def link sasSectLblEnds Comment
hi def link sasDataStepControl Keyword
hi def link sasProcTemplateClause Keyword
hi def link sasProcSQLClause Keyword
hi def link sasDS2Control Keyword
hi def link sasIMLControl Keyword
hi def link sasOperator Operator
hi def link sasNumber Number
hi def link sasString String
hi def link sasFunctionName Function
hi def link sasCallRoutineName Function
hi def link sasGlobalStatementKeyword Statement
hi def link sasODSStatementKeyword Statement
hi def link sasSectionKeyword Statement
hi def link sasDataStepStatementKeyword Statement
hi def link sasDataStepStatementHashKeyword Statement
hi def link sasProcStatementKeyword Statement
hi def link sasODSGraphicsProcStatementKeyword Statement
hi def link sasGraphProcStatementKeyword Statement
hi def link sasAnalyticalProcStatementKeyword Statement
hi def link sasProcTemplateStatementKeyword Statement
hi def link sasProcTemplateStatementComplexKeyword Statement
hi def link sasProcTemplateGTLStatementKeyword Statement
hi def link sasProcTemplateGTLStatementComplexKeyword Statment
hi def link sasProcSQLStatementKeyword Statement
hi def link sasProcSQLStatementComplexKeyword Statement
hi def link sasDS2StatementKeyword Statement
hi def link sasIMLStatementKeyword Statement
hi def link sasMacroReserved Macro
hi def link sasMacroFuncName Define
hi def link sasMacroVariable Define
hi def link sasFormatTag SpecialChar
hi def link sasReserved Special

" Syncronize from beginning to keep large blocks from losing
" syntax coloring while moving through code.
syn sync fromstart

let b:current_syntax = "sas"

let &cpo = s:cpo_save
unlet s:cpo_save
