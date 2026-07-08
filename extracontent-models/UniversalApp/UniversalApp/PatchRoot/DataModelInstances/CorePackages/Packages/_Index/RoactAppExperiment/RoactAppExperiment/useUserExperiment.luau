local v1 = require(script.Parent.makeUseExperiment)("OnUserLayerLoadingStatusChanged", "GetUserLayerLoadingStatus", "GetUserLayerVariables", "LogUserLayerExposure", "GetUserStatusForLayer")

return function(t1: {[any]: any}, p1, b1: boolean?) -- line: 35
	-- upvalues: v1 (copy)
	return v1(t1, p1, b1)
end
