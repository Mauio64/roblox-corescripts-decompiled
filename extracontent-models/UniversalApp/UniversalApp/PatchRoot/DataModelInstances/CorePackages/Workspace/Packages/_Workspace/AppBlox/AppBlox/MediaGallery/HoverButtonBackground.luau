local Parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local withStyle = UIBlox.Core.Style.withStyle
local t = require(Parent.t)
local v8 = Roact.PureComponent:extend("HoverButtonBackground")

v8.validateProps = t.strictInterface({
	sidePadding = t.optional(t.number),
	image = t.optional(validateImage),
	sliceCenter = t.optional(t.Rect)
})

function v8.render(p1) -- line: 31
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy)
	local v10 = if not p1.props.sidePadding then UDim2.new() else UDim2.new(p1.props.sidePadding, UDim.new()) + UDim2.new(p1.props.sidePadding, UDim.new())

	return withStyle(function(p2) -- line: 36
		-- upvalues: Roact (copy), ImageSetLabel (copy), v10 (copy), p1 (copy)
		local BackgroundOnHover = p2.Theme.BackgroundOnHover

		return Roact.createElement(ImageSetLabel, {
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
