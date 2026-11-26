local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")
local ImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTracker")
local ImpressionsTrackerWithoutNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTrackerWithoutNavigation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/Navigation").useNavigation
local useViewportBounds = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/ViewportUtils").useViewportBounds
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SignalsReact")
local getShortcutBarStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/AppShortcutBarStore").GetShortcutBarStatusStore

local fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local fFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local fFlagUnifyShortcutBarFixImpressions = SharedFlags.FFlagUnifyShortcutBarFixImpressions
local fFlagOptionalNavigation = SharedFlags.FFlagOptionalNavigation
local fFlagLuaAppSduiGameDwell = SharedFlags.FFlagLuaAppSduiGameDwell

return function(props)
	local v5 = if fFlagOptionalNavigation then useNavigation() else nil
	local v6

	if fFlagUnifyShortcutBarFixImpressions then
		v6 = SignalsReact.useSignalState(getShortcutBarStatusStore(false).getShortcutBarReservedHeight)
	end

	local v7 = nil
	local v8

	if fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		local parentRef = props.parentRef

		local respectClipAncestors = if fFlagLuaAppRespectClipAncestorImpressions then props.respectClipAncestors else nil

		if not fFlagUnifyShortcutBarFixImpressions then
			v6 = nil
		end

		v8, v7 = useViewportBounds(parentRef, nil, respectClipAncestors, v6)
	else
		local parentRef = props.parentRef

		local respectClipAncestors = if fFlagLuaAppRespectClipAncestorImpressions then props.respectClipAncestors else nil

		if not fFlagUnifyShortcutBarFixImpressions then
			v6 = nil
		end

		v8 = useViewportBounds(parentRef, nil, respectClipAncestors, v6)
	end

	local v9 = {
		pageContext = props.pageContext,
		parentRef = props.parentRef,
		impressionsTag = props.impressionsTag,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = props.sendImpressions,
		dataUpdatedTimestamp = props.dataUpdatedTimestamp,
		viewPortBounds = v8,
		viewPortFillBounds = 0
	}

	if not fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		v7 = nil
	end

	v9.viewPortFillBounds = v7

	if fFlagLuaAppSduiGameDwell then
		v9.visibilityObserver = props.visibilityObserver
	end

	if not fFlagOptionalNavigation or v5 ~= nil then
		return React.createElement(ImpressionsTracker, v9)
	end

	v9.pageContext = nil
	return React.createElement(ImpressionsTrackerWithoutNavigation, v9)
end
