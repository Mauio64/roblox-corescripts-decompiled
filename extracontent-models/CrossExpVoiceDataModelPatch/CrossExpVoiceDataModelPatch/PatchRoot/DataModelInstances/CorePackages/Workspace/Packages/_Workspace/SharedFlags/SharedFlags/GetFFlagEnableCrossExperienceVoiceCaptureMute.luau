local GetFFlagEnableCrossExpVoice = require(script.Parent.GetFFlagEnableCrossExpVoice)

return function()
	return GetFFlagEnableCrossExpVoice() and game:GetEngineFeature("CrossExperienceVoiceMuteAll")
end
