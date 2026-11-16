local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Actions.SetCentralOverlay

return function()
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.ReportLogsOverlay, {}))
	end
end
