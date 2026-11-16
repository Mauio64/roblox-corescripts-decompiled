local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")

local extended = Roact.PureComponent:extend("AppCarousel")

function extended.render(p2)
	local carouselHeight = p2.props.carouselHeight
	local canvasWidth = p2.props.canvasWidth
	local items = p2.props.items
	local onChangeCanvasPosition = p2.props.onChangeCanvasPosition
	local onRefCallback = p2.props.onRefCallback

	local canvasPosition = p2.props.canvasPosition
	local v5 = not p2.props.scrollingAnimationActive
	local shouldExpandToFitContentHeight = p2.props.shouldExpandToFitContentHeight

	local createElement = Roact.createElement
	local v7 = {}
	v7.Size = UDim2.new(1, 0, 0, carouselHeight)
	local v8 = if shouldExpandToFitContentHeight then Enum.AutomaticSize.Y else nil
	v7.AutomaticSize = v8
	v7.ScrollBarThickness = 0
	v7.BackgroundTransparency = 1
	v7.ClipsDescendants = false
	v7.CanvasSize = UDim2.new(0, canvasWidth, 0, carouselHeight)
	local v9 = if shouldExpandToFitContentHeight then Enum.AutomaticSize.Y else nil
	v7.AutomaticCanvasSize = v9
	v7.CanvasPosition = canvasPosition
	v7.ScrollingEnabled = v5
	v7.ScrollingDirection = Enum.ScrollingDirection.X
	v7.ElasticBehavior = Enum.ElasticBehavior.Always
	v7.Selectable = false
	v7[Roact.Change.CanvasPosition] = onChangeCanvasPosition
	v7[Roact.Ref] = onRefCallback
	return createElement("ScrollingFrame", v7, items)
end

return extended
