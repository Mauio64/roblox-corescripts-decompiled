local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppHooks").useScreenSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Localization").Hooks.useLocalization

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local buttonType = UIBlox.App.Button.Enum.ButtonType

local function AuthorizationLoadingModal(p2)
	local onCancel = p2.onCancel

	local v5 = useScreenSize()

	local v6 = useLocalization({
		title = "Amp.FAEUpsell.Modal.Loading.Title",
		bodyText = "Amp.FAEUpsell.Modal.Loading.Text",
		cancelBtn = "Amp.FAEUpsell.Modal.Loading.ButtonCancel"
	})

	local v7 = React.useCallback(function()
		return React.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 80), BackgroundTransparency = 1 },
			{
				Spinner = React.createElement(loading, {
					size = iconSize.Medium,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			}
		)
	end, {})

	return React.createElement(interactiveAlert, {
		screenSize = v5,
		title = v6.title,
		bodyText = v6.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = onCancel, text = v6.cancelBtn }
				}
			}
		},
		middleContent = v7
	})
end

return AuthorizationLoadingModal
