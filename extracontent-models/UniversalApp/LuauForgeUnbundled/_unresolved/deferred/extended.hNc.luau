local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconsgraphiclock_xxlarge = images["icons/graphic/lock_xxlarge"]
local iconSizeUDim2 = getIconSizeUDim2(iconSize.XLarge)

local extended = Roact.PureComponent:extend("Lock")

function extended.render(p2)
	local layoutOrder = p2.props.layoutOrder

	return Roact.createElement(imageSetLabel, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = iconsgraphiclock_xxlarge,
		LayoutOrder = layoutOrder or nil,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = iconSizeUDim2
	})
end

return extended
