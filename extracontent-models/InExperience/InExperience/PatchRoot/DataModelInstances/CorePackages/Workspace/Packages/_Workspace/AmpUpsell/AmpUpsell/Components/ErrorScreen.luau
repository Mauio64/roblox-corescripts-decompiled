local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local sendButtonClickEvent = require(AmpUpsell.Analytics.sendButtonClickEvent)

local function selectScreenSize(p)
	return p.ScreenSize
end

local function ErrorScreen(props)
	local onRetry = props.onRetry
	local onCancel = props.onCancel
	local featureName = props.featureName
	local v = useLocalization({
		title = "Amp.ErrorScreen.Title",
		bodyText = "Amp.ErrorScreen.BodyText",
		buttonRetry = "Amp.ErrorScreen.Retry",
		buttonCancel = "Amp.ErrorScreen.Cancel"
	})
	local v2

	if props.analyticsService then
		v2 = props.analyticsService
	else
		v2 = AnalyticsService.EventStream
	end

	local screenSize = useSelector(selectScreenSize)

	return React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = screenSize,
		title = v.title,
		bodyText = v.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = function()
							sendButtonClickEvent(v2, "AmpErrorScreen", featureName, "Cancel")
							onCancel()
						end,
						text = v.buttonCancel
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = function()
							sendButtonClickEvent(v2, "AmpErrorScreen", featureName, "Retry")
							onRetry()
						end,
						text = v.buttonRetry
					}
				}
			}
		}
	})
end

return ErrorScreen
