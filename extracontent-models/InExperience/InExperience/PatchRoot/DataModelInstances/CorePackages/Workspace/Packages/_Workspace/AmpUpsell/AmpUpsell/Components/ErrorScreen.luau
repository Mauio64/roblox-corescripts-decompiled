local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local useSelector = require(AmpUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local UIBlox = require(AmpUpsellParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local sendButtonClickEvent = require(AmpUpsell.Analytics.sendButtonClickEvent)

local function selectScreenSize(p1) -- line: 19
	return p1.ScreenSize
end
local function ErrorScreen(t1: {[any]: any}) -- line: 23
	-- upvalues: useLocalization (copy), AnalyticsService (copy), useSelector (copy), selectScreenSize (copy), React (copy), InteractiveAlert (copy), ButtonType (copy), sendButtonClickEvent (copy)
	local onRetry = t1.onRetry
	local onCancel = t1.onCancel
	local featureName = t1.featureName
	local v18 = useLocalization({
		title = "Amp.ErrorScreen.Title",
		bodyText = "Amp.ErrorScreen.BodyText",
		buttonRetry = "Amp.ErrorScreen.Retry",
		buttonCancel = "Amp.ErrorScreen.Cancel"
	})
	local v19 = if not t1.analyticsService then AnalyticsService.EventStream else t1.analyticsService
	local v20 = useSelector(selectScreenSize)

	return React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = v20,
		title = v18.title,
		bodyText = v18.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = function() -- line: 48
							-- upvalues: sendButtonClickEvent (copy), v19 (copy), featureName (copy), onCancel (copy)
							sendButtonClickEvent(v19, "AmpErrorScreen", featureName, "Cancel")
							onCancel()
						end,
						text = v18.buttonCancel
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = function() -- line: 59
							-- upvalues: sendButtonClickEvent (copy), v19 (copy), featureName (copy), onRetry (copy)
							sendButtonClickEvent(v19, "AmpErrorScreen", featureName, "Retry")
							onRetry()
						end,
						text = v18.buttonRetry
					}
				}
			}
		}
	})
end

return ErrorScreen
