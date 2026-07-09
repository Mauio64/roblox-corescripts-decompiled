local Parent = script:FindFirstAncestor("BuildExperience").Parent
local AppNavBar = require(Parent.AppNavBar)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useNavBarSize = AppNavBar.useNavBarSize

local function useBuildPageLayout() -- line: 18
	-- upvalues: useTokens (copy), useNavBarPlacement (copy), useNavBarSize (copy), useSelector (copy), AppNavBar (copy)
	local v8 = useTokens()
	local v9 = useNavBarPlacement()
	local v10 = useNavBarSize()
	local v11 = useSelector(function(p1) -- line: 22
		return p1.TabBarVisible
	end)

	return {
		tokens = v8,
		topBarHeight = v10,
		shouldIncludeBottomBar = v9 == AppNavBar.Placement.Bottom and v11 ~= false
	}
end

return useBuildPageLayout
