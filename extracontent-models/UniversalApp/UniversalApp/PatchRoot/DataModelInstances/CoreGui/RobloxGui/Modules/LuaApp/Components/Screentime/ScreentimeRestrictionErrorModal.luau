local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Constants = require(Modules.LuaApp.Constants)
local getScreenBottomInset = require(Modules.LuaApp.getScreenBottomInset)

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: useLocalization (copy), useStyle (copy), getScreenBottomInset (copy), React (copy), ButtonType (copy), InteractiveAlert (copy), Constants (copy)
	local v12 = useLocalization({
		RetryButtonText = "Amp.ErrorScreen.Retry",
		OkButtonText = "CommonUI.Controls.Action.OK",
		CancelButtonText = "Amp.ErrorScreen.Cancel",
		SomethingWentWrontText = "Feature.Parents.Title.SomethingWentWrong"
	})
	local screenSize = t1.screenSize
	local Theme = useStyle().Theme
	local globalGuiInset = t1.globalGuiInset
	local v16 = getScreenBottomInset()
	local uDim2 = UDim2.fromOffset(0, globalGuiInset.top)
	local uDim2_2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v16)
	local v19, v20 = React.useState(false)
	local v21 = if t1.onRetry ~= nil then {
		{
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = function() -- line: 59
					-- upvalues: t1 (copy)
					t1.onClose()
				end,
				text = v12.CancelButtonText,
				isDisabled = v19
			}
		},
		{
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = function() -- line: 69
					-- upvalues: v20 (copy), t1 (copy)
					v20(true)
					t1.onRetry()
					v20(false)
				end,
				text = v12.RetryButtonText,
				isDisabled = v19
			}
		}
	} else {{
		buttonType = ButtonType.Secondary,
		props = {
			onActivated = function() -- line: 47
				-- upvalues: t1 (copy)
				t1.onClose()
			end,
			text = v12.OkButtonText
		}
	}}
	local v22 = React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = screenSize,
		title = v12.SomethingWentWrontText,
		bodyText = v12.SomethingWentWrontText,
		buttonStackInfo = {
			buttonHeight = 48,
			buttons = v21,
			forcedFillDirection = Enum.FillDirection.Vertical
		},
		onCloseClicked = t1.onClose
	})

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = Constants.DisplayOrder.AntiAddictionPrompt
	}, {
		OverlayFrame = React.createElement("ImageButton", {
			AutoButtonColor = false,
			ImageTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.Overlay.Color,
			BackgroundTransparency = Theme.Overlay.Transparency
		}, {
			Overlay = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Position = uDim2,
				Size = uDim2_2
			}, {
				Content = v22
			})
		})
	})
end
