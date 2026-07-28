local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 10
	-- upvalues: useDesignTokens (copy), React (copy)
	local v6 = useDesignTokens()

	return React.createElement("Frame", {
		ClipsDescendants = false,
		Active = true,
		ref = p1,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v6.Color.Common.Scrim.Transparency,
		BackgroundColor3 = v6.Color.Common.Scrim.Color3
	}, t1.children)
end))
