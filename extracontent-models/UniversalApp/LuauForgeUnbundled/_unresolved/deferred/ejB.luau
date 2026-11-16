local module = require("@luauforge/deferred/ejq")
local module2 = require("@luauforge/deferred/ejr")

local useNavigation = require("@luauforge/deferred/ejA").useNavigation

local fFlagAppThemeHalloween2026FriendsBackground = require("@luauforge/deferred/ejC").FFlagAppThemeHalloween2026FriendsBackground
local useThemeBackground = require("@luauforge/deferred/ejD").useThemeBackground

local tabs = module2.Tabs
local fillBehavior = module2.Enums.FillBehavior
local inputSize = module2.Enums.InputSize

local module3 = require("@luauforge/deferred/ejE")
local useCoHubAnalytics = module3.useCoHubAnalytics
local eventNames = module3.EventNames

return function(p2)
	local v5 = useNavigation()
	local routeName = v5.state.routes[v5.state.index].routeName
	local state, setState = module.useState(routeName)

	local v6 = if fFlagAppThemeHalloween2026FriendsBackground then useThemeBackground() ~= nil else false

	local fireAnalyticsEvent = useCoHubAnalytics().fireAnalyticsEvent
	local v7 = module.useCallback(function(p3)
		fireAnalyticsEvent(eventNames.CoHubTabClicked, { subpage = state, btn = p3 })

		setState(p3)
		v5.navigate(p3)
	end, { v5, setState })

	module.useEffect(function()
		if routeName ~= state then
			setState(routeName)
		end
	end, { routeName })

	return module.createElement(module2.View, {
		tag = fFlagAppThemeHalloween2026FriendsBackground and {
			["size-full-1200"] = true,
			["bg-surface-0"] = not v6
		} or "size-full-1200 bg-surface-0",
		LayoutOrder = p2.layoutOrder
	}, {
		ConnectionsTabs = module.createElement(tabs, {
			activeTabId = state,
			size = inputSize.Medium,
			fillBehavior = fillBehavior.Fill,
			onActivated = v7,
			tabs = p2.tabs
		})
	})
end
