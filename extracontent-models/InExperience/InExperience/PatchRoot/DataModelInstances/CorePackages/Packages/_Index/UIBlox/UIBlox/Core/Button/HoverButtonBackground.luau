local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local Roact = require(ParentParent2.Roact)
local t = require(ParentParent2.t)
local ImageSetComponent = require(ParentParent.ImageSet.ImageSetComponent)
local validateImage = require(ParentParent.ImageSet.Validator.validateImage)
local withStyle = require(ParentParent.Style.withStyle)
local v8 = Roact.PureComponent:extend("HoverButtonBackground")

v8.validateProps = t.strictInterface({
	sidePadding = t.optional(t.number),
	image = t.optional(validateImage),
	sliceCenter = t.optional(t.Rect)
})

function v8.render(p1) -- line: 32
	-- upvalues: withStyle (copy), Roact (copy), ImageSetComponent (copy)
	local v10 = if not p1.props.sidePadding then UDim2.new() else UDim2.new(p1.props.sidePadding, UDim.new()) + UDim2.new(p1.props.sidePadding, UDim.new())

	return withStyle(function(p2) -- line: 37
		-- upvalues: Roact (copy), ImageSetComponent (copy), v10 (copy), p1 (copy)
		local BackgroundOnHover = p2.Theme.BackgroundOnHover

		return Roact.createElement(ImageSetComponent.Label, {
			Size = UDim2.fromScale(1, 1) + v10,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = if not p1.props.image then BackgroundOnHover.Color else nil,
			BackgroundTransparency = if not p1.props.image then BackgroundOnHover.Transparency else 1,
			Image = p1.props.image,
			ImageColor3 = BackgroundOnHover.Color,
			ImageTransparency = BackgroundOnHover.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = p1.props.sliceCenter
		}, {
			corner = if not p1.props.image then Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}) else nil
		})
	end)
end

return v8
