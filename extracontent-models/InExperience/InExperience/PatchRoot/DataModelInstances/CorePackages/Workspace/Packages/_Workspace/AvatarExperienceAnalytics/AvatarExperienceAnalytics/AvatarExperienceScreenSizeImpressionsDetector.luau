local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local t = require(parent.t)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local AppShortcutBarStore = require(parent.AppShortcutBarStore)
local GetShortcutBarStatusStore = AppShortcutBarStore.GetShortcutBarStatusStore
local SharedFlags = require(parent.SharedFlags)

local FFlagUnifyShortcutBarFixImpressions = SharedFlags.FFlagUnifyShortcutBarFixImpressions

local AvatarExperienceImpressionsDetector = require(script.Parent.AvatarExperienceImpressionsDetector)

local extended = Roact.PureComponent:extend("AvatarExperienceScreenSizeImpressionsDetector")

local strictInterface = t.strictInterface
local v = {
	parentRef = t.table,
	onRequestImpressionsSignal = t.table,
	appPage = t.optional(t.string),
	pageFilter = t.optional(t.callback),
	collectObjectsFunc = t.optional(t.callback),
	filterImpressionFunc = t.optional(t.callback),
	onImpressionsDetected = t.callback,
	screenSize = t.Vector2,
	globalGuiInset = t.table,
	topBarHeight = t.number,
	shortcutBarHeight = 0
}
local shortcutBarHeight2

if FFlagUnifyShortcutBarFixImpressions then
	shortcutBarHeight2 = t.optional(t.number)
end

v.shortcutBarHeight = shortcutBarHeight2
extended.validateProps = strictInterface(v)

function extended.render(p)
	local screenSize = p.props.screenSize
	local topBarHeight = p.props.topBarHeight
	local globalGuiInset = p.props.globalGuiInset
	local shortcutBarHeight = FFlagUnifyShortcutBarFixImpressions and p.props.shortcutBarHeight or 0

	return Roact.createElement(AvatarExperienceImpressionsDetector, {
		parentRef = p.props.parentRef,
		onRequestImpressionsSignal = p.props.onRequestImpressionsSignal,
		viewPortBounds = {
			min = Vector2.new(0, topBarHeight),
			max = Vector2.new(screenSize.X, screenSize.Y - globalGuiInset.bottom - shortcutBarHeight)
		},
		appPage = p.props.appPage,
		pageFilter = p.props.pageFilter,
		collectObjectsFunc = p.props.collectObjectsFunc,
		filterImpressionFunc = p.props.filterImpressionFunc,
		onImpressionsDetected = p.props.onImpressionsDetected
	})
end

local v2 = RoactRodux.connect(function(data, _)
	return {
		topBarHeight = data.TopBar.topBarHeight,
		globalGuiInset = data.GlobalGuiInset,
		screenSize = data.ScreenSize
	}
end)(extended)

if FFlagUnifyShortcutBarFixImpressions then
	return function(p)
		local shortcutBarHeight = SignalsReact.useSignalState(GetShortcutBarStatusStore(false).getShortcutBarReservedHeight)

		return Roact.createElement(v2, Cryo.Dictionary.join(p, {
			shortcutBarHeight = shortcutBarHeight
		}))
	end
end

return v2
