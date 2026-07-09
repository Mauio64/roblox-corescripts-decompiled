local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v8 = Images["icons/graphic/lock_xxlarge"]
local v9 = getIconSizeUDim2(IconSize.XLarge)
local v10 = Roact.PureComponent:extend(script.Name)

function v10.render(p1) -- line: 16
	-- upvalues: Roact (copy), ImageSetLabel (copy), v8 (copy), v9 (copy)
	local layoutOrder = p1.props.layoutOrder

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = v8,
		LayoutOrder = layoutOrder or nil,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = v9
	})
end

return v10
