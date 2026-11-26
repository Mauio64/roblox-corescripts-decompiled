local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"SquadCoordinationUiExperimentLayer",
	"Party.Coordination.UI"
)

local defineFastString2 = game:DefineFastString(
	"SquadEnablePartyCoordinationUiVariant",
	"enablePartyCoordinationUi"
)
local defineFastFlag = game:DefineFastFlag("ForceEnablePartyCoordinationUiChanges3", false)

local function getIsUserInTreatment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return false
end

return {
	getPartyCoordinationUiChangesEnabled = function()
		local v5 = defineFastFlag

		if v5 then
			return v5
		end

		local v6 = defineFastString2
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables[v6] ~= nil then
			return layerVariables[v6]
		end

		v5 = false
		return false
	end,
	logExposure = function()
		if experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end
	end
}
