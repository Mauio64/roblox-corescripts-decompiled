local experimentCacheManager = require("@luauforge/bundled/duU").ExperimentCacheManager
local appUserLayers = require("@luauforge/bundled/drU").AppUserLayers

game:DefineFastFlag("EnablePerfRegressionTest", false)

return function()
	local fastFlag = game:GetFastFlag("EnablePerfRegressionTest")

	if not fastFlag then
		return fastFlag, 0
	end

	local layerVariables = experimentCacheManager.default:getLayerVariables(appUserLayers.PerfRegressionTestLayer)

	if
		layerVariables
		and layerVariables.homePageSleepTimeSeconds
		and typeof(layerVariables.homePageSleepTimeSeconds) == "number"
	then
		return fastFlag, layerVariables.homePageSleepTimeSeconds
	end

	return fastFlag, 0
end
