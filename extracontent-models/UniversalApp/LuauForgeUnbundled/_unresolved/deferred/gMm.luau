local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local skeleton = Foundation.Skeleton

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

return function()
	local v5 = useDesignTokens()

	local children = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Size.Size_800),
			PaddingBottom = UDim.new(0, v5.Size.Size_600)
		})
	}

	for i = 1, 6 do
		children[#children + 1] = React.createElement(skeleton, {
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.new(0, 0, 0, (i - 1) * 45)
		})
	end

	return React.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
		children
	)
end
