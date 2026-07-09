local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local React = require(Parent.React)
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UIBlox = require(Parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local authButtonClick = require(Parent.AuthAnalytics).Events.authButtonClick

local function FAEFailedModal(t1: {[any]: any}) -- line: 24
	-- upvalues: useScreenSize (copy), useLocalization (copy), React (copy), authButtonClick (copy), InteractiveAlert (copy), ButtonType (copy)
	local onClose = t1.onClose
	local onRetry = t1.onRetry
	local sessionId = t1.sessionId
	local entryPointEventCtx = t1.entryPointEventCtx
	local v15 = useScreenSize()
	local v16 = useLocalization({
		title = "Amp.FAEUpsell.Modal.Failed.Title",
		bodyText = "Amp.FAEUpsell.Modal.Failed.Text",
		closeBtn = "Amp.FAEUpsell.Modal.Failed.ButtonClose",
		retryBtn = "Amp.FAEUpsell.Modal.Failed.ButtonRetry"
	})
	local v17 = React.useCallback(function() -- line: 39
		-- upvalues: authButtonClick (copy), entryPointEventCtx (copy), sessionId (copy), onClose (copy)
		authButtonClick(entryPointEventCtx, "faeFailedClose", sessionId)
		onClose()
	end, {
		onClose,
		sessionId,
		entryPointEventCtx
	})
	local v18 = React.useCallback(function() -- line: 44
		-- upvalues: authButtonClick (copy), entryPointEventCtx (copy), sessionId (copy), onRetry (copy)
		authButtonClick(entryPointEventCtx, "faeFailedRetry", sessionId)
		onRetry()
	end, {
		onRetry,
		sessionId,
		entryPointEventCtx
	})

	return React.createElement(InteractiveAlert, {
		screenSize = v15,
		title = v16.title,
		bodyText = v16.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						buttonType = ButtonType.Secondary,
						onActivated = v17,
						text = v16.closeBtn
					}
				},
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						onActivated = v18,
						text = v16.retryBtn
					}
				}
			}
		}
	})
end

return FAEFailedModal
