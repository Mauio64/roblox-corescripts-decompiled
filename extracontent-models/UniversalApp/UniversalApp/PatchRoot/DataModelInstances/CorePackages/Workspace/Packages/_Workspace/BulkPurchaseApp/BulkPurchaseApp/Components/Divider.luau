local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(Parent.Style).useDesignTokens

local function Divider(t1: {[any]: any}) -- line: 12
	-- upvalues: useDesignTokens (copy), React (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local v7 = useDesignTokens()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v7.Semantic.Color.Common.Divider else v7.Color.Stroke.Emphasis)).Color3,
		BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v7.Semantic.Color.Common.Divider else v7.Color.Stroke.Emphasis)).Transparency,
		LayoutOrder = t1.LayoutOrder,
		[React.Tag] = "data-testid=BulkPurchaseApp_Divider"
	})
end

return Divider
