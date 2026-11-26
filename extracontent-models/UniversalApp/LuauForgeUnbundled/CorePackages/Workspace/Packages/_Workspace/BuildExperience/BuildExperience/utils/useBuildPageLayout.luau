local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppNavBar")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation").Hooks.useTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils").Hooks.RoactRodux.useSelector
local useNavBarPlacement = AppNavBar.useNavBarPlacement

local function useBuildPageLayout()
	local v5 = useTokens()
	local v6 = useNavBarPlacement()
	local v7 = useSelector(function(p2)
		return p2.TabBarVisible
	end)

	return {
		tokens = v5,
		topBarHeight = 56 * v5.Config.UI.Scale,
		shouldIncludeBottomBar = v6 == AppNavBar.Placement.Bottom and v7 ~= false
	}
end

return useBuildPageLayout
