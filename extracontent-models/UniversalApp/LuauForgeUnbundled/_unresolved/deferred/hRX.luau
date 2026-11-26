local CorePackages = game:GetService("CorePackages")

local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module = require("@luauforge/bundled/gxM")
local module2 = require("@luauforge/bundled/fvN")

return function(props)
	local v5 = module({
		closeRoblox = "CoreScripts.Feedback.FeedbackBar.ExitFeedbackButton"
	})

	local v6 = React.useCallback(function()
		GuiService:BroadcastNotification("", module2.NATIVE_EXIT)
	end, {})
	return React.createElement(
		"Frame",
		{
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, props.buttonHeight)
		},
		{
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(props.buttonMaxWidth, props.buttonHeight)
			}),
			ExitAppButton = React.createElement(button, {
				buttonType = buttonType.Secondary,
				isDisabled = false,
				isLoading = false,
				onActivated = v6,
				maxWidth = props.buttonMaxWidth,
				size = UDim2.new(1, 0, 0, props.buttonHeight),
				text = v5.closeRoblox
			})
		}
	)
end
