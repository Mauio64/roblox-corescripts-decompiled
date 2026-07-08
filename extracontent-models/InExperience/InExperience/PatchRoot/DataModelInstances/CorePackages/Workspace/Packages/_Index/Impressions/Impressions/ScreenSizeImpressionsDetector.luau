local Parent = script:FindFirstAncestor("Impressions").Parent
local Roact = require(Parent.Roact)
local RoactRodux = require(Parent.RoactRodux)
local t = require(Parent.t)
local memoize = require(Parent.AppCommonLib).memoize
local ImpressionsDetector = require(script.Parent.ImpressionsDetector)
local v7 = Roact.PureComponent:extend("ScreenSizeImpressionsDetector")

v7.validateProps = t.strictInterface({
	impressionsTag = t.string,
	parentRef = t.optional(t.table),
	onRequestImpressionsSignal = t.table,
	filterImpressionFunc = t.optional(t.callback),
	onImpressionsDetected = t.callback,
	skipZeroSizes = t.optional(t.boolean),
	screenSize = t.Vector2,
	globalGuiInset = t.table,
	topBarHeight = t.number
})

local v8 = memoize(function(p1, vector2: Vector2, p2) -- line: 26
	return {
		min = Vector2.new(0, p1),
		max = Vector2.new(vector2.X, vector2.Y - p2.bottom)
	}
end)

function v7.render(p3) -- line: 33
	-- upvalues: Roact (copy), ImpressionsDetector (copy), v8 (copy)
	local screenSize = p3.props.screenSize
	local topBarHeight = p3.props.topBarHeight
	local globalGuiInset = p3.props.globalGuiInset

	return Roact.createElement(ImpressionsDetector, {
		parentRef = p3.props.parentRef,
		impressionsTag = p3.props.impressionsTag,
		onRequestImpressionsSignal = p3.props.onRequestImpressionsSignal,
		viewPortBounds = v8(topBarHeight, screenSize, globalGuiInset),
		filterImpressionFunc = p3.props.filterImpressionFunc,
		onImpressionsDetected = p3.props.onImpressionsDetected,
		skipZeroSizes = p3.props.skipZeroSizes
	})
end

return (RoactRodux.connect(function(p4, _) -- line: 49
	return {
		topBarHeight = p4.TopBar.topBarHeight,
		globalGuiInset = p4.GlobalGuiInset,
		screenSize = p4.ScreenSize
	}
end)(v7))
