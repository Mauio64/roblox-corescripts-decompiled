local ConnectionsHub = script:FindFirstAncestor("ConnectionsHub")
local ConnectionsHubParent = ConnectionsHub.Parent
local React = require(ConnectionsHubParent.React)
local Foundation = require(ConnectionsHubParent.Foundation)
local useNavigation = require(ConnectionsHubParent.Navigation).useNavigation
local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local Analytics = require(ConnectionsHub.Analytics)
local useCoHubAnalytics = Analytics.useCoHubAnalytics
local EventNames = Analytics.EventNames

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useNavigation (copy), React (copy), useCoHubAnalytics (copy), EventNames (copy), Foundation (copy), Tabs (copy), InputSize (copy), FillBehavior (copy)
	local v13 = useNavigation()
	local routeName = v13.state.routes[v13.state.index].routeName
	local v15, v16 = React.useState(routeName)
	local fireAnalyticsEvent = useCoHubAnalytics().fireAnalyticsEvent
	local v18 = React.useCallback(function(p1) -- line: 27
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v15 (copy), v16 (copy), v13 (copy)
		fireAnalyticsEvent(EventNames.CoHubTabClicked, {
			subpage = v15,
			btn = p1
		})
		v16(p1)
		v13.navigate(p1)
	end, {
		v13,
		v16
	})

	React.useEffect(function() -- line: 36
		-- upvalues: routeName (copy), v15 (copy), v16 (copy)
		if routeName ~= v15 then
			v16(routeName)
		end
	end, { routeName })

	return React.createElement(Foundation.View, {
		tag = "size-full-1200 bg-surface-0",
		LayoutOrder = t1.layoutOrder
	}, {
		ConnectionsTabs = React.createElement(Tabs, {
			activeTabId = v15,
			size = InputSize.Medium,
			fillBehavior = FillBehavior.Fill,
			onActivated = v18,
			tabs = t1.tabs
		})
	})
end
