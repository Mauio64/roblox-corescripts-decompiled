local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.PureComponent:extend("IconButton")

function extended.render(p)
	local visible = p.props.visible
	local anchorPoint = p.props.anchorPoint
	local position = p.props.position
	local size = p.props.size
	local zIndex = p.props.zIndex
	local onClick = p.props.onClick

	local iconHorizontalAlignment = p.props.iconHorizontalAlignment or Enum.HorizontalAlignment.Center
	local iconVerticalAlignment = p.props.iconVerticalAlignment or Enum.VerticalAlignment.Center
	local iconSpritePath = p.props.iconSpritePath
	local iconSpriteFrame = p.props.iconSpriteFrame

	local v = p.props.horizontalInset or 12
	local layoutOrder = 0
	local layoutOrder2 = 1

	if iconHorizontalAlignment == Enum.HorizontalAlignment.Center then
		v = 0
	elseif iconHorizontalAlignment == Enum.HorizontalAlignment.Left then
		position = UDim2.new(position.X.Scale, position.X.Offset - v, position.Y.Scale, position.Y.Offset)
	elseif iconHorizontalAlignment == Enum.HorizontalAlignment.Right then
		position = UDim2.new(position.X.Scale, position.X.Offset + v, position.Y.Scale, position.Y.Offset)
		layoutOrder = 1
		layoutOrder2 = 0
	end

	local udim = UDim2.new(size.X.Scale, size.X.Offset + v, size.Y.Scale, size.Y.Offset)

	return Roact.createElement("ImageButton", {
		Visible = visible,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = anchorPoint,
		Position = position,
		Size = udim,
		ZIndex = zIndex,
		[Roact.Event.Activated] = onClick
	}, {
		IconLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = iconHorizontalAlignment,
			VerticalAlignment = iconVerticalAlignment,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Offset = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(0, v, 0, 0)
		}),
		BackIcon = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, iconSpriteFrame.size.X, 0, iconSpriteFrame.size.Y),
			Image = iconSpritePath,
			ImageRectOffset = iconSpriteFrame.offset,
			ImageRectSize = iconSpriteFrame.size,
			ZIndex = zIndex,
			LayoutOrder = layoutOrder2
		})
	})
end

return extended
