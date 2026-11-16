local makeUseExperiment = require(script.Parent.makeUseExperiment)

local useExperiment = makeUseExperiment(
	"OnUserLayerLoadingStatusChanged",
	"GetUserLayerLoadingStatus",
	"GetUserLayerVariables",
	"LogUserLayerExposure",
	"GetUserStatusForLayer"
)

return function(p, p2, flag: boolean?)
	return useExperiment(p, p2, flag)
end
