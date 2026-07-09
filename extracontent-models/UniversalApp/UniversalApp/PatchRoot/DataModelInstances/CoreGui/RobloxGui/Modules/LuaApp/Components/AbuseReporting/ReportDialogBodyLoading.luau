local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

return function() -- line: 9
	-- upvalues: useDesignTokens (copy), React (copy), Skeleton (copy)
	local v5 = useDesignTokens()
	local t1 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Size.Size_800),
			PaddingBottom = UDim.new(0, v5.Size.Size_600)
		})
	}

	for i = 1, 6 do
		t1[#t1 + 1] = React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.new(0, 0, 0, (i - 1) * 45)
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, t1)
end
