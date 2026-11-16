local parent = script:FindFirstAncestor("Impressions").Parent

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local t = require(parent.t)
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local AppShortcutBarStore = require(parent.AppShortcutBarStore)
local GetShortcutBarStatusStore = AppShortcutBarStore.GetShortcutBarStatusStore
local SharedFlags = require(parent.SharedFlags)

local FFlagUnifyShortcutBarFixImpressions = SharedFlags.FFlagUnifyShortcutBarFixImpressions

local ImpressionsDetector = require(script.Parent.ImpressionsDetector)

local extended = Roact.PureComponent:extend("ScreenSizeImpressionsDetector")

local strictInterface = t.strictInterface
local v = {
	impressionsTag = t.string,
	parentRef = t.optional(t.table),
	onRequestImpressionsSignal = t.table,
	filterImpressionFunc = t.optional(t.callback),
	onImpressionsDetected = t.callback,
	skipZeroSizes = t.optional(t.boolean),
	screenSize = t.Vector2,
	globalGuiInset = t.table,
	topBarHeight = t.number,
	shortcutBarHeight = 0
}
local shortcutBarHeight

if FFlagUnifyShortcutBarFixImpressions then
	shortcutBarHeight = t.optional(t.number)
end

v.shortcutBarHeight = shortcutBarHeight
extended.validateProps = strictInterface(v)

local v2 = memoize(function(p, vector2: Vector2, p2, p3: number?)
	return {
		min = Vector2.new(0, p),
		max = Vector2.new(vector2.X, vector2.Y - p2.bottom - (FFlagUnifyShortcutBarFixImpressions and p3 or 0))
	}
end)

function extended.render(p)
	local screenSize = p.props.screenSize
	local topBarHeight = p.props.topBarHeight
	local globalGuiInset = p.props.globalGuiInset

	local createElement = Roact.createElement
	local v3 = {
		parentRef = p.props.parentRef,
		impressionsTag = p.props.impressionsTag,
		onRequestImpressionsSignal = p.props.onRequestImpressionsSignal,
		viewPortBounds = 0,
		filterImpressionFunc = 0,
		onImpressionsDetected = 0,
		skipZeroSizes = 0
	}
	local v4

	if FFlagUnifyShortcutBarFixImpressions then
		v4 = p.props.shortcutBarHeight
	end

	v3.viewPortBounds = v2(topBarHeight, screenSize, globalGuiInset, v4)

	v3.filterImpressionFunc = p.props.filterImpressionFunc
	v3.onImpressionsDetected = p.props.onImpressionsDetected
	v3.skipZeroSizes = p.props.skipZeroSizes
	return createElement(ImpressionsDetector, v3)
end

local v3 = RoactRodux.connect(function(data, _)
	return {
		topBarHeight = data.TopBar.topBarHeight,
		globalGuiInset = data.GlobalGuiInset,
		screenSize = data.ScreenSize
	}
end)(extended)

if FFlagUnifyShortcutBarFixImpressions then
	return function(p)
		local shortcutBarHeight2 = SignalsReact.useSignalState(GetShortcutBarStatusStore(false).getShortcutBarReservedHeight)

		return Roact.createElement(v3, Cryo.Dictionary.join(p, {
			shortcutBarHeight = shortcutBarHeight2
		}))
	end
end

return v3
