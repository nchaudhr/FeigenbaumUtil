JULIA=julia

all: generatequa compileparam

makeparams: generateparams compileparam mergeParams

generateparams:
	$(JULIA) ./data/generateParams.jl

compileparam:
	$(JULIA) ./data/compileParams.jl

makeimages:
	$(JULIA) ./data/generateg1.jl

mergeParams:
	$(JULIA) ./data/mergeParamsVals.jl

showLogPrdDbl:
	$(JULIA) ./data/Log_3_PrdDblMech.jl

miscTestCodes:
	$(JULIA) ./src/tempCompose.jl

chgPDF:
	$(JULIA) ./src/parDriver.jl
