local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

return function(props)
	local v5 = useDesignTokens()
	local font = v5.LuaApps.CrossDeviceLogin.layoutHeaderFont.Font
	local fontSize = v5.LuaApps.CrossDeviceLogin.layoutHeaderFont.FontSize
	local color3 = v5.LuaApps.CrossDeviceLogin.layoutTextColor.Color3
	local warningTextVerticalAlignment = v5.LuaApps.CrossDeviceLogin.warningTextVerticalAlignment
	local buttonFrameWidth = v5.LuaApps.CrossDeviceLogin.buttonFrameWidth
	local baseSize = props.Style.Font.BaseSize

	return Roact.createFragment({
		Align = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 16),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TabletHeader = not props.HighKeyboardMode and Roact.createElement("TextLabel", {
			FontFace = normalizeFontFace(font),
			TextSize = fontSize,
			TextColor3 = color3,
			Text = props.TabletHeaderText or "",
			Size = UDim2.new(1, 0, 0, fontSize),
			LayoutOrder = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1
		}),
		WarningText = Roact.createElement(
			FitChildren.FitFrame,
			{
				Size = UDim2.new(1, 0, 1, 0),
				fitAxis = FitChildren.FitAxis.Height,
				LayoutOrder = 2,
				BackgroundTransparency = 1
			},
			{
				Align = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = warningTextVerticalAlignment,
					Padding = UDim.new(0, 16),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Icon = props.Icon,
				WarningText = props.WarningText
			}
		),
		CodeInput = props.InputBox and props.ConfirmCodeButton and props.ConfirmCodeButtonWidth and Roact.createElement("Frame", {
			LayoutOrder = 3,
			Size = UDim2.new(1, -16 - props.ConfirmCodeButtonWidth, 0, 30),
			BackgroundTransparency = 1
		}, {
			InputBox = props.InputBox,
			InputWarning = props.InputWarning,
			ButtonWrapper = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(0, props.ConfirmCodeButtonWidth, 1, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(1, 16, 0, 0)
				},
				{ ConfirmButton = props.ConfirmCodeButton }
			)
		}),
		CodeConfirmButtonFrame = props.LoginButton and props.CancelButton and Roact.createElement("Frame", {
			Size = UDim2.new(buttonFrameWidth, 0, 0, baseSize * 2),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}, {
			CancelButtonWrapper = Roact.createElement(
				"Frame",
				{ Size = UDim2.new(0.5, -6, 1, 0), BackgroundTransparency = 1 },
				{ CancelButton = props.CancelButton }
			),
			LoginButtonWrapper = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(0.5, -6, 1, 0),
					Position = UDim2.new(0.5, 6, 0, 0),
					BackgroundTransparency = 1
				},
				{ LoginButton = props.LoginButton }
			)
		})
	})
end
