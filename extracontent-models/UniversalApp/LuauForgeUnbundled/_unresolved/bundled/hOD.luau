local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

return function(p2)
	local v5 = useDesignTokens()
	return React.createElement(iconButton, {
		size = UDim2.new(0, v5.Size.Size_600, 0, v5.Size.Size_600),
		position = UDim2.new(0, v5.Size.Size_200, 0.5, 0),
		anchorPoint = Vector2.new(0, 0.5),
		icon = images["icons/navigation/close"],
		onActivated = p2.navigateBack
	})
end
