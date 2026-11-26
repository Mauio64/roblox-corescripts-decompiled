local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

return function(props)
	local baseSize = props.Style.Font.BaseSize

	return Roact.createFragment({
		Align = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 14),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Icon = not props.HighKeyboardMode and props.Icon,
		WarningText = props.WarningText,
		InputArea = props.InputBox and Roact.createElement(
			FitChildren.FitFrame,
			{
				Size = UDim2.new(1, 0, 1, 0),
				fitAxis = FitChildren.FitAxis.Height,
				LayoutOrder = 3,
				BackgroundTransparency = 1
			},
			{
				Align = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				InputBox = props.InputBox,
				InputWarning = props.InputWarning
			}
		),
		NextButtonWrapper = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, baseSize * 2),
			LayoutOrder = 4,
			BackgroundTransparency = 1
		}, {
			NextButton = props.ConfirmCodeButton or props.LoginButton
		}),
		CancelButton = props.CancelButton and Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, baseSize * 2),
			LayoutOrder = 5,
			BackgroundTransparency = 1
		}, { CancelButton = props.CancelButton })
	})
end
