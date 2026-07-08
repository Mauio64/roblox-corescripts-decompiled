local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLibraries = require(AppChat.SocialLibraries)

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Warning = SocialLibraries.Components.AlertViews.Warning
local t1 = {
	titleText = "Placeholder title",
	bodyText = "Placeholder body",
	cancelText = "TempCancel",
	confirmText = "TempConfirm",
	failureTitleText = "FailureTitle",
	failureBodyText = "FailureBody",
	failureButtonText = "FailureButton",
	soakAreaTransparency = 0.8,
	displayFailed = false,
	onActivated = nil,
	onModalClose = nil,
	soakAreaColor3 = Color3.fromRGB(25, 25, 25),
	width = UDim.new(0.8, 0)
}

function LeaveGroupDialog(t2: {[any]: any}) -- line: 54
	-- upvalues: Cryo (copy), t1 (copy), React (copy), Warning (copy)
	local v9 = Cryo.Dictionary.join(t1, t2)

	return React.createElement(Warning, v9)
end

return LeaveGroupDialog
