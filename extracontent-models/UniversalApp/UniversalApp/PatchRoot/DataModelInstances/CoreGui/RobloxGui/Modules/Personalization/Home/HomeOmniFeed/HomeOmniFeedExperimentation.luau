local CorePackages = game:GetService("CorePackages")
local ExperimentCacheManager = require(CorePackages.Workspace.Packages.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("LuaAppRelativeGuiIxpLayer", "PlayerApp.HomePage.UX")

local function getIsUserInTreatmentAndSendExposureLog() -- line: 10
	-- upvalues: v3 (copy), ExperimentCacheManager (copy)
	local v5 = v3
	local v6 = ExperimentCacheManager.default:getLayerVariables(v5, true)

	if v6 and v6.EnableRelativeGui ~= nil then
		ExperimentCacheManager.default:sendCustomExposureLog(v5)

		return v6.EnableRelativeGui
	end

	return false
end

return {
	getRelativeGuiOnHomeEnabled = getIsUserInTreatmentAndSendExposureLog
}
