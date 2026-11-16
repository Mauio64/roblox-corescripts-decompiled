local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local textInput = SocialLibraries.Components.AlertViews.TextInput
local usePositionOffsetForVirtualKeyboard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/usePositionOffsetForVirtualKeyboard")

local v5 = {
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

function LUAUFORGE_MODULE_GLOBALS_hdC_EditChatGroupNameDialog(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = usePositionOffsetForVirtualKeyboard({ isNearBottomOfScreen = false })

	return React.createElement(textInput, Cryo.Dictionary.join(joined, {
		shouldAdjustForKeyboard = v6 == nil
	}))
end

return LUAUFORGE_MODULE_GLOBALS_hdC_EditChatGroupNameDialog
