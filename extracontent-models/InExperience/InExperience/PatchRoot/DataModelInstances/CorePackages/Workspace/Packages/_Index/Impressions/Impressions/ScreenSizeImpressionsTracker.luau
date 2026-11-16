local parent = script:FindFirstAncestor("Impressions").Parent
local React = require(parent.React)
local ImpressionsTracker = require(script.Parent.ImpressionsTracker)
local ImpressionsTrackerWithoutNavigation = require(script.Parent.ImpressionsTrackerWithoutNavigation)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local ViewportUtils = require(parent.ViewportUtils)
local useViewportBounds = ViewportUtils.useViewportBounds
local SignalsReact = require(parent.SignalsReact)
local AppShortcutBarStore = require(parent.AppShortcutBarStore)
local GetShortcutBarStatusStore = AppShortcutBarStore.GetShortcutBarStatusStore
local SharedFlags = require(parent.SharedFlags)

local FFlagUnifyShortcutBarFixImpressions = SharedFlags.FFlagUnifyShortcutBarFixImpressions
local FFlagOptionalNavigation = SharedFlags.FFlagOptionalNavigation

return function(props)
	local v

	if FFlagOptionalNavigation then
		v = useNavigation()
	end

	local v2

	if FFlagUnifyShortcutBarFixImpressions then
		v2 = SignalsReact.useSignalState(GetShortcutBarStatusStore(false).getShortcutBarReservedHeight)
	end

	local ignoreBottomInset = props.ignoreBottomInset

	if not FFlagUnifyShortcutBarFixImpressions then
		v2 = nil
	end

	local viewPortBounds = useViewportBounds(nil, ignoreBottomInset, nil, v2)

	local v3 = {
		pageContext = props.pageContext,
		parentRef = props.parentRef,
		impressionsTag = props.impressionsTag,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = props.sendImpressions,
		dataUpdatedTimestamp = props.dataUpdatedTimestamp,
		viewPortBounds = viewPortBounds
	}

	if not FFlagOptionalNavigation or v ~= nil then
		return React.createElement(ImpressionsTracker, v3)
	end

	v3.pageContext = nil
	return React.createElement(ImpressionsTrackerWithoutNavigation, v3)
end
