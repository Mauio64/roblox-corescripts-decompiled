local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local function Divider(p)
	local v = useDesignTokens()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = v.Color.Stroke.Emphasis.Color3,
		BackgroundTransparency = v.Color.Stroke.Emphasis.Transparency,
		LayoutOrder = p.LayoutOrder,
		[React.Tag] = "data-testid=BulkPurchaseApp_Divider"
	})
end

return Divider
