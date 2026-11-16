local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/CentralOverlay").Actions.SetCentralOverlay

return function()
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.LoginPasswordResetPrompt, {}))
	end
end
