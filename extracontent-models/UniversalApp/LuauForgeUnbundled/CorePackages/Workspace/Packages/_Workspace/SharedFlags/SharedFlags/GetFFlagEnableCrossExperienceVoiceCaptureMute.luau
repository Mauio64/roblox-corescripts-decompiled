local GetFFlagEnableCrossExpVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableCrossExpVoice")

return function()
	return GetFFlagEnableCrossExpVoice() and game:GetEngineFeature("CrossExperienceVoiceMuteAll")
end
