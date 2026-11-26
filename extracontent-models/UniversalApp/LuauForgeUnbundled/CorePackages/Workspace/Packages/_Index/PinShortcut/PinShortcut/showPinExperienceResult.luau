local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/CentralOverlay")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PinShortcut/RobloxAppEnums")

local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local centralOverlayType = RobloxAppEnums.CentralOverlayType

local function showPinExperienceResult(callback, p2, p3, p4)
	local pinExperienceResultSnackbar = centralOverlayType.PinExperienceResultSnackbar

	local v7 = if p4 then p4.onViewShortcut else nil
	local v8 = if p4 then p4.onRetry else nil
	callback(setCentralOverlay(pinExperienceResultSnackbar, {
		status = p2,
		experienceName = p3,
		onViewShortcut = v7,
		onRetry = v8
	}))
end

return showPinExperienceResult
