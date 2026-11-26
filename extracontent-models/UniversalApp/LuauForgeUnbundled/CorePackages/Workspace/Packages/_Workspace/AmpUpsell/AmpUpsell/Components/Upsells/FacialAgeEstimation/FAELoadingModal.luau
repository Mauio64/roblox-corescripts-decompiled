local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")

local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppHooks").useScreenSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local buttonType = UIBlox.App.Button.Enum.ButtonType

local authButtonClick = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthAnalytics").Events.authButtonClick

local function FAELoadingModal(props)
	local onCancel = props.onCancel
	local sessionId = props.sessionId
	local entryPointEventCtx = props.entryPointEventCtx

	local v5 = useScreenSize()

	local v6 = useLocalization({
		title = "Amp.FAEUpsell.Modal.Loading.Title",
		bodyText = "Amp.FAEUpsell.Modal.Loading.Text",
		cancelBtn = "Amp.FAEUpsell.Modal.Loading.ButtonCancel"
	})

	local v7 = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "faeLoadingCancel", sessionId)
		onCancel()
	end, { onCancel, sessionId, entryPointEventCtx })

	local v8 = React.useCallback(function()
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
					props = { onActivated = v7, text = v6.cancelBtn }
				}
			}
		},
		middleContent = v8
	})
end

return FAELoadingModal
