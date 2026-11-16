local makeUseExperiment = require(script.Parent.makeUseExperiment)

local useExperiment = makeUseExperiment(
	"OnBrowserTrackerLayerLoadingStatusChanged",
	"GetBrowserTrackerLayerLoadingStatus",
	"GetBrowserTrackerLayerVariables",
	"LogBrowserTrackerLayerExposure",
	"GetBrowserTrackerStatusForLayer"
)

return function(p, p2, flag: boolean?)
	return useExperiment(p, p2, flag)
end
