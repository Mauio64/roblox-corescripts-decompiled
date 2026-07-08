local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)

local function Stepper(t1: {[any]: any}) -- line: 11
	-- upvalues: React (copy), LuauPolyfill (copy)
	local numberOfSteps = t1.numberOfSteps
	local layoutOrder = t1.layoutOrder
	local numberActivated = t1.numberActivated
	local t2 = {}

	for i = 1, numberOfSteps do
		t2[i] = i
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.9, 0, 0.12, 0),
		Position = UDim2.new(0, 0, 0, 0),
		LayoutOrder = layoutOrder
	}, React.createElement("UIListLayout", {
		Padding = UDim.new(0, 10),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder
	}), (LuauPolyfill.Array.map(t2, function(_, p2) -- line: 37
		-- upvalues: React (copy), numberActivated (copy), numberOfSteps (copy)
		return React.createElement("Frame", {
			LayoutOrder = p2,
			BackgroundTransparency = not (p2 <= numberActivated) and 0.7 or 0,
			Size = UDim2.new(1 / numberOfSteps, 0, 0.5, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		}, { React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}) })
	end)))
end

return Stepper
