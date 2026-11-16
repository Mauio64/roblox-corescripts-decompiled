local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")

local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxAppHooks").useScreenSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local buttonType = UIBlox.App.Button.Enum.ButtonType

local authButtonClick = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthAnalytics").Events.authButtonClick

local function FAEFailedModal(props)
	local onClose = props.onClose
	local onRetry = props.onRetry
	local sessionId = props.sessionId
	local entryPointEventCtx = props.entryPointEventCtx

	local v5 = useScreenSize()

	local v6 = useLocalization({
		title = "Amp.FAEUpsell.Modal.Failed.Title",
		bodyText = "Amp.FAEUpsell.Modal.Failed.Text",
		closeBtn = "Amp.FAEUpsell.Modal.Failed.ButtonClose",
		retryBtn = "Amp.FAEUpsell.Modal.Failed.ButtonRetry"
	})

	local v7 = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "faeFailedClose", sessionId)
		onClose()
	end, { onClose, sessionId, entryPointEventCtx })

	local v8 = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "faeFailedRetry", sessionId)
		onRetry()
	end, { onRetry, sessionId, entryPointEventCtx })

	return React.createElement(interactiveAlert, {
		screenSize = v5,
		title = v6.title,
		bodyText = v6.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						buttonType = buttonType.Secondary,
						onActivated = v7,
						text = v6.closeBtn
					}
				},
				{
					buttonType = buttonType.PrimaryContextual,
					props = { onActivated = v8, text = v6.retryBtn }
				}
			}
		}
	})
end

return FAEFailedModal
