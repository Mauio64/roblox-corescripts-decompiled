local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens

local function Divider(t1: {[any]: any}) -- line: 10
	-- upvalues: useDesignTokens (copy), React (copy)
	local v6 = useDesignTokens()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = v6.Color.Stroke.Emphasis.Color3,
		BackgroundTransparency = v6.Color.Stroke.Emphasis.Transparency,
		LayoutOrder = t1.LayoutOrder,
		[React.Tag] = "data-testid=BulkPurchaseApp_Divider"
	})
end

return Divider
