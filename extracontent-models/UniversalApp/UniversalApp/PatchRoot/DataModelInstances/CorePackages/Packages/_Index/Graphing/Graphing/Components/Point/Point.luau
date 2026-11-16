local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

require(Graphing.Types)
local Positioner = require(Graphing.Components.Positioner)
local StyleUtil = require(Graphing.Util.StyleUtil)

function Point(props)
	local size = props.Size or StyleUtil.POINT_HANDLE_SIZE
	local outlineThickness = props.OutlineThickness or StyleUtil.POINT_HANDLE_OUTLINE_THICKNESS
	local color3 = props.Color3 or StyleUtil.POINT_HANDLE_COLOR3
	local imageColor = props.OutlineColor3 or StyleUtil.POINT_HANDLE_OUTLINE_COLOR3

	local createElement = React.createElement
	local v = { Position = props.Position, ZIndex = props.ZIndex, ref = props.positionerRef }

	local createElement2 = React.createElement
	local tagsByTag = {}
	tagsByTag.AnchorPoint = Vector2.new(0.5, 0.5)
	tagsByTag.Size = UDim2.fromOffset(size + 2 * outlineThickness, size + 2 * outlineThickness)
	tagsByTag.Image = props.Image or StyleUtil.POINT_HANDLE_IMAGE

	if outlineThickness == 0 then
		imageColor = color3
	end

	tagsByTag.ImageColor3 = imageColor
	tagsByTag.ImageTransparency = props.Transparency
	tagsByTag.BackgroundTransparency = 1
	tagsByTag.ZIndex = 1
	tagsByTag[React.Tag] = props.Tag
	local v2 = {
		Outer = createElement2("ImageButton", tagsByTag, props.children),
		Inner = 0
	}
	local inner

	if outlineThickness > 0 then
		inner = React.createElement("ImageButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(size, size),
			Interactable = false,
			Selectable = false,
			Image = props.Image or StyleUtil.POINT_HANDLE_IMAGE,
			ImageColor3 = color3,
			ImageTransparency = props.Transparency,
			BackgroundTransparency = 1,
			ZIndex = 2,
			[React.Tag] = props.Tag
		})
	else
		inner = false
	end

	v2.Inner = inner
	return createElement(Positioner, v, v2)
end

return Point
