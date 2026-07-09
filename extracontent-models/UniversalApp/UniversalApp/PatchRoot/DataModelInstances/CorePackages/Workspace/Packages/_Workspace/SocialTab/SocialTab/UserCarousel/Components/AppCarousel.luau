local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local t = dependencies.t
local v5 = Roact.PureComponent:extend("AppCarousel")
local isSocialTabAutoSizedCarouselAndTileEnabled2 = require(SocialTab.Flags.isSocialTabAutoSizedCarouselAndTileEnabled2)

v5.defaultProps = {
	carouselHeight = 100,
	canvasWidth = 100,
	onRefCallback = nil,
	items = {},
	onChangeCanvasPosition = function() -- line: 16
	end
}
v5.validateProps = t.interface({
	carouselHeight = t.optional(t.number),
	canvasWidth = t.optional(t.number),
	items = t.optional(t.table),
	onChangeCanvasPosition = t.optional(t.callback)
})

function v5.render(p1) -- line: 27
	-- upvalues: Roact (copy), isSocialTabAutoSizedCarouselAndTileEnabled2 (copy)
	local v8 = p1.props.onRefCallback or Roact.createRef()

	return Roact.createElement("ScrollingFrame", {
		AutomaticSize = isSocialTabAutoSizedCarouselAndTileEnabled2() and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
		Size = UDim2.new(1, 0, 0, p1.props.carouselHeight),
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		CanvasSize = UDim2.new(0, p1.props.canvasWidth, 0, p1.props.carouselHeight),
		ScrollingDirection = Enum.ScrollingDirection.X,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		[Roact.Change.CanvasPosition] = p1.props.onChangeCanvasPosition,
		[Roact.Ref] = v8
	}, p1.props.items)
end

return v5
