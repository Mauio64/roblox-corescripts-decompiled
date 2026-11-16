local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local categories = require("@luauforge/bundled/fuM").Constants.Categories
local module = require("@luauforge/bundled/dTM")
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local module2 = require("@luauforge/deferred/gfc")

local v5 = {
	[categories.Animations] = {
		title = "Feature.Avatar.Title.ClearAnimationsConfirmation",
		message = "Feature.Avatar.Message.ClearAnimations"
	},
	[categories.Accessories] = {
		title = "Feature.Avatar.Title.ClearAccessoriesConfirmation",
		message = "Feature.Avatar.Message.ClearAccessories"
	},
	[categories.Body] = {
		title = "Feature.Avatar.Title.ClearBodyConfirmation",
		message = "Feature.Avatar.Message.ClearBody"
	},
	[categories.Clothing] = {
		title = "Feature.Avatar.Title.ClearClothesConfirmation",
		message = "Feature.Avatar.Message.ClearClothes"
	},
	[categories.Makeup] = {
		title = "Feature.Avatar.Title.ClearMakeupConfirmation",
		message = "Feature.Avatar.Message.ClearMakeupConfirmation"
	}
}

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function SlotEditorClearAllConfirmationPrompt(p2)
	local v6 = useNavigation()
	local v7 = useSelector(selectScreenSize)
	local param = v6.getParam("slotCategory")
	local param2 = v6.getParam("clearAll")

	local v8 = useLocalization({
		confirmationModalTitle = v5[param].title,
		confirmationModalDescription = v5[param].message,
		confirmationModalLeftButton = "Feature.Avatar.Action.Cancel",
		confirmationModalRightButton = "Feature.Avatar.Action.Clear"
	})

	local v9 = useCallback(function()
		module.closeFocusedScreen(v6)
	end, { v6 })

	return React.createElement(interactiveAlert, {
		title = v8.confirmationModalTitle,
		bodyText = v8.confirmationModalDescription,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = v9, text = v8.confirmationModalLeftButton }
				},
				{
					buttonType = buttonType.PrimaryContextual,
					props = {
						onActivated = function()
							param2()
							v9()
						end,
						text = v8.confirmationModalRightButton
					}
				}
			}
		},
		screenSize = v7
	})
end

return (module2(SlotEditorClearAllConfirmationPrompt))
