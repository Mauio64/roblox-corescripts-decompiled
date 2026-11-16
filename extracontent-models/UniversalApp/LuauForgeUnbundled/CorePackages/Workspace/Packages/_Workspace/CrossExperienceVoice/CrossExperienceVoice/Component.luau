local useCrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useCrossExperienceVoice")
local fFlagEnableCEVForceInitialize = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Flags").FFlagEnableCEVForceInitialize

local function CrossExperienceVoiceComponent(): nil
	useCrossExperienceVoice({
		handleRCCConnectionTimeout = nil,
		forceInitializeStoreOnMount = fFlagEnableCEVForceInitialize and true or nil
	})

	return nil
end

return CrossExperienceVoiceComponent
