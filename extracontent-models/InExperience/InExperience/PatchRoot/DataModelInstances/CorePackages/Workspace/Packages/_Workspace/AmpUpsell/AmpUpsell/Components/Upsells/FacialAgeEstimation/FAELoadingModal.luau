local parent = script:FindFirstAncestor("AmpUpsell").Parent

local React = require(parent.React)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local ButtonType = UIBlox.App.Button.Enum.ButtonType

local AuthAnalytics = require(parent.AuthAnalytics)
local authButtonClick = AuthAnalytics.Events.authButtonClick

local function FAELoadingModal(props)
	local onCancel = props.onCancel
	local sessionId = props.sessionId
	local entryPointEventCtx = props.entryPointEventCtx

	local screenSize = useScreenSize()

	local v = useLocalization({
		title = "Amp.FAEUpsell.Modal.Loading.Title",
		bodyText = "Amp.FAEUpsell.Modal.Loading.Text",
		cancelBtn = "Amp.FAEUpsell.Modal.Loading.ButtonCancel"
	})

	local onActivated = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "faeLoadingCancel", sessionId)
		onCancel()
	end, { onCancel, sessionId, entryPointEventCtx })

	local middleContent = React.useCallback(function()
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 80),
			BackgroundTransparency = 1
		}, {
			Spinner = React.createElement(Loading, {
				size = IconSize.Medium,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	end, {})

	return React.createElement(InteractiveAlert, {
		screenSize = screenSize,
		title = v.title,
		bodyText = v.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = onActivated, text = v.cancelBtn }
				}
			}
		},
		middleContent = middleContent
	})
end

return FAELoadingModal
