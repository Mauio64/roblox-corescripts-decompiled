local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

return function(p1) -- line: 13
	-- upvalues: useDesignTokens (copy), Roact (copy), FitChildren (copy)
	local v7 = useDesignTokens()
	local layoutHeaderFontFont = v7.LuaApps.CrossDeviceLogin.layoutHeaderFont.Font
	local FontSize = v7.LuaApps.CrossDeviceLogin.layoutHeaderFont.FontSize
	local layoutTextColorColor3 = v7.LuaApps.CrossDeviceLogin.layoutTextColor.Color3
	local warningTextVerticalAlignment = v7.LuaApps.CrossDeviceLogin.warningTextVerticalAlignment
	local buttonFrameWidth = v7.LuaApps.CrossDeviceLogin.buttonFrameWidth
	local BaseSize = p1.Style.Font.BaseSize

	return Roact.createFragment({
		Align = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 16),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TabletHeader = not p1.HighKeyboardMode and Roact.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Font = layoutHeaderFontFont,
			TextSize = FontSize,
			TextColor3 = layoutTextColorColor3,
			Text = p1.TabletHeaderText or "",
			Size = UDim2.new(1, 0, 0, FontSize),
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		WarningText = Roact.createElement(FitChildren.FitFrame, {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			fitAxis = FitChildren.FitAxis.Height
		}, {
			Align = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = warningTextVerticalAlignment,
				Padding = UDim.new(0, 16),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Icon = p1.Icon,
			WarningText = p1.WarningText
		}),
		CodeInput = p1.InputBox and (p1.ConfirmCodeButton and (p1.ConfirmCodeButtonWidth and Roact.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -16 - p1.ConfirmCodeButtonWidth, 0, 30)
		}, {
			InputBox = p1.InputBox,
			InputWarning = p1.InputWarning,
			ButtonWrapper = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, p1.ConfirmCodeButtonWidth, 1, 0),
				Position = UDim2.new(1, 16, 0, 0)
			}, {
				ConfirmButton = p1.ConfirmCodeButton
			})
		}))),
		CodeConfirmButtonFrame = p1.LoginButton and (p1.CancelButton and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(buttonFrameWidth, 0, 0, BaseSize * 2)
		}, {
			CancelButtonWrapper = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0.5, -6, 1, 0)
			}, {
				CancelButton = p1.CancelButton
			}),
			LoginButtonWrapper = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0.5, -6, 1, 0),
				Position = UDim2.new(0.5, 6, 0, 0)
			}, {
				LoginButton = p1.LoginButton
			})
		}))
	})
end
