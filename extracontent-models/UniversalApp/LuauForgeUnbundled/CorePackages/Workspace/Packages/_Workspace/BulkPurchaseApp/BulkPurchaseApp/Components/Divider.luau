local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/Style").useDesignTokens

local function Divider(p2)
	local v5 = useDesignTokens()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = v5.Color.Stroke.Emphasis.Color3,
		BackgroundTransparency = v5.Color.Stroke.Emphasis.Transparency,
		LayoutOrder = p2.layoutOrder,
		[React.Tag] = "data-testid=AvatarExperienceSearch_Divider"
	})
end

return Divider
