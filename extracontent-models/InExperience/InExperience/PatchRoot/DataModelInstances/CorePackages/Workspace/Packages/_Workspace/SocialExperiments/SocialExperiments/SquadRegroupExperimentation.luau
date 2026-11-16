local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager
local SharedFlags = require(parent.SharedFlags)

local defineFastString = game:DefineFastString("FStringSquadRegroupExpLayer", "Party.Coordination.UnifyCoplay")
local defineFastString2 = game:DefineFastString("SquadEnableRegroupVariant", "enableSquadRegroup")

local FFlagForceEnableSquadRegroup = SharedFlags.FFlagForceEnableSquadRegroup
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

local function getIsUserInTreatment(p: string)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local SquadRegroupExperimentation = {}

function SquadRegroupExperimentation.getSquadRegroupEnabled()
	local v = FFlagForceEnableSquadRegroup

	if v then
		return v
	end

	v = FFlagEnableSquadRegroupExperimentation

	if not v then
		return v
	end

	local v2 = defineFastString2
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[v2] ~= nil then
		return layerVariables[v2]
	end

	v = false
	return false
end

function SquadRegroupExperimentation.logExposure()
	if
		not FFlagForceEnableSquadRegroup
		and FFlagEnableSquadRegroupExperimentation
		and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil
	then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return SquadRegroupExperimentation
