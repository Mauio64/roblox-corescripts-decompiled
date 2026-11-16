local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local v5 = { BackgroundTransparency = 1, BorderSizePixel = 0, heightOffset = 0 }

local function TopBarContentFrame(props)
	local heightOffset = props.heightOffset or 0

	return React.createElement("Frame", {
		Position = UDim2.new(0, 0, 0, heightOffset),
		Size = UDim2.new(1, 0, 1, -heightOffset),
		ZIndex = props.ZIndex,
		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency or 1,
		BorderSizePixel = props.BorderSizePixel or 0,
		ClipsDescendants = props.ClipsDescendants
	}, props.children)
end

return TopBarContentFrame
