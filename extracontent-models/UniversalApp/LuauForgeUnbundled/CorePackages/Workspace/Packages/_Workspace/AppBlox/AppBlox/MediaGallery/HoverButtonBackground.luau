local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local withStyle = UIBlox.Core.Style.withStyle

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")

local extended = Roact.PureComponent:extend("HoverButtonBackground")

extended.validateProps = t.strictInterface({
	sidePadding = t.optional(t.number),
	image = t.optional(validateImage),
	sliceCenter = t.optional(t.Rect)
})

function extended.render(p2)
	local v5

	if p2.props.sidePadding then
		v5 = UDim2.new(p2.props.sidePadding, UDim.new()) + UDim2.new(p2.props.sidePadding, UDim.new())
	else
		v5 = UDim2.new()
	end

	return withStyle(function(p3)
		local backgroundOnHover = p3.Theme.BackgroundOnHover

		local createElement = Roact.createElement
		local v7 = {
			Size = UDim2.fromScale(1, 1) + v5,
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
		local v8 = if not p2.props.image then backgroundOnHover.Color else nil
		v7.BackgroundColor3 = v8
		v7.BackgroundTransparency = p2.props.image and 1 or backgroundOnHover.Transparency
		v7.Image = p2.props.image
		v7.ImageColor3 = backgroundOnHover.Color
		v7.ImageTransparency = backgroundOnHover.Transparency
		v7.ScaleType = Enum.ScaleType.Slice
		v7.SliceCenter = p2.props.sliceCenter

		local v10 = if not p2.props.image then Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}) else nil
		return createElement(imageSetLabel, v7, { corner = v10 })
	end)
end

return extended
