local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local useCrossExperienceVoice = require(CrossExperienceVoice.Hooks.useCrossExperienceVoice)
local FFlagEnableCEVForceInitialize = require(CrossExperienceVoice.Flags).FFlagEnableCEVForceInitialize

local function CrossExperienceVoiceComponent() -- line: 6
	-- upvalues: useCrossExperienceVoice (copy), FFlagEnableCEVForceInitialize (copy)
	useCrossExperienceVoice({
		handleRCCConnectionTimeout = nil,
		forceInitializeStoreOnMount = not not FFlagEnableCEVForceInitialize or nil
	})

	return nil
end

return CrossExperienceVoiceComponent
