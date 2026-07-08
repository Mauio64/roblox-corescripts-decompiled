local Parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(Parent.Roact)
local v3 = Roact.PureComponent:extend("AppCarousel")

function v3.render(p1) -- line: 9
	-- upvalues: Roact (copy)
	local carouselHeight = p1.props.carouselHeight
	local canvasWidth = p1.props.canvasWidth
	local items = p1.props.items
	local onChangeCanvasPosition = p1.props.onChangeCanvasPosition
	local onRefCallback = p1.props.onRefCallback
	local canvasPosition = p1.props.canvasPosition
	local scrollingAnimationActive = p1.props.scrollingAnimationActive
	local shouldExpandToFitContentHeight = p1.props.shouldExpandToFitContentHeight

	return Roact.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, carouselHeight),
		AutomaticSize = if not shouldExpandToFitContentHeight then nil else Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		CanvasSize = UDim2.new(0, canvasWidth, 0, carouselHeight),
		AutomaticCanvasSize = if not shouldExpandToFitContentHeight then nil else Enum.AutomaticSize.Y,
		CanvasPosition = canvasPosition,
		ScrollingEnabled = not scrollingAnimationActive,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		Selectable = false,
		[Roact.Change.CanvasPosition] = onChangeCanvasPosition,
		[Roact.Ref] = onRefCallback
	}, items)
end

return v3
