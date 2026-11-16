local parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(parent.Roact)

local extended = Roact.PureComponent:extend("AppCarousel")

function extended.render(p)
	local carouselHeight = p.props.carouselHeight
	local canvasWidth = p.props.canvasWidth
	local items = p.props.items
	local onChangeCanvasPosition = p.props.onChangeCanvasPosition
	local onRefCallback = p.props.onRefCallback

	local canvasPosition = p.props.canvasPosition
	local scrollingEnabled = not p.props.scrollingAnimationActive
	local shouldExpandToFitContentHeight = p.props.shouldExpandToFitContentHeight

	local createElement = Roact.createElement
	local v = {}
	v.Size = UDim2.new(1, 0, 0, carouselHeight)
	local automaticSize

	if shouldExpandToFitContentHeight then
		automaticSize = Enum.AutomaticSize.Y
	end

	v.AutomaticSize = automaticSize
	v.ScrollBarThickness = 0
	v.BackgroundTransparency = 1
	v.ClipsDescendants = false
	v.CanvasSize = UDim2.new(0, canvasWidth, 0, carouselHeight)
	local automaticCanvasSize

	if shouldExpandToFitContentHeight then
		automaticCanvasSize = Enum.AutomaticSize.Y
	end

	v.AutomaticCanvasSize = automaticCanvasSize
	v.CanvasPosition = canvasPosition
	v.ScrollingEnabled = scrollingEnabled
	v.ScrollingDirection = Enum.ScrollingDirection.X
	v.ElasticBehavior = Enum.ElasticBehavior.Always
	v.Selectable = false
	v[Roact.Change.CanvasPosition] = onChangeCanvasPosition
	v[Roact.Ref] = onRefCallback
	return createElement("ScrollingFrame", v, items)
end

return extended
