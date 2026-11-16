local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialLibraries = require(AppChat.SocialLibraries)

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local TextInput = SocialLibraries.Components.AlertViews.TextInput
local usePositionOffsetForVirtualKeyboard = require(AppChat.Hooks.usePositionOffsetForVirtualKeyboard)

local v = {
	titleText = "Placeholder",
	cancelText = "CancelText",
	confirmText = "ConfirmText",
	warningText = nil,
	inputText = nil,
	placeholderText = nil,
	soakAreaColor3 = Color3.fromRGB(25, 25, 25),
	soakAreaTransparency = 0.8,
	onActivated = nil,
	onModalClose = nil
}

function EditChatGroupNameDialog(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = usePositionOffsetForVirtualKeyboard({ isNearBottomOfScreen = false })

	return React.createElement(TextInput, Cryo.Dictionary.join(joined, {
		shouldAdjustForKeyboard = v2 == nil
	}))
end

return EditChatGroupNameDialog
