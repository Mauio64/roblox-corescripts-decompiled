local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local React = require(Parent.React)
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local authButtonClick = require(Parent.AuthAnalytics).Events.authButtonClick

local function FAELoadingModal(t1: {[any]: any}) -- line: 27
	-- upvalues: useScreenSize (copy), useLocalization (copy), React (copy), authButtonClick (copy), Loading (copy), IconSize (copy), InteractiveAlert (copy), ButtonType (copy)
	local onCancel = t1.onCancel
	local sessionId = t1.sessionId
	local entryPointEventCtx = t1.entryPointEventCtx
	local v17 = useScreenSize()
	local v18 = useLocalization({
		title = "Amp.FAEUpsell.Modal.Loading.Title",
		bodyText = "Amp.FAEUpsell.Modal.Loading.Text",
		cancelBtn = "Amp.FAEUpsell.Modal.Loading.ButtonCancel"
	})
	local v19 = React.useCallback(function() -- line: 40
		-- upvalues: authButtonClick (copy), entryPointEventCtx (copy), sessionId (copy), onCancel (copy)
		authButtonClick(entryPointEventCtx, "faeLoadingCancel", sessionId)
		onCancel()
	end, {
		onCancel,
		sessionId,
		entryPointEventCtx
	})
	local v20 = React.useCallback(function() -- line: 45
		-- upvalues: React (copy), Loading (copy), IconSize (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 80)
		}, {
			Spinner = React.createElement(Loading, {
				size = IconSize.Medium,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	end, {})

	return React.createElement(InteractiveAlert, {
		screenSize = v17,
		title = v18.title,
		bodyText = v18.bodyText,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = v19,
					text = v18.cancelBtn
				}
			}}
		},
		middleContent = v20
	})
end

return FAELoadingModal
