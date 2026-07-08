local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(Parent.Style).useDesignTokens

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 12
	-- upvalues: useDesignTokens (copy), React (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local v7 = useDesignTokens()

	return React.createElement("Frame", {
		ClipsDescendants = false,
		Active = true,
		ref = p1,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v7.Semantic.Color.Common.Overlay else v7.Color.Common.Scrim)).Transparency,
		BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v7.Semantic.Color.Common.Overlay else v7.Color.Common.Scrim)).Color3
	}, t1.children)
end))
