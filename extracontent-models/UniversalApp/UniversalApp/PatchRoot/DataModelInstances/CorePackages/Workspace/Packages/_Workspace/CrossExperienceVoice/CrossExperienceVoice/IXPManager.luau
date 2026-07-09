local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local SharedFlags = dependencies.SharedFlags
local ExperimentCacheManager = dependencies.ExperimentCacheManager.ExperimentCacheManager
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local v6 = game:DefineFastString("CrossExpVoiceIXPLayer", "Social.PartyVoice")
local v7 = game:DefineFastString("DebugCrossExpVoiceIXPLayer", "")
local EngineFeature = game:GetEngineFeature("PartyVoiceVolume")
local t1 = {}

t1.__index = t1

local v10 = game:DefineFastFlag("PartyVoiceDisallowIXPLayerExposureOnInit", false)
local t2 = {
	CrossExpVoiceDebugVariant_0 = {
		partyVoiceExp = false
	},
	CrossExpVoiceDebugVariant_1 = {
		partyVoiceExp = true
	}
}

function t1.new() -- line: 50
	-- upvalues: t1 (copy)
	local t3 = {
		initialized = false,
		variant = {}
	}

	setmetatable(t3, t1)

	return t3
end
function t1.initialize(p1) -- line: 61
	-- upvalues: ExperimentCacheManager (copy), v6 (copy), v7 (copy), t2 (copy), v10 (copy)
	local v14 = ExperimentCacheManager.default:getLayerVariables(v6)

	if v14 ~= nil then
		p1.initialized = true
		p1.variant = table.clone(v14)
	end

	if v7 ~= "None" then
		p1.initialized = true
		p1.variant = t2[v7] or p1.variant
	end

	if p1.initialized and not v10 then
		p1:logLayerExposure()
	end
end
function t1.logLayerExposure(_) -- line: 81
	-- upvalues: ExperimentCacheManager (copy), v6 (copy)
	ExperimentCacheManager.default:logLayerExposure(v6)
end
function t1.getHasPartyVoiceVolume() -- line: 85
	-- upvalues: EngineFeature (copy), t1 (copy)
	return EngineFeature and t1.default.variant.partyVoiceExp
end

t1.default = if not GetFFlagEnableCrossExpVoice() then nil else t1.new()

return t1
