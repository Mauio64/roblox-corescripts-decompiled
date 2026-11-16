local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useSelector
local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/AnalyticsService")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local sendButtonClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/sendButtonClickEvent")

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function ErrorScreen(props)
	local onRetry = props.onRetry
	local onCancel = props.onCancel
	local featureName = props.featureName
	local v5 = useLocalization({
		title = "Amp.ErrorScreen.Title",
		bodyText = "Amp.ErrorScreen.BodyText",
		buttonRetry = "Amp.ErrorScreen.Retry",
		buttonCancel = "Amp.ErrorScreen.Cancel"
	})

	local v6 = if props.analyticsService then props.analyticsService else AnalyticsService.EventStream
	local v7 = useSelector(selectScreenSize)

	return React.createElement(interactiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = v7,
		title = v5.title,
		bodyText = v5.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = function()
							sendButtonClickEvent(v6, "AmpErrorScreen", featureName, "Cancel")
							onCancel()
						end,
						text = v5.buttonCancel
					}
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = function()
							sendButtonClickEvent(v6, "AmpErrorScreen", featureName, "Retry")
							onRetry()
						end,
						text = v5.buttonRetry
					}
				}
			}
		}
	})
end

return ErrorScreen
