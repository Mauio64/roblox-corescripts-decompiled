local parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("LuaAppVerticalEfficiencyExpLayer", "PlayerApp.HomePage.UX")

local function getIsUserInTreatmentAndSendExposureLog(p: string) -- 2 equivalent calls inferred from this helper
	local v = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v, true)

	if not layerVariables or layerVariables[p] == nil then
		return false
	end

	experimentCacheManager.default:sendCustomExposureLog(v)
	return layerVariables[p]
end

local VerticalEfficiencyExperimentation = {}

function VerticalEfficiencyExperimentation.getIsProfileMovedToTopBar()
	return getIsUserInTreatmentAndSendExposureLog("IsProfileMovedToTopBar") -- inferred equivalent call
end

function VerticalEfficiencyExperimentation.getIsRobloxLogoHeaderEnabled()
	return getIsUserInTreatmentAndSendExposureLog("IsRobloxLogoHeaderEnabled") -- inferred equivalent call
end

return VerticalEfficiencyExperimentation
