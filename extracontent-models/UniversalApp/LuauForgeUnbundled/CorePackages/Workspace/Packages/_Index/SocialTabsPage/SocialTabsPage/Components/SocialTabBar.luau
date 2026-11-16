local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Foundation")

local tabs = Foundation.Tabs
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local view = Foundation.View

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Navigation").useNavigation

local function SocialTabBar(p2)
	local v5 = useNavigation()
	local routeName = v5.state.routes[v5.state.index].routeName
	local state, setState = React.useState(routeName)

	local v6 = React.useCallback(function(p3)
		setState(p3)
		v5.navigate(p3)
	end, { v5 })

	React.useEffect(function()
		setState(function(p3)
			if p3 == routeName then
				return p3
			end

			return routeName
		end)
	end, { routeName })

	return React.createElement(
		view,
		{ tag = "size-full-0 auto-y bg-surface-0", LayoutOrder = p2.layoutOrder },
		{
			SocialTabs = React.createElement(tabs, {
				activeTabId = state,
				size = inputSize.Medium,
				fillBehavior = fillBehavior.Fill,
				onActivated = v6,
				tabs = p2.tabs
			})
		}
	)
end

return SocialTabBar
