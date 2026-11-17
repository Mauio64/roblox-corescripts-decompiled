local parent = script:FindFirstAncestor("Impressions").Parent
local React = require(parent.React)
local ImpressionsTracker = require(script.Parent.ImpressionsTracker)
local ImpressionsTrackerWithoutNavigation = require(script.Parent.ImpressionsTrackerWithoutNavigation)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local ViewportUtils = require(parent.ViewportUtils)
local useViewportBounds = ViewportUtils.useViewportBounds
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)
local AppShortcutBarStore = require(parent.AppShortcutBarStore)
local GetShortcutBarStatusStore = AppShortcutBarStore.GetShortcutBarStatusStore

local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local FFlagUnifyShortcutBarFixImpressions = SharedFlags.FFlagUnifyShortcutBarFixImpressions
local FFlagOptionalNavigation = SharedFlags.FFlagOptionalNavigation
local FFlagLuaAppSduiGameDwell = SharedFlags.FFlagLuaAppSduiGameDwell

return function(props)
	local v

	if FFlagOptionalNavigation then
		v = useNavigation()
	end

	local v2

	if FFlagUnifyShortcutBarFixImpressions then
		v2 = SignalsReact.useSignalState(GetShortcutBarStatusStore(false).getShortcutBarReservedHeight)
	end

	local viewPortFillBounds = nil
	local viewPortBounds

	if FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		local parentRef = props.parentRef
		local respectClipAncestors

		if FFlagLuaAppRespectClipAncestorImpressions then
			respectClipAncestors = props.respectClipAncestors
		end

		if not FFlagUnifyShortcutBarFixImpressions then
			v2 = nil
		end

		viewPortBounds, viewPortFillBounds = useViewportBounds(parentRef, nil, respectClipAncestors, v2)
	else
		local parentRef = props.parentRef
		local respectClipAncestors

		if FFlagLuaAppRespectClipAncestorImpressions then
			respectClipAncestors = props.respectClipAncestors
		end

		if not FFlagUnifyShortcutBarFixImpressions then
			v2 = nil
		end

		viewPortBounds = useViewportBounds(parentRef, nil, respectClipAncestors, v2)
	end

	local v3 = {
		pageContext = props.pageContext,
		parentRef = props.parentRef,
		impressionsTag = props.impressionsTag,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = props.sendImpressions,
		dataUpdatedTimestamp = props.dataUpdatedTimestamp,
		viewPortBounds = viewPortBounds,
		viewPortFillBounds = 0
	}

	if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		viewPortFillBounds = nil
	end

	v3.viewPortFillBounds = viewPortFillBounds

	if FFlagLuaAppSduiGameDwell then
		v3.visibilityObserver = props.visibilityObserver
	end

	if not FFlagOptionalNavigation or v ~= nil then
		return React.createElement(ImpressionsTracker, v3)
	end

	v3.pageContext = nil
	return React.createElement(ImpressionsTrackerWithoutNavigation, v3)
end
