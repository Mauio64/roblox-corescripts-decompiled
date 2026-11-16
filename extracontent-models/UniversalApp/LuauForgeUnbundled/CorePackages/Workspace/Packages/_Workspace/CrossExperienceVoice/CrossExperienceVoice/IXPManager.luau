local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local sharedFlags = dependencies.SharedFlags
local experimentCacheManager = dependencies.ExperimentCacheManager.ExperimentCacheManager

local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice

local defineFastString = game:DefineFastString("CrossExpVoiceIXPLayer", "Social.PartyVoice")
local defineFastString2 = game:DefineFastString("DebugCrossExpVoiceIXPLayer", "")

local engineFeature = game:GetEngineFeature("PartyVoiceVolume")

local class = {}
class.__index = class

local v5 = {
	CrossExpVoiceDebugVariant_0 = { partyVoiceExp = false },
	CrossExpVoiceDebugVariant_1 = { partyVoiceExp = true }
}

function class.new()
	local v6 = { initialized = false, variant = {} }

	setmetatable(v6, class)
	return v6
end

function class:initialize()
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables ~= nil then
		self.initialized = true
		self.variant = table.clone(layerVariables)
	end

	if defineFastString2 ~= "None" then
		self.initialized = true
		self.variant = v5[defineFastString2] or self.variant
	end
end

function class.logLayerExposure(p2)
	experimentCacheManager.default:logLayerExposure(defineFastString)
end

function class.getHasPartyVoiceVolume()
	return engineFeature and class.default.variant.partyVoiceExp
end

local v6 = if getFFlagEnableCrossExpVoice() then class.new() else nil
class.default = v6

return class
