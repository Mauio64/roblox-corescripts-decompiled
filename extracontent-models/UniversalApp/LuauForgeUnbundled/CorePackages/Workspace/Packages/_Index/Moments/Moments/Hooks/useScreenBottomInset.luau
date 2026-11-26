local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AppNavBar")
local AppSystemBar = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AppSystemBar")
local FFlagMomentsFeedAboveNavBar = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedAboveNavBar")

local useNavBarSize = AppNavBar.useNavBarSize
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local placement = AppNavBar.Placement

local function useScreenBottomInset()
	local v5 = useNavBarPlacement()
	local v6 = useNavBarSize()

	if FFlagMomentsFeedAboveNavBar then
		v6 = AppSystemBar.Constants.BOTTOM_BAR_SIZE
	end

	if v5 == placement.Bottom then
		return v6
	end

	return 0
end

return useScreenBottomInset
