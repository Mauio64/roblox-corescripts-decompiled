require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Navigation")

require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/types")

local function selectNavigationState(p2)
	return p2.Navigation
end

return {
	selectCurrentRoactNavigationRoute = function(p2)
		return p2.Navigation.currentRoute
	end,
	selectLegacyHistory = function(p2)
		return p2.Navigation.history
	end,
	selectNavigationLocked = function(p2)
		return p2.Navigation.lockNavigationActions
	end,
	selectBackNavigationDisableCounter = function(p2)
		return p2.Navigation.backNavigationDisableCounter
	end,
	selectCurrentPageName = function(p2)
		local history = p2.Navigation.history

		local v5 = history[#history]

		return v5[#v5].name
	end,
	selectCurrentLegacyRoute = function(p2)
		local history = p2.Navigation.history

		return history[#history]
	end,
	selectCurrentLegacyPage = function(p2)
		local history = p2.Navigation.history

		local v5 = history[#history]

		return v5[#v5]
	end
}
