local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/SharedFlags")

local defineFastString = game:DefineFastString(
	"FStringSquadRegroupExpLayer",
	"Party.Coordination.UnifyCoplay"
)
local defineFastString2 = game:DefineFastString("SquadEnableRegroupVariant", "enableSquadRegroup")

local fFlagForceEnableSquadRegroup = SharedFlags.FFlagForceEnableSquadRegroup
local fFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

local function getIsUserInTreatment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return false
end

return {
	getSquadRegroupEnabled = function()
		local v5 = fFlagForceEnableSquadRegroup

		if v5 then
			return v5
		end

		v5 = fFlagEnableSquadRegroupExperimentation

		if not v5 then
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
		if
			not fFlagForceEnableSquadRegroup
			and fFlagEnableSquadRegroupExperimentation
			and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil
		then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end
	end
}
