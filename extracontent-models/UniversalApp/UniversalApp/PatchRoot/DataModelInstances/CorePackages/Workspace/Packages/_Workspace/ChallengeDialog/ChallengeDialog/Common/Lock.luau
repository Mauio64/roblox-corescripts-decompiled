local Parent = script:FindFirstAncestor("ChallengeDialog").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v8 = Images["icons/graphic/lock_xxlarge"]
local v9 = getIconSizeUDim2(IconSize.XLarge)

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), ImageSetLabel (copy), v8 (copy), v9 (copy)
	local layoutOrder = t1.layoutOrder

	return React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = v8,
		LayoutOrder = layoutOrder or nil,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = v9
	})
end
