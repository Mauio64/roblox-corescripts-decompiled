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
		AddFifteenButtonText = "Feature.Screentime.Label.FifteenMoreMinutes",
		AddFiveButtonText = "Feature.Screentime.Label.FiveMoreMinutes",
		TitleText = "Feature.Screentime.Label.Options",
		BodyText = "Feature.Screentime.Description.MoreScreentimeDescription"
	})
	local screenSize = t1.screenSize
	local Theme = useStyle().Theme
	local globalGuiInset = t1.globalGuiInset
	local v16 = getScreenBottomInset()
	local uDim2 = UDim2.fromOffset(0, globalGuiInset.top)
	local uDim2_2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v16)
	local v19, v20 = React.useState(false)
	local t2 = {
		{
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = function() -- line: 45
					-- upvalues: v20 (copy), t1 (copy)
					v20(true)
					t1.onAddTime(15)
					v20(false)
				end,
				text = v12.AddFifteenButtonText,
				isDisabled = v19
			}
		},
		{
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = function() -- line: 57
					-- upvalues: v20 (copy), t1 (copy)
					v20(true)
					t1.onAddTime(5)
					v20(false)
				end,
				text = v12.AddFiveButtonText,
				isDisabled = v19
			}
		}
	}
	local v22 = React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = screenSize,
		title = v12.TitleText,
		bodyText = v12.BodyText,
		buttonStackInfo = {
			buttonHeight = 48,
			buttons = t2,
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
