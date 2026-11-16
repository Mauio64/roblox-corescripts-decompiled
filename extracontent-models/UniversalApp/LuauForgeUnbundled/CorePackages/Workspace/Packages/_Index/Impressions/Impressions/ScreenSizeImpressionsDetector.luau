local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/RoactRodux")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/t")
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/AppCommonLib").memoize
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Cryo")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SignalsReact")
local getShortcutBarStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/AppShortcutBarStore").GetShortcutBarStatusStore
local fFlagUnifyShortcutBarFixImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SharedFlags").FFlagUnifyShortcutBarFixImpressions

local ImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsDetector")

local extended = Roact.PureComponent:extend("ScreenSizeImpressionsDetector")

local strictInterface = t.strictInterface
local v5 = {
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
local v6 = if fFlagUnifyShortcutBarFixImpressions then t.optional(t.number) else nil
v5.shortcutBarHeight = v6
extended.validateProps = strictInterface(v5)

local v7 = memoize(function(p2, p3, p4, p5)
	return {
		min = Vector2.new(0, p2),
		max = Vector2.new(p3.X, p3.Y - p4.bottom - (fFlagUnifyShortcutBarFixImpressions and p5 or 0))
	}
end)

function extended.render(p2)
	local screenSize = p2.props.screenSize
	local topBarHeight = p2.props.topBarHeight
	local globalGuiInset = p2.props.globalGuiInset

	local createElement = Roact.createElement
	local v9 = {
		parentRef = p2.props.parentRef,
		impressionsTag = p2.props.impressionsTag,
		onRequestImpressionsSignal = p2.props.onRequestImpressionsSignal,
		viewPortBounds = 0,
		filterImpressionFunc = 0,
		onImpressionsDetected = 0,
		skipZeroSizes = 0
	}

	local v11 = if fFlagUnifyShortcutBarFixImpressions then p2.props.shortcutBarHeight else nil
	v9.viewPortBounds = v7(topBarHeight, screenSize, globalGuiInset, v11)

	v9.filterImpressionFunc = p2.props.filterImpressionFunc
	v9.onImpressionsDetected = p2.props.onImpressionsDetected
	v9.skipZeroSizes = p2.props.skipZeroSizes
	return createElement(ImpressionsDetector, v9)
end

local v8 = RoactRodux.connect(function(data, p2)
	return {
		topBarHeight = data.TopBar.topBarHeight,
		globalGuiInset = data.GlobalGuiInset,
		screenSize = data.ScreenSize
	}
end)(extended)

if fFlagUnifyShortcutBarFixImpressions then
	return function(p2)
		local v9 = SignalsReact.useSignalState(getShortcutBarStatusStore(false).getShortcutBarReservedHeight)

		return Roact.createElement(v8, Cryo.Dictionary.join(p2, {
			shortcutBarHeight = v9
		}))
	end
end

return v8
