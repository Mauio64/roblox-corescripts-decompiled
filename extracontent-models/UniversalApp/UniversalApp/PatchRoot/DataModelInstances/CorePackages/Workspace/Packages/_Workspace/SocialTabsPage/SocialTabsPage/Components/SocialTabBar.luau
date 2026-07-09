local Parent = script:FindFirstAncestor("SocialTabsPage").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View
local useNavigation = require(Parent.Navigation).useNavigation

local function SocialTabBar(t1: {[any]: any}) -- line: 19
	-- upvalues: useNavigation (copy), React (copy), View (copy), Tabs (copy), InputSize (copy), FillBehavior (copy)
	local v11 = useNavigation()
	local routeName = v11.state.routes[v11.state.index].routeName
	local v13, v14 = React.useState(routeName)
	local v15 = React.useCallback(function(p1) -- line: 24
		-- upvalues: v14 (copy), v11 (copy)
		v14(p1)
		v11.navigate(p1)
	end, { v11 })

	React.useEffect(function() -- line: 29
		-- upvalues: v14 (copy), routeName (copy)
		v14(function(p2) -- line: 30
			-- upvalues: routeName (copy)
			if p2 ~= routeName then
				return routeName
			end

			return p2
		end)
	end, { routeName })

	return React.createElement(View, {
		tag = "size-full-0 auto-y bg-surface-0",
		LayoutOrder = t1.layoutOrder
	}, {
		SocialTabs = React.createElement(Tabs, {
			activeTabId = v13,
			size = InputSize.Medium,
			fillBehavior = FillBehavior.Fill,
			onActivated = v15,
			tabs = t1.tabs
		})
	})
end

return SocialTabBar
