local parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(parent.Roact)

local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local withStyle = UIBlox.Core.Style.withStyle

local t = require(parent.t)

local extended = Roact.PureComponent:extend("HoverButtonBackground")

extended.validateProps = t.strictInterface({
	sidePadding = t.optional(t.number),
	image = t.optional(validateImage),
	sliceCenter = t.optional(t.Rect)
})

function extended.render(p)
	local v

	if p.props.sidePadding then
		v = UDim2.new(p.props.sidePadding, UDim.new()) + UDim2.new(p.props.sidePadding, UDim.new())
	else
		v = UDim2.new()
	end

	return withStyle(function(p2)
		local backgroundOnHover = p2.Theme.BackgroundOnHover

		local createElement = Roact.createElement
		local v2 = {
			Size = UDim2.fromScale(1, 1) + v,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = 0,
			BackgroundTransparency = 0,
			Image = 0,
			ImageColor3 = 0,
			ImageTransparency = 0,
			ScaleType = 0,
			SliceCenter = 0
		}
		local backgroundColor

		if not p.props.image then
			backgroundColor = backgroundOnHover.Color
		end

		v2.BackgroundColor3 = backgroundColor
		v2.BackgroundTransparency = p.props.image and 1 or backgroundOnHover.Transparency
		v2.Image = p.props.image
		v2.ImageColor3 = backgroundOnHover.Color
		v2.ImageTransparency = backgroundOnHover.Transparency
		v2.ScaleType = Enum.ScaleType.Slice
		v2.SliceCenter = p.props.sliceCenter
		local corner

		if not p.props.image then
			corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
		end

		return createElement(ImageSetLabel, v2, { corner = corner })
	end)
end

return extended
