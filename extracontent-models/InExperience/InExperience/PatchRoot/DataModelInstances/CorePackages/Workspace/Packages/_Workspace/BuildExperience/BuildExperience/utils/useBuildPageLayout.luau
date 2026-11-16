local parent = script:FindFirstAncestor("BuildExperience").Parent

local AppNavBar = require(parent.AppNavBar)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavBarPlacement = AppNavBar.useNavBarPlacement

local function useBuildPageLayout()
	local tokens = useTokens()
	local v = useNavBarPlacement()
	local v2 = useSelector(function(p)
		return p.TabBarVisible
	end)

	return {
		tokens = tokens,
		topBarHeight = 56 * tokens.Config.UI.Scale,
		shouldIncludeBottomBar = v == AppNavBar.Placement.Bottom and v2 ~= false
	}
end

return useBuildPageLayout
