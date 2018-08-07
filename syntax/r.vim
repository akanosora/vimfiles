" Vim syntax file
" Language:	      R (GNU S)
" Maintainer:	      Jakson Aquino <jalvesaq@gmail.com>
" Former Maintainers: Vaidotas Zemlys <zemlys@gmail.com>
" 		      Tom Payne <tom@tompayne.org>
" Last Change:	      2018-08-01
" Filenames:	      *.R *.r *.Rhistory *.Rt

if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

setlocal iskeyword=@,48-57,_,.

syn case match

" Comment
syn keyword rCommentTodo contained BUG FIXME NOTE TODO
syn match rComment contains=@Spell,rCommentTodo /#.*/

" Roxygen
syn match rOKeyword contained /@\(param\|return\|name\|rdname\|examples\|include\|docType\)/
syn match rOKeyword contained /@\(S3method\|TODO\|aliases\|alias\|assignee\|author\|callGraphDepth\|callGraph\)/
syn match rOKeyword contained /@\(callGraphPrimitives\|concept\|exportClass\|exportMethod\|exportPattern\|export\|formals\)/
syn match rOKeyword contained /@\(format\|importClassesFrom\|importFrom\|importMethodsFrom\|import\|keywords\)/
syn match rOKeyword contained /@\(method\|nord\|note\|references\|seealso\|setClass\|slot\|source\|title\|usage\)/
syn match rOComment contains=@Spell,rOKeyword /#'.*/

syn match rStrError display contained /\\./
" String enclosed in double quotes
syn region rString contains=rSpecial,rStrError,@Spell start=/"/ skip=/\\\\\|\\"/ end=/"/
" String enclosed in single quotes
syn region rString contains=rSpecial,rStrError,@Spell start=/'/ skip=/\\\\\|\\'/ end=/'/

" New line, carriage return, tab, backspace, bell, feed, vertical tab, backslash
syn match rSpecial display contained /\\\(n\|r\|t\|b\|a\|f\|v\|'\|\"\)\|\\\\/

" Hexadecimal and octal digits
syn match rSpecial display contained /\\\(x\x\{1,2}\|[0-8]\{1,3}\)/

" Unicode characters
syn match rSpecial display contained /\\u\x\{1,4}/
syn match rSpecial display contained /\\U\x\{1,8}/
syn match rSpecial display contained /\\u{\x\{1,4}}/
syn match rSpecial display contained /\\U{\x\{1,8}}/

" Statement
syn keyword rStatement break next return
syn keyword rConditional if else
syn keyword rRepeat for in repeat while

" Constant (not really)
syn keyword rConstant T F LETTERS letters month.abb month.name pi
syn keyword rConstant R.version.string

syn keyword rNumber NA_integer_ NA_real_ NA_complex_ NA_character_

" Constants
syn keyword rConstant NULL
syn keyword rBoolean FALSE TRUE
syn keyword rNumber NA Inf NaN

" Integer
syn match rInteger /\<\d\+L/
syn match rInteger /\<0x\([0-9]\|[a-f]\|[A-F]\)\+L/
syn match rInteger /\<\d\+[Ee]+\=\d\+L/

" Number with no fractional part or exponent
syn match rNumber /\<\d\+\>/
" Hexadecimal number
syn match rNumber /\<0x\([0-9]\|[a-f]\|[A-F]\)\+/

" Floating point number with integer and fractional parts and optional exponent
syn match rFloat /\<\d\+\.\d*\([Ee][-+]\=\d\+\)\=/
" Floating point number with no integer part and optional exponent
syn match rFloat /\<\.\d\+\([Ee][-+]\=\d\+\)\=/
" Floating point number with no fractional part and optional exponent
syn match rFloat /\<\d\+[Ee][-+]\=\d\+/

" Complex number
syn match rComplex /\<\d\+i/
syn match rComplex /\<\d\++\d\+i/
syn match rComplex /\<0x\([0-9]\|[a-f]\|[A-F]\)\+i/
syn match rComplex /\<\d\+\.\d*\([Ee][-+]\=\d\+\)\=i/
syn match rComplex /\<\.\d\+\([Ee][-+]\=\d\+\)\=i/
syn match rComplex /\<\d\+[Ee][-+]\=\d\+i/

syn match rOperator /&/
syn match rOperator /-/
syn match rOperator /\*/
syn match rOperator /+/
syn match rOperator /=/
syn match rOperator /[|!<>^~/:]/
syn match rOperator /%\{2}\|%\S*%/
syn match rOpError  /\*\{3}/
syn match rOpError  /\/\//
syn match rOpError  /&&&/
syn match rOpError  /|||/
syn match rOpError  /<</
syn match rOpError  />>/

syn match rArrow /<\{1,2}-/
syn match rArrow /->\{1,2}/

" Special
syn match rDelimiter /[,;:]/

" Error
syn region rRegion matchgroup=Delimiter start=/(/ matchgroup=Delimiter end=/)/ transparent contains=ALLBUT,rError,rBraceError,rCurlyError fold
syn region rRegion matchgroup=Delimiter start=/{/ matchgroup=Delimiter end=/}/ transparent contains=ALLBUT,rError,rBraceError,rParenError fold
syn region rRegion matchgroup=Delimiter start=/\[/ matchgroup=Delimiter end=/]/ transparent contains=ALLBUT,rError,rCurlyError,rParenError fold

syn match rError      /[)\]}]/
syn match rBraceError /[)}]/ contained
syn match rCurlyError /[)\]]/ contained
syn match rParenError /[\]}]/ contained

syn keyword rFunction abbreviate abs acos acosh addNA addTaskCallback agrep
syn keyword rFunction alist all all.equal all.equal.character all.equal.default all.equal.factor all.equal.formula
syn keyword rFunction all.equal.language all.equal.list all.equal.numeric all.equal.POSIXct all.equal.raw all.names all.vars
syn keyword rFunction any anyDuplicated anyDuplicated.array anyDuplicated.data.frame anyDuplicated.default anyDuplicated.matrix aperm
syn keyword rFunction aperm.default aperm.table append apply Arg args array
syn keyword rFunction arrayInd as.array as.array.default as.call as.character as.character.condition as.character.Date
syn keyword rFunction as.character.default as.character.error as.character.factor as.character.hexmode as.character.numeric_version as.character.octmode as.character.POSIXt
syn keyword rFunction as.character.srcref as.complex as.data.frame as.data.frame.array as.data.frame.AsIs as.data.frame.character as.data.frame.complex
syn keyword rFunction as.data.frame.data.frame as.data.frame.Date as.data.frame.default as.data.frame.difftime as.data.frame.factor as.data.frame.integer as.data.frame.list
syn keyword rFunction as.data.frame.logical as.data.frame.matrix as.data.frame.model.matrix as.data.frame.numeric as.data.frame.numeric_version as.data.frame.ordered as.data.frame.POSIXct
syn keyword rFunction as.data.frame.POSIXlt as.data.frame.raw as.data.frame.table as.data.frame.ts as.data.frame.vector as.Date as.Date.character
syn keyword rFunction as.Date.date as.Date.dates as.Date.default as.Date.factor as.Date.numeric as.Date.POSIXct as.Date.POSIXlt
syn keyword rFunction as.difftime as.double as.double.difftime as.double.POSIXlt as.environment as.expression as.expression.default
syn keyword rFunction as.factor as.function as.function.default as.hexmode asin asinh as.integer
syn keyword rFunction as.list as.list.data.frame as.list.Date as.list.default as.list.environment as.list.factor as.list.function
syn keyword rFunction as.list.numeric_version as.list.POSIXct as.logical as.logical.factor as.matrix as.matrix.data.frame as.matrix.default
syn keyword rFunction as.matrix.noquote as.matrix.POSIXlt as.name asNamespace as.null as.null.default as.numeric
syn keyword rFunction as.numeric_version as.octmode as.ordered as.package_version as.pairlist as.POSIXct as.POSIXct.date
syn keyword rFunction as.POSIXct.Date as.POSIXct.dates as.POSIXct.default as.POSIXct.numeric as.POSIXct.POSIXlt as.POSIXlt as.POSIXlt.character
syn keyword rFunction as.POSIXlt.date as.POSIXlt.Date as.POSIXlt.dates as.POSIXlt.default as.POSIXlt.factor as.POSIXlt.numeric as.POSIXlt.POSIXct
syn keyword rFunction as.qr as.raw asS3 asS4 assign as.single as.single.default
syn keyword rFunction as.symbol as.table as.table.default as.vector as.vector.factor atan atan2
syn keyword rFunction atanh attach attachNamespace attr attr.all.equal attributes autoload
syn keyword rFunction autoloader backsolve baseenv basename besselI besselJ besselK
syn keyword rFunction besselY beta bindingIsActive bindingIsLocked bindtextdomain bitwAnd bitwNot
syn keyword rFunction bitwOr bitwShiftL bitwShiftR bitwXor body bquote browser
syn keyword rFunction browserCondition browserSetDebug browserText builtins by by.data.frame by.default
syn keyword rFunction bzfile c call callCC capabilities casefold cat
syn keyword rFunction cbind cbind.data.frame c.Date ceiling character char.expand charmatch
syn keyword rFunction charToRaw chartr chol chol2inv chol.default choose class
syn keyword rFunction clearPushBack close closeAllConnections close.connection close.srcfile close.srcfilealias c.noquote
syn keyword rFunction c.numeric_version col colMeans colnames colSums commandArgs comment
syn keyword rFunction complex computeRestarts conditionCall conditionCall.condition conditionMessage conditionMessage.condition conflicts
syn keyword rFunction Conj contributors cos cosh c.POSIXct c.POSIXlt crossprod
syn keyword rFunction cummax cummin cumprod cumsum cut cut.Date cut.default
syn keyword rFunction cut.POSIXt data.class data.frame data.matrix date debug debugonce
syn keyword rFunction default.stringsAsFactors delayedAssign deparse det detach determinant determinant.matrix
syn keyword rFunction dget diag diff diff.Date diff.default diff.POSIXt difftime
syn keyword rFunction digamma dim dim.data.frame dimnames dimnames.data.frame dir dir.create
syn keyword rFunction dirname do.call double dput dQuote drop droplevels
syn keyword rFunction droplevels.data.frame droplevels.factor dump duplicated duplicated.array duplicated.data.frame duplicated.default
syn keyword rFunction duplicated.matrix duplicated.numeric_version duplicated.POSIXlt dyn.load dyn.unload eapply eigen
syn keyword rFunction emptyenv enc2native enc2utf8 encodeString Encoding enquote environment
syn keyword rFunction environmentIsLocked environmentName env.profile eval eval.parent evalq exists
syn keyword rFunction exp expand.grid expm1 expression factor factorial fifo
syn keyword rFunction file file.access file.append file.choose file.copy file.create file.exists
syn keyword rFunction file.info file.link file.path file.remove file.rename file.show file.symlink
syn keyword rFunction Filter Find findInterval find.package findPackageEnv findRestart floor
syn keyword rFunction flush flush.connection force formals format format.AsIs formatC
syn keyword rFunction format.data.frame format.Date format.default format.difftime formatDL format.factor format.hexmode
syn keyword rFunction format.info format.libraryIQR format.numeric_version format.octmode format.packageInfo format.POSIXct format.POSIXlt
syn keyword rFunction format.pval format.summaryDefault forwardsolve function gamma gc gcinfo
syn keyword rFunction gc.time gctorture gctorture2 get getAllConnections getCallingDLL getCallingDLLe
syn keyword rFunction getConnection getDLLRegisteredRoutines getDLLRegisteredRoutines.character getDLLRegisteredRoutines.DLLInfo getElement geterrmessage getExportedValue
syn keyword rFunction getHook getLoadedDLLs getNamespace getNamespaceExports getNamespaceImports getNamespaceInfo getNamespaceName
syn keyword rFunction getNamespaceUsers getNamespaceVersion getNativeSymbolInfo getOption getRversion getSrcLines getTaskCallbackNames
syn keyword rFunction gettext gettextf getwd gl globalenv gregexpr grep
syn keyword rFunction grepl grepRaw gsub gzcon gzfile I iconv
syn keyword rFunction iconvlist icuSetCollate identical identity ifelse Im importIntoEnv
syn keyword rFunction inherits integer interaction interactive intersect intToBits intToUtf8
syn keyword rFunction inverse.rle invisible invokeRestart invokeRestartInteractively is.array is.atomic isatty
syn keyword rFunction isBaseNamespace is.call is.character is.complex is.data.frame isdebugged is.double
syn keyword rFunction is.element is.environment is.expression is.factor is.finite is.function isIncomplete
syn keyword rFunction is.infinite is.integer is.language is.list is.loaded is.logical is.matrix
syn keyword rFunction is.na is.na.data.frame is.name isNamespace is.nan is.na.numeric_version is.na.POSIXlt
syn keyword rFunction is.null is.numeric is.numeric.Date is.numeric.difftime is.numeric.POSIXt is.numeric_version is.object
syn keyword rFunction ISOdate ISOdatetime isOpen is.ordered is.package_version is.pairlist is.primitive
syn keyword rFunction is.qr is.R is.raw is.recursive isRestart isS4 isSeekable
syn keyword rFunction is.single is.symbol isSymmetric isSymmetric.matrix is.table isTRUE is.unsorted
syn keyword rFunction is.vector jitter julian julian.Date julian.POSIXt kappa kappa.default
syn keyword rFunction kappa.lm kappa.qr kronecker labels labels.default lapply La.svd
syn keyword rFunction lazyLoad lazyLoadDBexec lazyLoadDBfetch lbeta lchoose length length.POSIXlt
syn keyword rFunction levels levels.default lfactorial lgamma library library.dynam library.dynam.unload
syn keyword rFunction licence license list list2env list.dirs list.files load
syn keyword rFunction loadedNamespaces loadingNamespaceInfo loadNamespace local lockBinding lockEnvironment log
syn keyword rFunction log10 log1p log2 logb logical lower.tri ls
syn keyword rFunction makeActiveBinding make.names make.unique Map mapply margin.table match
syn keyword rFunction match.arg match.call match.fun Math.data.frame Math.Date Math.difftime Math.factor
syn keyword rFunction Math.POSIXt mat.or.vec matrix max max.col mean mean.Date
syn keyword rFunction mean.default mean.difftime mean.POSIXct mean.POSIXlt memCompress memDecompress mem.limits
syn keyword rFunction memory.profile merge merge.data.frame merge.default message mget min
syn keyword rFunction missing Mod mode months months.Date months.POSIXt names
syn keyword rFunction namespaceExport namespaceImport namespaceImportClasses namespaceImportFrom namespaceImportMethods names.POSIXlt nargs
syn keyword rFunction nchar ncol NCOL Negate new.env NextMethod ngettext
syn keyword rFunction nlevels noquote norm normalizePath nrow NROW numeric
syn keyword rFunction nzchar objects oldClass on.exit open open.connection open.srcfile
syn keyword rFunction open.srcfilealias open.srcfilecopy Ops.data.frame Ops.Date Ops.difftime Ops.factor Ops.numeric_version
syn keyword rFunction Ops.ordered Ops.POSIXt options order ordered outer packageEvent
syn keyword rFunction packageHasNamespace packageStartupMessage packBits pairlist parent.env parent.frame parse
syn keyword rFunction parseNamespaceFile paste paste0 path.expand path.package pipe pmatch
syn keyword rFunction pmax pmax.int pmin pmin.int polyroot Position pos.to.env
syn keyword rFunction pretty pretty.default prettyNum print print.AsIs print.by print.condition
syn keyword rFunction print.connection print.data.frame print.Date print.default print.difftime print.DLLInfo print.DLLInfoList
syn keyword rFunction print.DLLRegisteredRoutines print.factor print.function print.hexmode print.libraryIQR print.listof print.NativeRoutineList
syn keyword rFunction print.noquote print.numeric_version print.octmode print.packageInfo print.POSIXct print.POSIXlt print.proc_time
syn keyword rFunction print.restart print.rle print.simple.list print.srcfile print.srcref print.summaryDefault print.summary.table
syn keyword rFunction print.table print.warnings prmatrix proc.time prod prop.table provideDimnames
syn keyword rFunction psigamma pushBack pushBackLength q qr qr.coef qr.default
syn keyword rFunction qr.fitted qr.Q qr.qty qr.qy qr.R qr.resid qr.solve
syn keyword rFunction qr.X quarters quarters.Date quarters.POSIXt quit quote range
syn keyword rFunction range.default rank rapply raw rawConnection rawConnectionValue rawShift
syn keyword rFunction rawToBits rawToChar rbind rbind.data.frame rcond Re readBin
syn keyword rFunction readChar read.dcf readline readLines readRDS readRenviron Recall
syn keyword rFunction Reduce regexec regexpr reg.finalizer registerS3method registerS3methods regmatches
syn keyword rFunction remove removeTaskCallback rep rep.Date rep.factor rep.int replace
syn keyword rFunction replicate rep.numeric_version rep.POSIXct rep.POSIXlt require requireNamespace restartDescription
syn keyword rFunction restartFormals retracemem return rev rev.default R.home rle
syn keyword rFunction rm RNGkind RNGversion round round.Date round.POSIXt row
syn keyword rFunction rowMeans rownames row.names row.names.data.frame row.names.default rowsum rowsum.data.frame
syn keyword rFunction rowsum.default rowSums R.Version sample sample.int sapply save
syn keyword rFunction save.image saveRDS scale scale.default scan search searchpaths
syn keyword rFunction seek seek.connection seq seq.Date seq.default seq.int seq.POSIXt
syn keyword rFunction sequence serialize setdiff setequal setHook setNamespaceInfo set.seed
syn keyword rFunction setSessionTimeLimit setTimeLimit setwd showConnections shQuote sign signalCondition
syn keyword rFunction signif simpleCondition simpleError simpleMessage simpleWarning simplify2array sin
syn keyword rFunction single sinh sink sink.number slice.index socketConnection socketSelect
syn keyword rFunction solve solve.default solve.qr sort sort.default sort.int sort.list
syn keyword rFunction sort.POSIXlt source split split.data.frame split.Date split.default split.POSIXct
syn keyword rFunction sprintf sqrt sQuote srcfile srcfilealias srcfilecopy srcref
syn keyword rFunction standardGeneric stderr stdin stdout stop stopifnot storage.mode
syn keyword rFunction strftime strptime strsplit strtoi strtrim structure strwrap
syn keyword rFunction sub subset subset.data.frame subset.default subset.matrix substitute substr
syn keyword rFunction substring sum summary summary.connection summary.data.frame Summary.data.frame summary.Date
syn keyword rFunction Summary.Date summary.default Summary.difftime summary.factor Summary.factor summary.matrix Summary.numeric_version
syn keyword rFunction Summary.ordered summary.POSIXct Summary.POSIXct summary.POSIXlt Summary.POSIXlt summary.proc_time summary.srcfile
syn keyword rFunction summary.srcref summary.table suppressMessages suppressPackageStartupMessages suppressWarnings svd sweep
syn keyword rFunction switch sys.call sys.calls Sys.chmod Sys.Date sys.frame sys.frames
syn keyword rFunction sys.function Sys.getenv Sys.getlocale Sys.getpid Sys.glob Sys.info sys.load.image
syn keyword rFunction Sys.localeconv sys.nframe sys.on.exit sys.parent sys.parents Sys.readlink sys.save.image
syn keyword rFunction Sys.setenv Sys.setFileTime Sys.setlocale Sys.sleep sys.source sys.status system
syn keyword rFunction system2 system.file system.time Sys.time Sys.timezone Sys.umask Sys.unsetenv
syn keyword rFunction Sys.which t table tabulate tan tanh tapply
syn keyword rFunction taskCallbackManager tcrossprod t.data.frame t.default tempdir tempfile testPlatformEquivalence
syn keyword rFunction textConnection textConnectionValue tolower topenv toString toString.default toupper
syn keyword rFunction trace traceback tracemem tracingState transform transform.data.frame transform.default
syn keyword rFunction trigamma trunc truncate truncate.connection trunc.Date trunc.POSIXt try
syn keyword rFunction tryCatch typeof unclass undebug union unique unique.array
syn keyword rFunction unique.data.frame unique.default unique.matrix unique.numeric_version unique.POSIXlt units units.difftime
syn keyword rFunction unix.time unlink unlist unloadNamespace unlockBinding unname unserialize
syn keyword rFunction unsplit untrace untracemem unz upper.tri url UseMethod
syn keyword rFunction utf8ToInt vapply vector Vectorize warning warnings weekdays
syn keyword rFunction weekdays.Date weekdays.POSIXt which which.max which.min with withCallingHandlers
syn keyword rFunction with.default within within.data.frame within.list withRestarts withVisible write
syn keyword rFunction writeBin writeChar write.dcf writeLines xor xor.hexmode xor.octmode
syn keyword rFunction xpdrows.data.frame xtfrm xtfrm.AsIs xtfrm.Date xtfrm.default xtfrm.difftime xtfrm.factor
syn keyword rFunction xtfrm.numeric_version xtfrm.POSIXct xtfrm.POSIXlt xtfrm.Surv xzfile zapsmall ColorOut
syn keyword rFunction noColorOut setOutputColors setOutputColors256 show256Colors adjustcolor as.graphicsAnnot as.raster
syn keyword rFunction axisTicks bitmap bmp boxplot.stats check.options chull CIDFont
syn keyword rFunction cm cm.colors col2rgb colorConverter colorRamp colorRampPalette colors
syn keyword rFunction colours contourLines convertColor densCols dev2bitmap devAskNewPage dev.capabilities
syn keyword rFunction dev.capture dev.control dev.copy dev.copy2eps dev.copy2pdf dev.cur dev.flush
syn keyword rFunction dev.hold deviceIsInteractive dev.interactive dev.list dev.new dev.next dev.off
syn keyword rFunction dev.prev dev.print dev.set dev.size embedFonts extendrange getGraphicsEvent
syn keyword rFunction getGraphicsEventEnv graphics.off gray gray.colors grey grey.colors hcl
syn keyword rFunction heat.colors hsv is.raster jpeg make.rgb n2mfrow nclass.FD
syn keyword rFunction nclass.scott nclass.Sturges palette pdf pdfFonts pdf.options pictex
syn keyword rFunction png postscript postscriptFonts ps.options quartz quartzFont quartzFonts
syn keyword rFunction quartz.options quartz.save rainbow recordGraphics recordPlot replayPlot rgb
syn keyword rFunction rgb2hsv savePlot setEPS setGraphicsEventEnv setGraphicsEventHandlers setPS svg
syn keyword rFunction terrain.colors tiff topo.colors trans3d Type1Font x11 X11
syn keyword rFunction X11Font X11Fonts X11.options xfig xy.coords xyTable xyz.coords
syn keyword rFunction abline arrows assocplot axis Axis axis.Date axis.POSIXct
syn keyword rFunction axTicks barplot barplot.default box boxplot boxplot.default boxplot.matrix
syn keyword rFunction bxp cdplot clip close.screen co.intervals contour contour.default
syn keyword rFunction coplot curve dotchart erase.screen filled.contour fourfoldplot frame
syn keyword rFunction grconvertX grconvertY grid hist hist.default identify image
syn keyword rFunction image.default layout layout.show lcm legend lines lines.default
syn keyword rFunction locator matlines matplot matpoints mosaicplot mtext pairs
syn keyword rFunction pairs.default panel.smooth par persp pie plot plot.default
syn keyword rFunction plot.design plot.function plot.new plot.window plot.xy points points.default
syn keyword rFunction polygon polypath rasterImage rect rug screen segments
syn keyword rFunction smoothScatter spineplot split.screen stars stem strheight stripchart
syn keyword rFunction strwidth sunflowerplot symbols text text.default title xinch
syn keyword rFunction xspline xyinch yinch addNextMethod allGenerics allNames Arith
syn keyword rFunction as asMethodDefinition assignClassDef assignMethodsMetaData balanceMethodsList cacheGenericsMetaData cacheMetaData
syn keyword rFunction cacheMethod callGeneric callNextMethod canCoerce cbind2 checkAtAssignment checkSlotAssignment
syn keyword rFunction classesToAM classLabel classMetaName className coerce Compare completeClassDefinition
syn keyword rFunction completeExtends completeSubclasses Complex conformMethod defaultDumpName defaultPrototype doPrimitiveMethod
syn keyword rFunction dumpMethod dumpMethods el elNamed empty.dump emptyMethodsList evalOnLoad
syn keyword rFunction evalqOnLoad evalSource existsFunction existsMethod extends finalDefaultMethod findClass
syn keyword rFunction findFunction findMethod findMethods findMethodSignatures findUnique formalArgs functionBody
syn keyword rFunction generic.skeleton getAccess getAllMethods getAllSuperClasses getClass getClassDef getClasses
syn keyword rFunction getClassName getClassPackage getDataPart getExtends getFunction getGeneric getGenerics
syn keyword rFunction getGroup getGroupMembers getLoadActions getMethod getMethods getMethodsForDispatch getMethodsMetaData
syn keyword rFunction getPackageName getProperties getPrototype getRefClass getSlots getSubclasses getValidity
syn keyword rFunction getVirtual hasArg hasLoadAction hasMethod hasMethods implicitGeneric inheritedSlotNames
syn keyword rFunction initFieldArgs initialize initRefFields insertClassMethods insertMethod insertSource is
syn keyword rFunction isClass isClassDef isClassUnion isGeneric isGrammarSymbol isGroup isSealedClass
syn keyword rFunction isSealedMethod isVirtualClass isXS3Class kronecker languageEl linearizeMlist listFromMethods
syn keyword rFunction listFromMlist loadMethod Logic makeClassRepresentation makeExtends makeGeneric makeMethodsList
syn keyword rFunction makePrototypeFromClassDef makeStandardGeneric matchSignature Math Math2 mergeMethods metaNameUndo
syn keyword rFunction MethodAddCoerce methodSignatureMatrix method.skeleton MethodsList MethodsListSelect methodsPackageMetaName missingArg
syn keyword rFunction mlistMetaName multipleClasses new newBasic newClassRepresentation newEmptyObject Ops
syn keyword rFunction packageSlot possibleExtends prohibitGeneric promptClass promptMethods prototype Quote
syn keyword rFunction rbind2 reconcilePropertiesAndPrototype registerImplicitGenerics rematchDefinition removeClass removeGeneric removeMethod
syn keyword rFunction removeMethods removeMethodsObject representation requireMethods resetClass resetGeneric S3Class
syn keyword rFunction S3Part sealClass seemsS4Object selectMethod selectSuperClasses setAs setClass
syn keyword rFunction setClassUnion setDataPart setGeneric setGenericImplicit setGroupGeneric setIs setLoadAction
syn keyword rFunction setLoadActions setMethod setOldClass setPackageName setPrimitiveMethods setRefClass setReplaceMethod
syn keyword rFunction setValidity show showClass showDefault showExtends showMethods showMlist
syn keyword rFunction signature SignatureMethod sigToEnv slot slotNames slotsFromS3 substituteDirect
syn keyword rFunction substituteFunctionArgs Summary superClassDepth testInheritedMethods testVirtual traceOff traceOn
syn keyword rFunction tryNew unRematchDefinition validObject validSlotNames acf acf2AR add1
syn keyword rFunction addmargins add.scope aggregate aggregate.data.frame aggregate.default aggregate.ts AIC
syn keyword rFunction alias anova anova.glm anova.glmlist anova.lm anova.lmlist anova.mlm
syn keyword rFunction ansari.test aov approx approxfun ar ar.burg arima
syn keyword rFunction arima0 arima0.diag arima.sim ARMAacf ARMAtoMA ar.mle ar.ols
syn keyword rFunction ar.yw as.dendrogram as.dist as.formula as.hclust asOneSidedFormula as.stepfun
syn keyword rFunction as.ts ave bandwidth.kernel bartlett.test BIC binomial binom.test
syn keyword rFunction biplot Box.test bw.bcv bw.nrd bw.nrd0 bw.SJ bw.ucv
syn keyword rFunction C cancor case.names ccf chisq.test cmdscale coef
syn keyword rFunction coefficients complete.cases confint confint.default constrOptim contrasts contr.helmert
syn keyword rFunction contr.poly contr.SAS contr.sum contr.treatment convolve cooks.distance cophenetic
syn keyword rFunction cor cor.test cov cov2cor covratio cov.wt cpgram
syn keyword rFunction cutree cycle D dbeta dbinom dcauchy dchisq
syn keyword rFunction decompose delete.response deltat dendrapply density density.default deriv
syn keyword rFunction deriv3 deriv3.default deriv3.formula deriv.default deriv.formula deviance dexp
syn keyword rFunction df dfbeta dfbetas dffits df.kernel df.residual dgamma
syn keyword rFunction dgeom dhyper diffinv diff.ts dist dlnorm dlogis
syn keyword rFunction dmultinom dnbinom dnorm dpois drop1 drop.scope drop.terms
syn keyword rFunction dsignrank dt dummy.coef dunif dweibull dwilcox ecdf
syn keyword rFunction eff.aovlist effects embed end estVar expand.model.frame extractAIC
syn keyword rFunction factanal factor.scope family fft filter fisher.test fitted
syn keyword rFunction fitted.values fivenum fligner.test formula frequency friedman.test ftable
syn keyword rFunction Gamma gaussian getCall getInitial glm glm.control glm.fit
syn keyword rFunction hasTsp hat hatvalues hatvalues.lm hclust heatmap HoltWinters
syn keyword rFunction influence influence.measures integrate interaction.plot inverse.gaussian IQR is.empty.model
syn keyword rFunction is.leaf is.mts isoreg is.stepfun is.ts is.tskernel KalmanForecast
syn keyword rFunction KalmanLike KalmanRun KalmanSmooth kernapply kernel kmeans knots
syn keyword rFunction kruskal.test ksmooth ks.test lag lag.plot line lines.ts
syn keyword rFunction lm lm.fit lm.influence lm.wfit loadings loess loess.control
syn keyword rFunction loess.smooth logLik loglin lowess ls.diag lsfit ls.print
syn keyword rFunction mad mahalanobis makeARIMA make.link makepredictcall manova mantelhaen.test
syn keyword rFunction mauchly.test mcnemar.test median median.default medpolish model.extract model.frame
syn keyword rFunction model.frame.aovlist model.frame.default model.frame.glm model.frame.lm model.matrix model.matrix.default model.matrix.lm
syn keyword rFunction model.offset model.response model.tables model.weights monthplot mood.test mvfft
syn keyword rFunction na.action na.contiguous na.exclude na.fail na.omit na.pass napredict
syn keyword rFunction naprint naresid nextn nlm nlminb nls nls.control
syn keyword rFunction NLSstAsymptotic NLSstClosestX NLSstLfAsymptote NLSstRtAsymptote nobs numericDeriv offset
syn keyword rFunction oneway.test optim optimHess optimise optimize order.dendrogram pacf
syn keyword rFunction p.adjust pairwise.prop.test pairwise.table pairwise.t.test pairwise.wilcox.test pbeta pbinom
syn keyword rFunction pbirthday pcauchy pchisq pexp pf pgamma pgeom
syn keyword rFunction phyper plclust plnorm plogis plot.density plot.ecdf plot.lm
syn keyword rFunction plot.mlm plot.spec plot.spec.coherency plot.spec.phase plot.stepfun plot.ts plot.TukeyHSD
syn keyword rFunction pnbinom pnorm poisson poisson.test poly polym power
syn keyword rFunction power.anova.test power.prop.test power.t.test ppoints ppois ppr PP.test
syn keyword rFunction prcomp predict predict.glm predict.lm predict.mlm predict.poly preplot
syn keyword rFunction princomp print.anova printCoefmat print.density print.family print.formula print.ftable
syn keyword rFunction print.glm print.infl print.integrate print.lm print.logLik print.terms print.ts
syn keyword rFunction profile proj promax prop.test prop.trend.test psignrank pt
syn keyword rFunction ptukey punif pweibull pwilcox qbeta qbinom qbirthday
syn keyword rFunction qcauchy qchisq qexp qf qgamma qgeom qhyper
syn keyword rFunction qlnorm qlogis qnbinom qnorm qpois qqline qqnorm
syn keyword rFunction qqnorm.default qqplot qsignrank qt qtukey quade.test quantile
syn keyword rFunction quantile.default quasi quasibinomial quasipoisson qunif qweibull qwilcox
syn keyword rFunction r2dtable rbeta rbinom rcauchy rchisq read.ftable rect.hclust
syn keyword rFunction reformulate relevel reorder replications reshape resid residuals
syn keyword rFunction residuals.default residuals.glm residuals.lm rexp rf rgamma rgeom
syn keyword rFunction rhyper rlnorm rlogis rmultinom rnbinom rnorm rpois
syn keyword rFunction rsignrank rstandard rstandard.glm rstandard.lm rstudent rstudent.glm rstudent.lm
syn keyword rFunction rt runif runmed rweibull rwilcox rWishart scatter.smooth
syn keyword rFunction screeplot sd se.contrast selfStart setNames shapiro.test simulate
syn keyword rFunction smooth smoothEnds smooth.spline sortedXyData spec.ar spec.pgram spec.taper
syn keyword rFunction spectrum spline splinefun splinefunH SSasymp SSasympOff SSasympOrig
syn keyword rFunction SSbiexp SSD SSfol SSfpl SSgompertz SSlogis SSmicmen
syn keyword rFunction SSweibull start stat.anova step stepfun stl StructTS
syn keyword rFunction summary.aov summary.aovlist summary.glm summary.infl summary.lm summary.manova summary.mlm
syn keyword rFunction summary.stepfun supsmu symnum termplot terms terms.aovlist terms.default
syn keyword rFunction terms.formula terms.terms time toeplitz ts tsdiag ts.intersect
syn keyword rFunction tsp ts.plot tsSmooth ts.union t.test TukeyHSD TukeyHSD.aov
syn keyword rFunction uniroot update update.default update.formula var variable.names varimax
syn keyword rFunction var.test vcov weighted.mean weighted.residuals weights wilcox.test window
syn keyword rFunction write.ftable xtabs adist alarm apropos aregexec argsAnywhere
syn keyword rFunction aspell as.person as.personList as.relistable as.roman assignInMyNamespace assignInNamespace
syn keyword rFunction available.packages bibentry browseEnv browseURL browseVignettes bug.report capture.output
syn keyword rFunction checkCRAN chooseBioCmirror chooseCRANmirror citation cite citeNatbib citEntry
syn keyword rFunction citFooter citHeader close.socket combn compareVersion contrib.url count.fields
syn keyword rFunction CRAN.packages create.post data dataentry data.entry de debugger
syn keyword rFunction demo de.ncols de.restore de.setup download.file download.packages dump.frames
syn keyword rFunction edit emacs example file.edit find findLineNum fix
syn keyword rFunction fixInNamespace flush.console formatOL formatUL getAnywhere getCRANmirrors getFromNamespace
syn keyword rFunction getParseData getParseText getS3method getSrcDirectory getSrcFilename getSrcLocation getSrcref
syn keyword rFunction getTxtProgressBar glob2rx globalVariables head head.matrix help help.request
syn keyword rFunction help.search help.start history installed.packages install.packages is.relistable limitedLabels
syn keyword rFunction loadhistory localeToCharset lsf.str ls.str maintainer make.packages.html makeRweaveLatexCodeRunner
syn keyword rFunction make.socket memory.limit memory.size menu methods mirror2html modifyList
syn keyword rFunction new.packages news nsl object.size old.packages packageDescription packageName
syn keyword rFunction package.skeleton packageStatus packageVersion page person personList pico
syn keyword rFunction process.events prompt promptData promptPackage rc.getOption rc.options rc.settings
syn keyword rFunction rc.status readCitationFile read.csv read.csv2 read.delim read.delim2 read.DIF
syn keyword rFunction read.fortran read.fwf read.socket read.table recover relist remove.packages
syn keyword rFunction removeSource Rprof Rprofmem RShowDoc RSiteSearch rtags Rtangle
syn keyword rFunction RtangleSetup RtangleWritedoc RweaveChunkPrefix RweaveEvalWithOpt RweaveLatex RweaveLatexFinish RweaveLatexOptions
syn keyword rFunction RweaveLatexSetup RweaveLatexWritedoc RweaveTryStop savehistory select.list sessionInfo setBreakpoint
syn keyword rFunction setRepositories setTxtProgressBar stack Stangle str strOptions summaryRprof
syn keyword rFunction Sweave SweaveHooks SweaveSyntConv tail tail.matrix tar timestamp
syn keyword rFunction toBibtex toLatex txtProgressBar type.convert unstack untar unzip
syn keyword rFunction update.packages update.packageStatus upgrade URLdecode URLencode url.show vi
syn keyword rFunction View vignette write.csv write.csv2 write.socket write.table xedit
syn keyword rFunction xemacs zip etags2ctags vim.bol vim.help vim.interlace.rmd vim.interlace.rnoweb
syn keyword rFunction vim.interlace.rrst vim.list.args vim.names vim.openpdf vim.plot vim.print vim.srcdir

syn match rDollar display contained /\$/
syn match rDollar display contained /@/

" List elements will not be highlighted as functions:
syn match rLstElmt /\$[a-zA-Z0-9\\._]*/ contains=rDollar
syn match rLstElmt /@[a-zA-Z0-9\\._]*/ contains=rDollar

" Functions that may add new objects
syn keyword rPreProc library require attach detach source

" Type
syn keyword rType array category character complex double function integer list logical matrix numeric vector data.frame

" Define the default highlighting.
hi def link rArrow       Statement
hi def link rBoolean     Boolean
hi def link rBraceError  Error
hi def link rComment     Comment
hi def link rCommentTodo Todo
hi def link rOComment    Comment
hi def link rComplex     Number
hi def link rConditional Conditional
hi def link rConstant    Constant
hi def link rCurlyError  Error
hi def link rDelimiter   Delimiter
hi def link rDollar      SpecialChar
hi def link rError       Error
hi def link rFloat       Float
hi def link rFunction    Function
hi def link rInteger     Number
hi def link rLstElmt	 Normal
hi def link rNumber      Number
hi def link rOperator    Operator
hi def link rOpError     Error
hi def link rParenError  Error
hi def link rPreProc     PreProc
hi def link rRepeat      Repeat
hi def link rSpecial     SpecialChar
hi def link rStatement   Statement
hi def link rString      String
hi def link rStrError    Error
hi def link rType        Type
hi def link rOKeyword    Title

let b:current_syntax = 'r'

let &cpo = s:cpo_save
unlet s:cpo_save