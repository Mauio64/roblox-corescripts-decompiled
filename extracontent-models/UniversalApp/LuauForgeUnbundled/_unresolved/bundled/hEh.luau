local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

	local createFragment = Roact.createFragment
	local v6 = {
		Align = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 16),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TabletHeader = 0,
		WarningText = 0,
		CodeInput = 0,
		CodeConfirmButtonFrame = 0
	}

	local v7 = not props.HighKeyboardMode

	if v7 then
		local createElement = Roact.createElement
		local v9 = {
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			Text = 0,
			Size = 0,
			LayoutOrder = 1,
			TextXAlignment = 0,
			BackgroundTransparency = 1
		}

		local v11 = if foundationFontFaceMigration then normalizeFontFace(font) else nil
		v9.FontFace = v11
		v9.TextSize = fontSize
		v9.TextColor3 = color3
		v9.Text = props.TabletHeaderText or ""
		v9.Size = UDim2.new(1, 0, 0, fontSize)

		v9.TextXAlignment = Enum.TextXAlignment.Left
		v7 = createElement("TextLabel", v9)
	end

	v6.TabletHeader = v7

	v6.WarningText = Roact.createElement(
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
	)

	v6.CodeInput = props.InputBox
		and props.ConfirmCodeButton
		and props.ConfirmCodeButtonWidth
		and Roact.createElement("Frame", {
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
		})

	v6.CodeConfirmButtonFrame = props.LoginButton and props.CancelButton and Roact.createElement("Frame", {
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
	return createFragment(v6)
end
