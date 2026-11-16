local parent = script:FindFirstAncestor("InExperienceShop").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop

return game:DefineFastFlag("SkipPaymentSessionForPlainRobux", false) and FFlagEnableRobuxInExperienceShop
