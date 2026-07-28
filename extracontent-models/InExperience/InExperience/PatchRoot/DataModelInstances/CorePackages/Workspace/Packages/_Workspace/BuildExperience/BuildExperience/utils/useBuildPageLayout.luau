local Parent = script:FindFirstAncestor("BuildExperience").Parent
local AppNavBar = require(Parent.AppNavBar)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useNavBarPlacement = AppNavBar.useNavBarPlacement

local function useBuildPageLayout() -- line: 19
	-- upvalues: useTokens (copy), useNavBarPlacement (copy), useSelector (copy), AppNavBar (copy)
	local v7 = useTokens()
	local v8 = useNavBarPlacement()
	local v9 = useSelector(function(p1) -- line: 22
		return p1.TabBarVisible
	end)

	return {
		tokens = v7,
		topBarHeight = 56 * v7.Config.UI.Scale,
		shouldIncludeBottomBar = v8 == AppNavBar.Placement.Bottom and v9 ~= false
	}
end

return useBuildPageLayout
