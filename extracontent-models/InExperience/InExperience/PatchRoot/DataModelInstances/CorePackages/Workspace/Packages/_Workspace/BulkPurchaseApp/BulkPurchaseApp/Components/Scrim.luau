local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

return (React.forwardRef(function(p, ref)
	local v = useDesignTokens()
	return React.createElement("Frame", {
		ref = ref,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v.Color.Common.Scrim.Transparency,
		BackgroundColor3 = v.Color.Common.Scrim.Color3,
		ClipsDescendants = false,
		Active = true
	}, p.children)
end))
