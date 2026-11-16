local parent = script:FindFirstAncestor("SocialTabsPage").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local function SocialTabBar(p)
	local v = useNavigation()
	local routeName = v.state.routes[v.state.index].routeName
	local state, setState = React.useState(routeName)

	local onActivated = React.useCallback(function(p2)
		setState(p2)
		v.navigate(p2)
	end, { v })

	React.useEffect(function()
		setState(function(p2)
			return if p2 == routeName then p2 else routeName
		end)
	end, { routeName })

	return React.createElement(View, {
		tag = "size-full-0 auto-y bg-surface-0",
		LayoutOrder = p.layoutOrder
	}, {
		SocialTabs = React.createElement(Tabs, {
			activeTabId = state,
			size = InputSize.Medium,
			fillBehavior = FillBehavior.Fill,
			onActivated = onActivated,
			tabs = p.tabs
		})
	})
end

return SocialTabBar
