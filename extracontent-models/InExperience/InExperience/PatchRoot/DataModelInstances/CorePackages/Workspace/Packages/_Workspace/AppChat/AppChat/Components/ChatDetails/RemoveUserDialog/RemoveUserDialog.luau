local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local SocialLibraries = require(AppChat.SocialLibraries)

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local Warning = SocialLibraries.Components.AlertViews.Warning

local v = {
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

function RemoveUserDialog(p)
	local joined = Cryo.Dictionary.join(v, p)
	return React.createElement(Warning, joined)
end

return RemoveUserDialog
