local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("FStringPartyPageCarouselExpLayer", "Party.Coordination.UI")
local defineFastString2 = game:DefineFastString("PartyPageCarouselVariant", "enablePartyCoordinationUi")
local defineFastFlag = game:DefineFastFlag("ForceEnableSocialCarouselPartyPage5", false)

local defineFastFlag2 = game:DefineFastFlag("EnablePartyPageCarouselExperimentation4", false)

local function getIsUserInTreatment(p: string)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local PartyPageCarouselExperimentation = {}

function PartyPageCarouselExperimentation.getAppChatFormFactorEnabled()
	local v = defineFastFlag

	if v then
		return v
	end

	v = defineFastFlag2

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

function PartyPageCarouselExperimentation.getPartyPageCarouselEnabled()
	local v = defineFastFlag

	if v then
		return v
	end

	v = defineFastFlag2

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

function PartyPageCarouselExperimentation.logExposure()
	if defineFastFlag2 and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return PartyPageCarouselExperimentation
