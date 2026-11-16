local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")
local ImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTracker")
local ImpressionsTrackerWithoutNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTrackerWithoutNavigation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Navigation").useNavigation

local useViewportBounds = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/ViewportUtils").useViewportBounds
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SignalsReact")
local getShortcutBarStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/AppShortcutBarStore").GetShortcutBarStatusStore
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SharedFlags")

local fFlagUnifyShortcutBarFixImpressions = SharedFlags.FFlagUnifyShortcutBarFixImpressions
local fFlagOptionalNavigation = SharedFlags.FFlagOptionalNavigation

return function(props)
	local v5 = if fFlagOptionalNavigation then useNavigation() else nil
	local v6

	if fFlagUnifyShortcutBarFixImpressions then
		v6 = SignalsReact.useSignalState(getShortcutBarStatusStore(false).getShortcutBarReservedHeight)
	end

	local ignoreBottomInset = props.ignoreBottomInset

	if not fFlagUnifyShortcutBarFixImpressions then
		v6 = nil
	end

	local v10 = useViewportBounds(nil, ignoreBottomInset, nil, v6)

	local v11 = {
		pageContext = props.pageContext,
		parentRef = props.parentRef,
		impressionsTag = props.impressionsTag,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = props.sendImpressions,
		dataUpdatedTimestamp = props.dataUpdatedTimestamp,
		viewPortBounds = v10
	}

	if not fFlagOptionalNavigation or v5 ~= nil then
		return React.createElement(ImpressionsTracker, v11)
	end

	v11.pageContext = nil
	return React.createElement(ImpressionsTrackerWithoutNavigation, v11)
end
