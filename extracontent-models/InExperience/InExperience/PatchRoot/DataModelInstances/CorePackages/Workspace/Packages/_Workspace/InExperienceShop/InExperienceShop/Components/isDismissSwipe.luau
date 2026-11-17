local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

local FIntFreeTrialTopBarChipSwipeThreshold = require(InExperienceShop.Flags.FIntFreeTrialTopBarChipSwipeThreshold)

local function isDismissSwipe(p: number, p2: number): boolean
	return FIntFreeTrialTopBarChipSwipeThreshold <= math.abs(p) and math.abs(p) > math.abs(p2)
end

return isDismissSwipe
