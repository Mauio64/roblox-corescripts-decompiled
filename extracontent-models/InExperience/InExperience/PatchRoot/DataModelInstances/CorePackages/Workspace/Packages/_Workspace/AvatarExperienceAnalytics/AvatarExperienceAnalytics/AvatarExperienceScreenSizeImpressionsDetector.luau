local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local Roact = require(Parent.Roact)
local RoactRodux = require(Parent.RoactRodux)
local t = require(Parent.t)
local AvatarExperienceImpressionsDetector = require(script.Parent.AvatarExperienceImpressionsDetector)
local v6 = Roact.PureComponent:extend("AvatarExperienceScreenSizeImpressionsDetector")

v6.validateProps = t.strictInterface({
	parentRef = t.table,
	onRequestImpressionsSignal = t.table,
	appPage = t.optional(t.string),
	pageFilter = t.optional(t.callback),
	collectObjectsFunc = t.optional(t.callback),
	filterImpressionFunc = t.optional(t.callback),
	onImpressionsDetected = t.callback,
	screenSize = t.Vector2,
	globalGuiInset = t.table,
	topBarHeight = t.number
})

function v6.render(p1) -- line: 28
	-- upvalues: Roact (copy), AvatarExperienceImpressionsDetector (copy)
	local screenSize = p1.props.screenSize
	local topBarHeight = p1.props.topBarHeight
	local globalGuiInset = p1.props.globalGuiInset

	return Roact.createElement(AvatarExperienceImpressionsDetector, {
		parentRef = p1.props.parentRef,
		onRequestImpressionsSignal = p1.props.onRequestImpressionsSignal,
		viewPortBounds = {
			min = Vector2.new(0, topBarHeight),
			max = Vector2.new(screenSize.X, screenSize.Y - globalGuiInset.bottom)
		},
		appPage = p1.props.appPage,
		pageFilter = p1.props.pageFilter,
		collectObjectsFunc = p1.props.collectObjectsFunc,
		filterImpressionFunc = p1.props.filterImpressionFunc,
		onImpressionsDetected = p1.props.onImpressionsDetected
	})
end

return (RoactRodux.connect(function(p2, _) -- line: 48
	return {
		topBarHeight = p2.TopBar.topBarHeight,
		globalGuiInset = p2.GlobalGuiInset,
		screenSize = p2.ScreenSize
	}
end)(v6))
