local NavigationRodux = script:FindFirstAncestor("NavigationRodux")

require(NavigationRodux.Parent.Navigation)
require(NavigationRodux.types)

local function selectNavigationState(p1) -- line: 13
	return p1.Navigation
end

return {
	selectCurrentRoactNavigationRoute = function(p2) -- line: 17
		return p2.Navigation.currentRoute
	end,
	selectLegacyHistory = function(p3) -- line: 21
		return p3.Navigation.history
	end,
	selectNavigationLocked = function(p4) -- line: 35
		return p4.Navigation.lockNavigationActions
	end,
	selectBackNavigationDisableCounter = function(p5) -- line: 39
		return p5.Navigation.backNavigationDisableCounter
	end,
	selectCurrentPageName = function(p6) -- line: 43
		local history = p6.Navigation.history
		local v15 = history[#history]

		return v15[#v15].name
	end,
	selectCurrentLegacyRoute = function(p7) -- line: 25
		local history = p7.Navigation.history

		return history[#history]
	end,
	selectCurrentLegacyPage = function(p8) -- line: 30
		local history = p8.Navigation.history
		local v10 = history[#history]

		return v10[#v10]
	end
}
