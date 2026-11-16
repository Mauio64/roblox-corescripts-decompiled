local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("SquadQuickStartExperimentLayer", "Party.Formation.Create.User")

local defineFastString2 = game:DefineFastString("SquadEnablePartyQuickStartVariant", "enablePartyQuickStartChanges")
local defineFastFlag = game:DefineFastFlag("EnablePartyQuickStartChanges2", false)

local function getIsUserInTreatment(p: string)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local SquadQuickStartExperimentation = {}

function SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled()
	local v = defineFastFlag

	if v then
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

function SquadQuickStartExperimentation.logExposure()
	if experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return SquadQuickStartExperimentation
