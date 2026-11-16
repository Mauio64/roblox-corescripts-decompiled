local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local constants = require(VerifiedBadges.constants)

local function appendPremiumBadge(p: string)
	return p .. constants.PREMIUM_EMOJI
end

return appendPremiumBadge
