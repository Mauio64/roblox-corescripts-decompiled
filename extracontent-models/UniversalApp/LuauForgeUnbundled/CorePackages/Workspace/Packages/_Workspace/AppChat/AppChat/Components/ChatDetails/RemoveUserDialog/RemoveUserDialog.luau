require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local warning = SocialLibraries.Components.AlertViews.Warning

local v5 = {
	titleText = "Placeholder title",
	bodyText = "Placeholder body",
	cancelText = "TempCancel",
	confirmText = "TempConfirm",
	failureTitleText = "FailureTitle",
	failureBodyText = "FailureBody",
	failureButtonText = "FailureButton",
	soakAreaColor3 = Color3.fromRGB(25, 25, 25),
	soakAreaTransparency = 0.8,
	width = UDim.new(0.8, 0),
	displayFailed = false,
	onActivated = nil,
	onModalClose = nil
}

function LUAUFORGE_MODULE_GLOBALS_heB_RemoveUserDialog(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	return React.createElement(warning, joined)
end

return LUAUFORGE_MODULE_GLOBALS_heB_RemoveUserDialog
