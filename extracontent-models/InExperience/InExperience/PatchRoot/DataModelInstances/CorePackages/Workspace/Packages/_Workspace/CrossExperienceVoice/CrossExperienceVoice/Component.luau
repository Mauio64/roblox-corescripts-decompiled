local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")

local useCrossExperienceVoice = require(CrossExperienceVoice.Hooks.useCrossExperienceVoice)
local Flags = require(CrossExperienceVoice.Flags)
local FFlagEnableCEVForceInitialize = Flags.FFlagEnableCEVForceInitialize

local function CrossExperienceVoiceComponent(): nil
	useCrossExperienceVoice({
		handleRCCConnectionTimeout = nil,
		forceInitializeStoreOnMount = FFlagEnableCEVForceInitialize and true or nil
	})

	return nil
end

return CrossExperienceVoiceComponent
