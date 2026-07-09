local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local ReactNavigationExtend = TenFootUiShell.ReactNavigationExtend
local React = require(TenFootUiShellParent.React)

require(TenFootUiShellParent.TenFootUiCommon)

local TenFootUiSwitchViewCard = require(ReactNavigationExtend.Views.Cards.TenFootUiSwitchViewCard)

require(TenFootUiShellParent.Navigation)

local function useTabIndeces(n1: number) -- line: 15
	-- upvalues: React (copy)
	local v9, v10 = React.useState({
		current = n1,
		previous = n1
	})

	React.useEffect(function() -- line: 21
		-- upvalues: v10 (copy), n1 (copy)
		v10(function(p1) -- line: 22
			-- upvalues: n1 (copy)
			if n1 ~= p1.current then
				return {
					current = n1,
					previous = p1.current
				}
			end

			return p1
		end)
	end, { n1 })

	return v9.current, v9.previous
end
local function TenFootUiSwitchView(t1: {[any]: any}) -- line: 45
	-- upvalues: useTabIndeces (copy), React (copy), TenFootUiSwitchViewCard (copy)
	local descriptors = t1.descriptors
	local navigation = t1.navigation
	local state = navigation.state
	local key = state.routes[state.index].key
	local index = state.index
	local v17, v18 = useTabIndeces(index)
	local t2 = {}

	for v20, v21 in descriptors do
		t2[v20] = React.createElement(TenFootUiSwitchViewCard, {
			descriptor = v21,
			screenProps = t1.screenProps,
			navigation = navigation,
			isActiveTab = v20 == key,
			currentTabIndex = v17,
			previousTabIndex = v18
		})
	end

	return React.createElement(React.Fragment, nil, t2)
end

return TenFootUiSwitchView
