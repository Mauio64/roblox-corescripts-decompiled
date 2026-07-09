local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers

game:DefineFastFlag("EnablePerfRegressionTest", false)

return function() -- line: 8
	-- upvalues: ExperimentCacheManager (copy), AppUserLayers (copy)
	local FastFlag = game:GetFastFlag("EnablePerfRegressionTest")

	if FastFlag then
		local v5 = ExperimentCacheManager.default:getLayerVariables(AppUserLayers.PerfRegressionTestLayer)

		if v5 and v5.homePageSleepTimeSeconds and typeof(v5.homePageSleepTimeSeconds) == "number" then
			return FastFlag, v5.homePageSleepTimeSeconds
		end
	end

	return FastFlag, 0
end
