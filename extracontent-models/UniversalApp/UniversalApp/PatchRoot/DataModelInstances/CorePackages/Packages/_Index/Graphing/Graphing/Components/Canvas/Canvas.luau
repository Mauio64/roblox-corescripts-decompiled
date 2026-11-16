local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

local CanvasContext = require(Graphing.CanvasContext)
local CanvasUtil = require(Graphing.Util.CanvasUtil)
local StyleUtil = require(Graphing.Util.StyleUtil)
require(Graphing.Types)

local rect = Rect.new(0, 0, 1, 1)

function Canvas(props, p)
	local ref = React.useRef(nil)
	local position

	if props.Position then
		position = props.Position
	else
		position = UDim2.fromOffset(0, 0)
	end

	local size

	if props.Size then
		size = props.Size
	else
		size = UDim2.fromScale(1, 1)
	end

	local v

	if props.ViewportPaddingLeft then
		v = props.ViewportPaddingLeft
	else
		v = UDim.new(0, 25)
	end

	local v2

	if props.ViewportPaddingRight then
		v2 = props.ViewportPaddingRight
	else
		v2 = UDim.new(0, 25)
	end

	local v3

	if props.ViewportPaddingTop then
		v3 = props.ViewportPaddingTop
	else
		v3 = UDim.new(0, 25)
	end

	local v4

	if props.ViewportPaddingBottom then
		v4 = props.ViewportPaddingBottom
	else
		v4 = UDim.new(0, 25)
	end

	local udim = UDim2.new(v, v3)
	local udim2 = UDim2.new(v2, v4)

	local ref2 = React.useRef(nil)

	if ref2.current == nil then
		local graphRect = props.GraphRect or rect
		local v5

		if props.ViewportRect then
			v5 = props.ViewportRect
		else
			v5 = graphRect
		end

		local stableContext, update = CanvasUtil.createStableContext(
			ref,
			graphRect,
			v5,
			props.XAxisScaling,
			props.YAxisScaling,
			props.CullingEpsilon
		)

		ref2.current = { context = stableContext, update = update }
	end

	local current = ref2.current
	local context = current.context
	local update = current.update

	local ref3 = React.useRef({
		graphRect = props.GraphRect or rect,
		viewportRect = props.ViewportRect or props.GraphRect or rect,
		xAxisScaling = props.XAxisScaling,
		yAxisScaling = props.YAxisScaling,
		cullingEpsilon = props.CullingEpsilon
	})

	React.useImperativeHandle(p, function()
		return {
			setViewportRect = function(viewportRect: Rect)
				local current2 = ref3.current
				current2.viewportRect = viewportRect
				update(
					current2.graphRect,
					viewportRect,
					current2.xAxisScaling,
					current2.yAxisScaling,
					current2.cullingEpsilon
				)
			end,
			setGraphRect = function(graphRect: Rect)
				local current2 = ref3.current
				current2.graphRect = graphRect
				update(
					graphRect,
					current2.viewportRect,
					current2.xAxisScaling,
					current2.yAxisScaling,
					current2.cullingEpsilon
				)
			end,
			update = function(graphRect: Rect, viewportRect: Rect, xAxisScaling, yAxisScaling, cullingEpsilon: number?)
				local current2 = ref3.current
				current2.graphRect = graphRect
				current2.viewportRect = viewportRect
				current2.xAxisScaling = xAxisScaling
				current2.yAxisScaling = yAxisScaling
				current2.cullingEpsilon = cullingEpsilon
				update(graphRect, viewportRect, xAxisScaling, yAxisScaling, cullingEpsilon)
			end
		}
	end, {})

	React.useLayoutEffect(function()
		if props.GraphRect then
			local graphRect = props.GraphRect
			local viewportRect

			if props.ViewportRect then
				viewportRect = props.ViewportRect
			else
				viewportRect = graphRect
			end

			ref3.current.graphRect = graphRect
			ref3.current.viewportRect = viewportRect
			ref3.current.xAxisScaling = props.XAxisScaling
			ref3.current.yAxisScaling = props.YAxisScaling
			ref3.current.cullingEpsilon = props.CullingEpsilon
			update(graphRect, viewportRect, props.XAxisScaling, props.YAxisScaling, props.CullingEpsilon)
		end
	end, {
		props.GraphRect,
		props.ViewportRect,
		props.XAxisScaling,
		props.YAxisScaling,
		props.CullingEpsilon
	})

	return React.createElement(CanvasContext.Provider, { value = context }, {
		MainPanel = React.createElement("Frame", {
			Position = position,
			Size = size,
			LayoutOrder = props.LayoutOrder,
			ZIndex = props.ZIndex,
			BackgroundColor3 = props.CanvasBackgroundColor3 or StyleUtil.CANVAS_BACKGROUND_COLOR3,
			BackgroundTransparency = props.CanvasBackgroundTransparency or StyleUtil.CANVAS_BACKGROUND_TRANSPARENCY,
			BorderSizePixel = 0
		}, Dash.join({
			Viewport = React.createElement("CanvasGroup", {
				Position = udim,
				Size = UDim2.fromScale(1, 1) - (udim + udim2),
				ref = ref,
				BackgroundColor3 = props.ViewportBackgroundColor3 or StyleUtil.VIEWPORT_BACKGROUND_COLOR3,
				BackgroundTransparency = props.ViewportBackgroundTransparency or StyleUtil.VIEWPORT_BACKGROUND_TRANSPARENCY,
				BorderSizePixel = 0,
				ZIndex = 1
			}, props.children),
			ViewportUnclipped = React.createElement("Frame", {
				Position = udim,
				Size = UDim2.fromScale(1, 1) - (udim + udim2),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2
			}, props.childrenUnclipped)
		}))
	})
end

return React.forwardRef(Canvas)
