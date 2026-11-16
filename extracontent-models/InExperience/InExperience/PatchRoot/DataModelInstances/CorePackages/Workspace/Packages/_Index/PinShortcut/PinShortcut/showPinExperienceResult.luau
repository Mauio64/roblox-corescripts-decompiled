local parent = script:FindFirstAncestor("PinShortcut").Parent

local CentralOverlay = require(parent.CentralOverlay)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

local function showPinExperienceResult(callback, status, experienceName: string, p)
	local pinExperienceResultSnackbar = CentralOverlayType.PinExperienceResultSnackbar
	local onViewShortcut

	if p then
		onViewShortcut = p.onViewShortcut
	end

	local onRetry

	if p then
		onRetry = p.onRetry
	end

	callback(SetCentralOverlay(pinExperienceResultSnackbar, {
		status = status,
		experienceName = experienceName,
		onViewShortcut = onViewShortcut,
		onRetry = onRetry
	}))
end

return showPinExperienceResult
