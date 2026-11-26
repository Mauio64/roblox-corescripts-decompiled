local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module = require("@luauforge/bundled/dXh")
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local module2 = require("@luauforge/deferred/gJI")

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function LooksConfirmationPrompt(p2)
	local v5 = useNavigation()
	local v6 = useSelector(selectScreenSize)

	local v7 = useLocalization({
		confirmationModalTitle = "Feature.Avatar.Title.UnsavedChanges",
		confirmationModalDescription = "Feature.Avatar.Message.LeavingComposerWithoutSave",
		confirmationModalLeftButton = "Feature.Avatar.Action.Stay",
		confirmationModalRightButton = "Feature.Avatar.Action.Leave"
	})

	local v8 = React.useCallback(function()
		module.closeFocusedScreen(v5)
	end, { v5 })

	return React.createElement(interactiveAlert, {
		title = v7.confirmationModalTitle,
		bodyText = v7.confirmationModalDescription,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = v8, text = v7.confirmationModalLeftButton }
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = p2.onOverlayClosed,
						text = v7.confirmationModalRightButton
					}
				}
			}
		},
		screenSize = v6
	})
end

return (require("@luauforge/deferred/gJH")((module2(LooksConfirmationPrompt))))
