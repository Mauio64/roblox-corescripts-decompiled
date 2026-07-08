local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local v3 = Roact.PureComponent:extend("IconButton")

function v3.render(p1) -- line: 6
	-- upvalues: Roact (copy)
	local visible = p1.props.visible
	local anchorPoint = p1.props.anchorPoint
	local position = p1.props.position
	local size = p1.props.size
	local zIndex = p1.props.zIndex
	local onClick = p1.props.onClick
	local v11 = p1.props.iconHorizontalAlignment or Enum.HorizontalAlignment.Center
	local v12 = p1.props.iconVerticalAlignment or Enum.VerticalAlignment.Center
	local iconSpritePath = p1.props.iconSpritePath
	local iconSpriteFrame = p1.props.iconSpriteFrame
	local v15 = p1.props.horizontalInset or 12
	local n1 = 0
	local n2 = 1

	if v11 == Enum.HorizontalAlignment.Center then
		v15 = 0
	elseif v11 == Enum.HorizontalAlignment.Left then
		position = UDim2.new(position.X.Scale, position.X.Offset - v15, position.Y.Scale, position.Y.Offset)
	elseif v11 == Enum.HorizontalAlignment.Right then
		position = UDim2.new(position.X.Scale, position.X.Offset + v15, position.Y.Scale, position.Y.Offset)
		n1 = 1
		n2 = 0
	end

	local uDim2 = UDim2.new(size.X.Scale, size.X.Offset + v15, size.Y.Scale, size.Y.Offset)

	return Roact.createElement("ImageButton", {
		Visible = visible,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = anchorPoint,
		Position = position,
		Size = uDim2,
		ZIndex = zIndex,
		[Roact.Event.Activated] = onClick
	}, {
		IconLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = v11,
			VerticalAlignment = v12,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Offset = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = n1,
			Size = UDim2.new(0, v15, 0, 0)
		}),
		BackIcon = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, iconSpriteFrame.size.X, 0, iconSpriteFrame.size.Y),
			Image = iconSpritePath,
			ImageRectOffset = iconSpriteFrame.offset,
			ImageRectSize = iconSpriteFrame.size,
			ZIndex = zIndex,
			LayoutOrder = n2
		})
	})
end

return v3
