local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLibraries = require(AppChat.SocialLibraries)

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local TextInput = SocialLibraries.Components.AlertViews.TextInput
local usePositionOffsetForVirtualKeyboard = require(AppChat.Hooks.usePositionOffsetForVirtualKeyboard)
local t1 = {
	titleText = "Placeholder",
	cancelText = "CancelText",
	confirmText = "ConfirmText",
	warningText = nil,
	inputText = nil,
	placeholderText = nil,
	soakAreaTransparency = 0.8,
	onActivated = nil,
	onModalClose = nil,
	soakAreaColor3 = Color3.fromRGB(25, 25, 25)
}

function EditChatGroupNameDialog(t2: {[any]: any}) -- line: 46
	-- upvalues: Cryo (copy), t1 (copy), usePositionOffsetForVirtualKeyboard (copy), React (copy), TextInput (copy)
	local v10 = Cryo.Dictionary.join(t1, t2)
	local v11 = usePositionOffsetForVirtualKeyboard({
		isNearBottomOfScreen = false
	})

	return React.createElement(TextInput, Cryo.Dictionary.join(v10, {
		shouldAdjustForKeyboard = v11 == nil
	}))
end

return EditChatGroupNameDialog
