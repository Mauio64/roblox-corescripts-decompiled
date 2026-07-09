local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useLocalization (copy), React (copy), GuiService (copy), NotificationType (copy), Button (copy), ButtonType (copy)
	local v12 = useLocalization({
		closeRoblox = "CoreScripts.Feedback.FeedbackBar.ExitFeedbackButton"
	})
	local v13 = React.useCallback(function() -- line: 24
		-- upvalues: GuiService (copy), NotificationType (copy)
		GuiService:BroadcastNotification("", NotificationType.NATIVE_EXIT)
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, t1.buttonHeight)
	}, {
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(t1.buttonMaxWidth, t1.buttonHeight)
		}),
		ExitAppButton = React.createElement(Button, {
			isDisabled = false,
			isLoading = false,
			buttonType = ButtonType.Secondary,
			onActivated = v13,
			maxWidth = t1.buttonMaxWidth,
			size = UDim2.new(1, 0, 0, t1.buttonHeight),
			text = v12.closeRoblox
		})
	})
end
