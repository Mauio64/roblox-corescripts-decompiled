local experimentCacheManager = require("@luauforge/bundled/ggm").ExperimentCacheManager

local defineFastString = game:DefineFastString("LuaAppRelativeGuiIxpLayer", "PlayerApp.HomePage.UX")

local function getIsUserInTreatmentAndSendExposureLog()
	local v5 = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

	if not layerVariables or layerVariables.EnableRelativeGui == nil then
		return false
	end

	experimentCacheManager.default:sendCustomExposureLog(v5)
	return layerVariables.EnableRelativeGui
end

return { getRelativeGuiOnHomeEnabled = getIsUserInTreatmentAndSendExposureLog }
