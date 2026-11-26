game:DefineFastFlag("FixSeamlessVoiceIntegrationWithPrivateVoice2", false)

local GetFFlagEnableCrossExpVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableCrossExpVoice")

return function()
	return GetFFlagEnableCrossExpVoice() and game:GetFastFlag("FixSeamlessVoiceIntegrationWithPrivateVoice2")
end
