local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)

require(CoreScriptsPlayerFeedback.CaptureTypes)

return (React.memo(function(p)
	return React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0)
		},
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			PreviewImage = React.createElement("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ImageContent = Content.fromObject(p.capture),
				LayoutOrder = 1,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(1, 0, 0, 260)
			}, {
				Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 6) })
			})
		}
	)
end))
