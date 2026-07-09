local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local t1 = {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	heightOffset = 0
}

local function TopBarContentFrame(t2: {[any]: any}) -- line: 20
	-- upvalues: t1 (copy), React (copy)
	local v6 = t2.heightOffset or t1.heightOffset

	return React.createElement("Frame", {
		Position = UDim2.new(0, 0, 0, v6),
		Size = UDim2.new(1, 0, 1, -v6),
		ZIndex = t2.ZIndex,
		BackgroundColor3 = t2.BackgroundColor3,
		BackgroundTransparency = t2.BackgroundTransparency or t1.BackgroundTransparency,
		BorderSizePixel = t2.BorderSizePixel or t1.BorderSizePixel,
		ClipsDescendants = t2.ClipsDescendants
	}, t2.children)
end

return TopBarContentFrame
