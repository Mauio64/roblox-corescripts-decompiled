local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)

local function Stepper(props)
	local numberOfSteps = props.numberOfSteps
	local layoutOrder = props.layoutOrder
	local numberActivated = props.numberActivated

	local v = {}

	for i = 1, numberOfSteps do
		v[i] = i
	end

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(0.9, 0, 0.12, 0),
			Position = UDim2.new(0, 0, 0, 0),
			LayoutOrder = layoutOrder
		},
		React.createElement("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		(LuauPolyfill.Array.map(v, function(_, layoutOrder2)
			return React.createElement("Frame", {
				LayoutOrder = layoutOrder2,
				BackgroundTransparency = layoutOrder2 <= numberActivated and 0 or 0.7,
				Size = UDim2.new(1 / numberOfSteps, 0, 0.5, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			}, { React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }) })
		end))
	)
end

return Stepper
