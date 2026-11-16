local parent = script:FindFirstAncestor("AmpUpsell").Parent

local React = require(parent.React)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local ButtonType = UIBlox.App.Button.Enum.ButtonType

local AuthAnalytics = require(parent.AuthAnalytics)
local authButtonClick = AuthAnalytics.Events.authButtonClick

local function FAEFailedModal(props)
	local onClose = props.onClose
	local onRetry = props.onRetry
	local sessionId = props.sessionId
	local entryPointEventCtx = props.entryPointEventCtx

	local screenSize = useScreenSize()

	local v = useLocalization({
		title = "Amp.FAEUpsell.Modal.Failed.Title",
		bodyText = "Amp.FAEUpsell.Modal.Failed.Text",
		closeBtn = "Amp.FAEUpsell.Modal.Failed.ButtonClose",
		retryBtn = "Amp.FAEUpsell.Modal.Failed.ButtonRetry"
	})

	local onActivated = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "faeFailedClose", sessionId)
		onClose()
	end, { onClose, sessionId, entryPointEventCtx })

	local onActivated2 = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "faeFailedRetry", sessionId)
		onRetry()
	end, { onRetry, sessionId, entryPointEventCtx })

	return React.createElement(InteractiveAlert, {
		screenSize = screenSize,
		title = v.title,
		bodyText = v.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						buttonType = ButtonType.Secondary,
						onActivated = onActivated,
						text = v.closeBtn
					}
				},
				{
					buttonType = ButtonType.PrimaryContextual,
					props = { onActivated = onActivated2, text = v.retryBtn }
				}
			}
		}
	})
end

return FAEFailedModal
