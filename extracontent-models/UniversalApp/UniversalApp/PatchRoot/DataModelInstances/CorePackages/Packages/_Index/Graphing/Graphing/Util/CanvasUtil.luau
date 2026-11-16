local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local Signals = require(parent.Signals)
local MathUtil = require(Graphing.Util.MathUtil)
local Types = require(Graphing.Types)

local CanvasUtil = {}

local signal = Signals.createSignal(Rect.new(0, 0, 1, 1))

local v = { current = nil }

CanvasUtil.DEFAULT_XSCALING = { Type = Types.SCALING_LINEAR, Direction = Types.DIRECTION_FORWARD }

CanvasUtil.DEFAULT_YSCALING = { Type = Types.SCALING_LINEAR, Direction = Types.DIRECTION_REVERSED }

function CanvasUtil.createFunctions(graphRect: Rect, viewportRect: Rect, p, p2, p3, value: number?)
	local xAxisScaling = p2 or CanvasUtil.DEFAULT_XSCALING
	local yAxisScaling = p3 or CanvasUtil.DEFAULT_YSCALING
	assert(xAxisScaling, "xAxisScaling was nil")
	assert(yAxisScaling, "yAxisScaling was nil")

	local v2 = value or 0.0001
	assert(v2, "defaultEpsilon was nil")

	local function scaled(p4: number, data)
		if data.Type == Types.SCALING_LINEAR then
			return p4
		end

		if data.Type == Types.SCALING_POWER then
			local power = data.Power
			return MathUtil.signedPow(p4, power)
		end

		if data.Type == Types.SCALING_LOGARITHMIC then
			local base = data.Base
			return MathUtil.log(base, p4)
		end

		assert(false, `Scaling type {data} not supported`)
		return p4
	end

	local function unscaled(lerped: number, data) -- 2 equivalent calls inferred from this helper
		if data.Type == Types.SCALING_LINEAR then
			return lerped
		end

		if data.Type == Types.SCALING_POWER then
			local power = data.Power
			return MathUtil.signedPow(lerped, 1 / power)
		end

		if data.Type == Types.SCALING_LOGARITHMIC then
			return (math.pow(data.Base, lerped))
		end

		assert(false, `Scaling type {data} not supported`)
		return lerped
	end

	local rect = Rect.new(
		scaled(graphRect.Min.X, xAxisScaling),
		scaled(graphRect.Min.Y, yAxisScaling),
		scaled(graphRect.Max.X, xAxisScaling),
		scaled(graphRect.Max.Y, yAxisScaling)
	)

	local rect2 = Rect.new(
		scaled(viewportRect.Min.X, xAxisScaling),
		scaled(viewportRect.Min.Y, yAxisScaling),
		scaled(viewportRect.Max.X, xAxisScaling),
		scaled(viewportRect.Max.Y, yAxisScaling)
	)

	local function plotToGraphX(x: number) -- 1 equivalent call inferred from this helper
		local inverseLerp = MathUtil.inverseLerp(rect.Min.X, rect.Max.X, scaled(x, xAxisScaling))

		if xAxisScaling.Direction == Types.DIRECTION_REVERSED then
			inverseLerp = 1 - inverseLerp
		end

		return inverseLerp
	end

	local function plotToGraphY(y: number) -- 1 equivalent call inferred from this helper
		local inverseLerp = MathUtil.inverseLerp(rect.Min.Y, rect.Max.Y, scaled(y, yAxisScaling))

		if yAxisScaling.Direction ~= Types.DIRECTION_FORWARD then
			inverseLerp = 1 - inverseLerp
		end

		return inverseLerp
	end

	local function graphToPlotY(y: number)
		if yAxisScaling.Direction ~= Types.DIRECTION_FORWARD then
			y = 1 - y
		end

		return unscaled(MathUtil.lerp(rect.Min.Y, rect.Max.Y, y), yAxisScaling)
	end

	local function plotToViewX(x: number) -- 1 equivalent call inferred from this helper
		local inverseLerp = MathUtil.inverseLerp(rect2.Min.X, rect2.Max.X, scaled(x, xAxisScaling))

		if xAxisScaling.Direction == Types.DIRECTION_REVERSED then
			inverseLerp = 1 - inverseLerp
		end

		return inverseLerp
	end

	local function plotToViewY(y: number) -- 1 equivalent call inferred from this helper
		local inverseLerp = MathUtil.inverseLerp(rect2.Min.Y, rect2.Max.Y, scaled(y, yAxisScaling))

		if yAxisScaling.Direction ~= Types.DIRECTION_FORWARD then
			inverseLerp = 1 - inverseLerp
		end

		return inverseLerp
	end

	local function plotToView(vector2: Vector2)
		return Vector2.new(plotToViewX(vector2.X), plotToViewY(vector2.Y)) -- inferred equivalent call
	end

	local function viewToPlotY(y: number)
		if yAxisScaling.Direction ~= Types.DIRECTION_FORWARD then
			y = 1 - y
		end

		return unscaled(MathUtil.lerp(rect2.Min.Y, rect2.Max.Y, y), yAxisScaling)
	end

	local function viewToPlot(vector2: Vector2)
		local x = vector2.X

		if xAxisScaling.Direction == Types.DIRECTION_REVERSED then
			x = 1 - x
		end

		return Vector2.new(unscaled(MathUtil.lerp(rect2.Min.X, rect2.Max.X, x), xAxisScaling), viewToPlotY(vector2.Y)) -- inferred equivalent call
	end

	local function absToView(vector2: Vector2)
		local current = p.current

		if not current then
			return viewportRect.Min
		end

		local absolutePosition = current.AbsolutePosition
		local absoluteSize = current.AbsoluteSize
		local inverseLerp = MathUtil.inverseLerp(absolutePosition.X, absolutePosition.X + absoluteSize.X, vector2.X)
		local inverseLerp2 = MathUtil.inverseLerp(absolutePosition.Y, absolutePosition.Y + absoluteSize.Y, vector2.Y)

		return Vector2.new(inverseLerp, inverseLerp2)
	end

	local function viewToAbs(vector2: Vector2)
		local current = p.current

		if not current then
			return viewportRect.Min
		end

		local absolutePosition = current.AbsolutePosition
		local absoluteSize = current.AbsoluteSize
		local lerped = MathUtil.lerp(absolutePosition.X, absolutePosition.X + absoluteSize.X, vector2.X)
		local lerped2 = MathUtil.lerp(absolutePosition.X, absolutePosition.X + absoluteSize.X, vector2.Y)

		return Vector2.new(lerped, lerped2)
	end

	local function mouseToView(vector3: Vector3)
		return absToView(Vector2.new(vector3.X, vector3.Y))
	end

	local function isPointInViewportX(x: number, p4: number?): boolean -- 1 equivalent call inferred from this helper
		local v3 = p4 or v2
		return viewportRect.Min.X - v3 <= x and x <= viewportRect.Max.X + v3
	end

	local function isPointInViewportY(y: number, p4: number?): boolean -- 1 equivalent call inferred from this helper
		local v3 = p4 or v2
		return viewportRect.Min.Y - v3 <= y and y <= viewportRect.Max.Y + v3
	end

	return {
		getViewport = function()
			return p.current
		end,
		getGraphRect = function()
			return graphRect
		end,
		getViewportRect = function()
			return viewportRect
		end,
		getXAxisScaling = function()
			return xAxisScaling
		end,
		getYAxisScaling = function()
			return yAxisScaling
		end,
		plotToGraph = function(vector2: Vector2)
			return Vector2.new(plotToGraphX(vector2.X), plotToGraphY(vector2.Y)) -- inferred equivalent call
		end,
		plotToGraphX = plotToGraphX,
		plotToGraphY = plotToGraphY,
		graphToPlot = function(vector2: Vector2)
			local x = vector2.X

			if xAxisScaling.Direction == Types.DIRECTION_REVERSED then
				x = 1 - x
			end

			return Vector2.new(
				unscaled(MathUtil.lerp(rect.Min.X, rect.Max.X, x), xAxisScaling), -- inferred equivalent call
				graphToPlotY(vector2.Y)
			)
		end,
		graphToPlotX = function(p4: number)
			if xAxisScaling.Direction == Types.DIRECTION_REVERSED then
				p4 = 1 - p4
			end

			return unscaled(MathUtil.lerp(rect.Min.X, rect.Max.X, p4), xAxisScaling)
		end,
		graphToPlotY = graphToPlotY,
		plotToView = plotToView,
		plotToViewX = plotToViewX,
		plotToViewY = plotToViewY,
		viewToPlot = viewToPlot,
		viewToPlotX = function(p4: number)
			if xAxisScaling.Direction == Types.DIRECTION_REVERSED then
				p4 = 1 - p4
			end

			return unscaled(MathUtil.lerp(rect2.Min.X, rect2.Max.X, p4), xAxisScaling)
		end,
		viewToPlotY = viewToPlotY,
		absToView = absToView,
		viewToAbs = viewToAbs,
		absToPlot = function(vector2: Vector2)
			return viewToPlot(absToView(vector2))
		end,
		plotToAbs = function(vector2: Vector2)
			return viewToAbs(plotToView(vector2))
		end,
		mouseToView = mouseToView,
		mouseToPlot = function(vector3: Vector3)
			return viewToPlot(mouseToView(vector3))
		end,
		isPointInViewport = function(vector2: Vector2, p4: number?)
			return isPointInViewportX(vector2.X, p4) and isPointInViewportY(vector2.Y, p4) -- inferred equivalent call
		end,
		isPointInViewportX = isPointInViewportX,
		isPointInViewportY = isPointInViewportY,
		isRectInViewport = function(rect3: Rect, p4: number?): boolean
			local v3 = p4 or v2
			return rect3.Min.X <= viewportRect.Max.X + v3
				and rect3.Max.X >= viewportRect.Min.X - v3
				and rect3.Min.Y <= viewportRect.Max.Y + v3
				and rect3.Max.Y >= viewportRect.Min.Y - v3
		end,
		viewportRectGetter = signal
	}
end

function CanvasUtil.createStableContext(p, rect: Rect?, rect2: Rect?, p2, p3, p4: number?)
	local v2 = rect or Rect.new(0, 0, 1, 1)
	local v3 = rect2 or v2
	local signal2, v4 = Signals.createSignal(v3)

	local functions = CanvasUtil.createFunctions(v2, v3, p, p2, p3, p4)

	functions.viewportRectGetter = signal2

	local function update(rect3: Rect, rect4: Rect, p5, p6, p7: number?)
		local functions2 = CanvasUtil.createFunctions(rect3, rect4, p, p5, p6, p7)

		for k, v5 in functions2 do
			if k ~= "viewportRectGetter" then
				functions[k] = v5
			end
		end

		v4(rect4)
	end

	return functions, update
end

function CanvasUtil.createDefaultFunctions()
	return CanvasUtil.createFunctions(Rect.new(0, 0, 1, 1), Rect.new(0, 0, 1, 1), v)
end

return CanvasUtil
