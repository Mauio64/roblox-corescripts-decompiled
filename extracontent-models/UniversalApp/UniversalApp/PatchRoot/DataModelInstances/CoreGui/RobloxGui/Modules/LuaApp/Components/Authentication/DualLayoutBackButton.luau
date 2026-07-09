local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: useDesignTokens (copy), React (copy), IconButton (copy), Images (copy)
	local v8 = useDesignTokens()

	return React.createElement(IconButton, {
		size = UDim2.new(0, v8.Size.Size_600, 0, v8.Size.Size_600),
		position = UDim2.new(0, v8.Size.Size_200, 0.5, 0),
		anchorPoint = Vector2.new(0, 0.5),
		icon = Images["icons/navigation/close"],
		onActivated = t1.navigateBack
	})
end
