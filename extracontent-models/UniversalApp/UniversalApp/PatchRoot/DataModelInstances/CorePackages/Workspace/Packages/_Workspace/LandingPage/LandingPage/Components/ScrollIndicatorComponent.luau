local Parent = script:FindFirstAncestor("LandingPage").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), Foundation (copy)
	if t1.totalAvatars == 0 then
		return React.createElement(Foundation.View, {
			tag = "row gap-small align-x-center auto-xy padding-y-small",
			LayoutOrder = t1.LayoutOrder or 0
		})
	end

	local t2 = {}

	for i = 1, t1.totalAvatars do
		t2[i] = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, 8, 0, 8),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Transparency = i ~= t1.highlightedIndex and 0.6 or 0
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		})
	end

	return React.createElement(Foundation.View, {
		tag = "row gap-small align-x-center size-full-0 padding-bottom-large",
		LayoutOrder = t1.LayoutOrder or 0
	}, t2)
end
