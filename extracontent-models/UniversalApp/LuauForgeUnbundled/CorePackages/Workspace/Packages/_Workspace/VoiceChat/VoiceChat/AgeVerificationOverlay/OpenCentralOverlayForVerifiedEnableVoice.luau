local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/CentralOverlay").Actions.SetCentralOverlay

return function(options)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.VerifiedEnableVoice, options or {}))
	end
end
