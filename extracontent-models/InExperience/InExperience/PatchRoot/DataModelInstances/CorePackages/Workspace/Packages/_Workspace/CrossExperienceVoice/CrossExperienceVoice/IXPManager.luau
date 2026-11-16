local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")

local dependencies = require(CrossExperienceVoice.dependencies)

local sharedFlags = dependencies.SharedFlags
local experimentCacheManager = dependencies.ExperimentCacheManager.ExperimentCacheManager

local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice

local defineFastString = game:DefineFastString("CrossExpVoiceIXPLayer", "Social.PartyVoice")
local defineFastString2 = game:DefineFastString("DebugCrossExpVoiceIXPLayer", "")

local engineFeature = game:GetEngineFeature("PartyVoiceVolume")

local IXPManager = {}
IXPManager.__index = IXPManager

local v = {
	CrossExpVoiceDebugVariant_0 = { partyVoiceExp = false },
	CrossExpVoiceDebugVariant_1 = { partyVoiceExp = true }
}

function IXPManager.new()
	local v2 = { initialized = false, variant = {} }

	setmetatable(v2, IXPManager)
	return v2
end

function IXPManager:initialize()
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables ~= nil then
		self.initialized = true
		self.variant = table.clone(layerVariables)
	end

	if defineFastString2 ~= "None" then
		self.initialized = true
		self.variant = v[defineFastString2] or self.variant
	end
end

function IXPManager:logLayerExposure()
	experimentCacheManager.default:logLayerExposure(defineFastString)
end

function IXPManager.getHasPartyVoiceVolume()
	return engineFeature and IXPManager.default.variant.partyVoiceExp
end

local default

if getFFlagEnableCrossExpVoice() then
	default = IXPManager.new()
end

IXPManager.default = default

return IXPManager
