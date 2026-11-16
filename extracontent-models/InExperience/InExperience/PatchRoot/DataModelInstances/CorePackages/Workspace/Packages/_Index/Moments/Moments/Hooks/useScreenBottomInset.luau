local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local AppNavBar = require(parent.AppNavBar)
local AppSystemBar = require(parent.AppSystemBar)
local FFlagMomentsFeedAboveNavBar = require(Moments.Flags.FFlagMomentsFeedAboveNavBar)

local useNavBarSize = AppNavBar.useNavBarSize
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local Placement = AppNavBar.Placement

local function useScreenBottomInset()
	local v = useNavBarPlacement()
	local v2 = useNavBarSize()

	if FFlagMomentsFeedAboveNavBar then
		v2 = AppSystemBar.Constants.BOTTOM_BAR_SIZE
	end

	return if v == Placement.Bottom then v2 else 0
end

return useScreenBottomInset
