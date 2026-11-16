local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/RoactRodux")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/t")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SignalsReact")
local getShortcutBarStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AppShortcutBarStore").GetShortcutBarStatusStore
local fFlagUnifyShortcutBarFixImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SharedFlags").FFlagUnifyShortcutBarFixImpressions

local AvatarExperienceImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AvatarExperienceImpressionsDetector")

local extended = Roact.PureComponent:extend("AvatarExperienceScreenSizeImpressionsDetector")

local strictInterface = t.strictInterface
local v5 = {
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
local v6 = if fFlagUnifyShortcutBarFixImpressions then t.optional(t.number) else nil
v5.shortcutBarHeight = v6
extended.validateProps = strictInterface(v5)

function extended.render(p2)
	local screenSize = p2.props.screenSize
	local topBarHeight = p2.props.topBarHeight
	local globalGuiInset = p2.props.globalGuiInset
	local shortcutBarHeight = fFlagUnifyShortcutBarFixImpressions and p2.props.shortcutBarHeight or 0

	return Roact.createElement(AvatarExperienceImpressionsDetector, {
		parentRef = p2.props.parentRef,
		onRequestImpressionsSignal = p2.props.onRequestImpressionsSignal,
		viewPortBounds = {
			min = Vector2.new(0, topBarHeight),
			max = Vector2.new(screenSize.X, screenSize.Y - globalGuiInset.bottom - shortcutBarHeight)
		},
		appPage = p2.props.appPage,
		pageFilter = p2.props.pageFilter,
		collectObjectsFunc = p2.props.collectObjectsFunc,
		filterImpressionFunc = p2.props.filterImpressionFunc,
		onImpressionsDetected = p2.props.onImpressionsDetected
	})
end

local v7 = RoactRodux.connect(function(data, p2)
	return {
		topBarHeight = data.TopBar.topBarHeight,
		globalGuiInset = data.GlobalGuiInset,
		screenSize = data.ScreenSize
	}
end)(extended)

if fFlagUnifyShortcutBarFixImpressions then
	return function(p2)
		local v8 = SignalsReact.useSignalState(getShortcutBarStatusStore(false).getShortcutBarReservedHeight)

		return Roact.createElement(v7, Cryo.Dictionary.join(p2, {
			shortcutBarHeight = v8
		}))
	end
end

return v7
