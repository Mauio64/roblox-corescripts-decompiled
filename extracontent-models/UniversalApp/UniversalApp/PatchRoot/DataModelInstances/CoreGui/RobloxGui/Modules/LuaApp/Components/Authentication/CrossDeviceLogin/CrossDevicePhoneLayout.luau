local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)

return function(p1) -- line: 11
	-- upvalues: Roact (copy), FitChildren (copy)
	local BaseSize = p1.Style.Font.BaseSize

	return Roact.createFragment({
		Align = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 14),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Icon = not p1.HighKeyboardMode and p1.Icon,
		WarningText = p1.WarningText,
		InputArea = p1.InputBox and Roact.createElement(FitChildren.FitFrame, {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			fitAxis = FitChildren.FitAxis.Height
		}, {
			Align = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 3),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			InputBox = p1.InputBox,
			InputWarning = p1.InputWarning
		}),
		NextButtonWrapper = Roact.createElement("Frame", {
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, BaseSize * 2)
		}, {
			NextButton = p1.ConfirmCodeButton or p1.LoginButton
		}),
		CancelButton = p1.CancelButton and Roact.createElement("Frame", {
			LayoutOrder = 5,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, BaseSize * 2)
		}, {
			CancelButton = p1.CancelButton
		})
	})
end
