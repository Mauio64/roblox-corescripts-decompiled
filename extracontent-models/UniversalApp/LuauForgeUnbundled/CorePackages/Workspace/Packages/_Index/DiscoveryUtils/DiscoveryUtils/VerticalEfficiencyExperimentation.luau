local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString("LuaAppVerticalEfficiencyExpLayer", "PlayerApp.HomePage.UX")

local function getIsUserInTreatmentAndSendExposureLog(p2)
	local v5 = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

	if not layerVariables or layerVariables[p2] == nil then
		return false
	end

	experimentCacheManager.default:sendCustomExposureLog(v5)
	return layerVariables[p2]
end

return {
	getIsProfileMovedToTopBar = function()
		local v5 = defineFastString
		local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

		if not layerVariables or layerVariables.IsProfileMovedToTopBar == nil then
			return false
		end

		experimentCacheManager.default:sendCustomExposureLog(v5)
		return layerVariables.IsProfileMovedToTopBar
	end,
	getIsRobloxLogoHeaderEnabled = function()
		local v5 = defineFastString
		local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

		if not layerVariables or layerVariables.IsRobloxLogoHeaderEnabled == nil then
			return false
		end

		experimentCacheManager.default:sendCustomExposureLog(v5)
		return layerVariables.IsRobloxLogoHeaderEnabled
	end
}
