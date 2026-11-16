local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useStyle = UIBlox.Core.Style.useStyle

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module = require("@luauforge/bundled/dwA")
local module2 = require("@luauforge/bundled/hWL")

return function(props)
	local v5 = useLocalization({
		AddFifteenButtonText = "Feature.Screentime.Label.FifteenMoreMinutes",
		AddFiveButtonText = "Feature.Screentime.Label.FiveMoreMinutes",
		TitleText = "Feature.Screentime.Label.Options",
		BodyText = "Feature.Screentime.Description.MoreScreentimeDescription"
	})

	local screenSize = props.screenSize

	local theme = useStyle().Theme
	local globalGuiInset = props.globalGuiInset
	local v6 = module2()
	local udim = UDim2.fromOffset(0, globalGuiInset.top)
	local udim2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v6)

	local state, setState = React.useState(false)
	local v7 = {
		{
			buttonType = buttonType.Secondary,
			props = {
				onActivated = function()
					setState(true)
					props.onAddTime(15)
					setState(false)
				end,
				text = v5.AddFifteenButtonText,
				isDisabled = state
			}
		},
		{
			buttonType = buttonType.Secondary,
			props = {
				onActivated = function()
					setState(true)
					props.onAddTime(5)
					setState(false)
				end,
				text = v5.AddFiveButtonText,
				isDisabled = state
			}
		}
	}

	local element = React.createElement(interactiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = screenSize,
		title = v5.TitleText,
		bodyText = v5.BodyText,
		buttonStackInfo = {
			buttons = v7,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttonHeight = 48
		},
		onCloseClicked = props.onClose
	})

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = module.DisplayOrder.AntiAddictionPrompt,
			IgnoreGuiInset = true
		},
		{
			OverlayFrame = React.createElement("ImageButton", {
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = 1,
				BackgroundColor3 = theme.Overlay.Color,
				BackgroundTransparency = theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Selectable = false
			}, {
				Overlay = React.createElement(
					"Frame",
					{
						Position = udim,
						Size = udim2,
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					},
					{ Content = element }
				)
			})
		}
	)
end
